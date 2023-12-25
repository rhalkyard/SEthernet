#include "driver.h"

#include <AppleTalk.h>
#include <Devices.h>
#include <ENET.h>
#include <Errors.h>
#include <Events.h>
#include <Gestalt.h>
#include <MacTypes.h>
#include <Resources.h>
#include <Retro68Runtime.h>
#include <ROMDefs.h>
#include <ShutDown.h>
#include <Slots.h>
#include <Traps.h>

#include "enc624j600.h"
#include "enc624j600_registers.h"
#include "isr.h"
#include "multicast.h"
#include "protocolhandler.h"
#include "registertools.h"
#include "util.h"
#include "version.h"

#if defined(TARGET_SE30)
#include "sethernet30_board_defs.h"
#elif defined(TARGET_SE)
#include "sethernet_board_defs.h"
#endif

#if defined(DEBUG)
#include <Debugging.h>
#include <stdio.h>
extern char strbuf[255];
extern void ReadPacket();
extern void * header_start;
#endif

/*
EWrite (a.k.a.) Control called with csCode=ENetWrite

Initiate transmission of an ethernet frame. This function is asynchronous and
returns as soon as the frame has been copied into the transmit buffer and
transmission has been started. Completion is signaled through a
transmit-complete or transmit-aborted interrupt.

The Device Manager handles the queueing of writes for us and won't issue another
ENetWrite until the last one has signaled completion.

The frame data is given as a Write Data Structure (WDS) - a list of
address-length pairs like an iovec, we need to read from each one in sequence,
the end of the WDS is signaled by an entry with a zero length. The ethernet
header is already prepared for us, we just have to write our hardware address
into the source field.
*/
static OSErr doEWrite(const driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  WDSElement *wds; /* a WDS is a list of address-length pairs like an iovec */
  unsigned long totalLength; /* total length of frame */
  Byte *dest;

#if defined(DEBUG)
  /* Shouldn't ever happen unless something has gone very wrong */
  if (ENC624J600_READ_REG(theGlobals->chip.base_address, ECON1) & ECON1_TXRTS) {
    DebugStr("\pTransmit while already transmitting!");
  }
#endif

  /* Scan through WDS list entries to compute total length */
  wds = (WDSElement *)pb->u.EParms1.ePointer;
  totalLength = 0;
  do {
    totalLength += wds->entryLength;
    wds++;
  } while (wds->entryLength);

  /* Block transmission of oversized or unreasonably short frames. (Add 4 bytes
  to calculated length to account for FCS field generated by ethernet
  controller) */
  if (totalLength + 4 > 1518 || totalLength < 14) {
  #if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "TX: bogus length %lu bytes!", totalLength);
    DebugStr((unsigned char *)strbuf);
  #endif
    return eLenErr;
  }

  /* Restore WDS pointer to start of list */
  wds = (WDSElement *)pb->u.EParms1.ePointer;
  dest = enc624j600_addr_to_ptr(&theGlobals->chip, ENC_TX_BUF_START);

  /* Copy data from WDS into transmit buffer */
  do {
    enc624j600_memcpy(dest, (Byte *)wds->entryPtr, wds->entryLength);
    dest += wds->entryLength;
    wds++;
  } while (wds->entryLength > 0);

  /* Go back and copy our address into the source field */
  dest = enc624j600_addr_to_ptr(&theGlobals->chip, ENC_TX_BUF_START + 6);
  enc624j600_memcpy(dest, theGlobals->info.ethernetAddress, 6);

  if (theGlobals->chip.link_state == LINK_DOWN) {
    /* don't bother trying to send packets on a down link */
    return excessCollsns;
  }

  debug_log(theGlobals, txEvent, totalLength);
  /* Send it! */
  enc624j600_transmit(&theGlobals->chip, theGlobals->chip.base_address,
                      totalLength);

  /* Return >0 to indicate operation in progress */
  return 1;
}

/*
Shutdown procedure

Set to run at shutdown by ShutDwnInstall.

Mitigation for issue #4 (rev0 hardware produces spurious interrupts on warm
restart). Annoyingly, there is no good way to pass data to a shutdown procedure,
so we have to figure out where our cards are ourselves.
*/
static void doShutdown(void) {
  enc624j600 chip;
#if defined(TARGET_SE30)
  /* SEthernet/30: Use the Slot Manager to search for Functional sResources
  that look like SEthernet/30 cards */

  SpBlock spb = {.spCategory = catNetwork,
                 .spCType = typeEtherNet,
                 .spDrvrSW = SETHERNET30_DRSW,
                 .spDrvrHW = SETHERNET30_DRHW,
                 .spTBMask = 0,
                 .spSlot = 1,
                 .spID = 1,
                 .spExtDev = 0};

  while (SGetTypeSRsrc(&spb) == noErr) {
    if (SFindDevBase(&spb) == noErr) {
      chip.base_address = (unsigned char *) spb.spResult;
      enc624j600_reset(&chip);
    } 
  }
#elif defined(TARGET_SE)
  /* SEthernet: if we've gotten this far, just YOLO it and assume that the card
  is there. We're shutting down anyway, so who cares? */
  chip.base_address = (unsigned char *) ENC624J600_BASE;
  enc624j600_reset(&chip);
#endif
}

/*
Entrypoint for Open call.

Called whenever software opens the ethernet driver, regardless of whether it is
already open.

If driver is not open, allocate storage, initialize data structures, and set the
chip up.

If driver is already open, do nothing.
*/
#pragma parameter __D0 driverOpen(__A0, __A1)
OSErr driverOpen(__attribute__((unused)) EParamBlkPtr pb, AuxDCEPtr dce) {
  driverGlobalsPtr theGlobals;
  Handle eadrResourceHandle;
  OSErr error;
  SysEnvRec sysEnv;

  /* 'panic button' - hold down the E key at boot (or any other time the driver
  is loaded) to disable the driver (or drop into the debugger in debug builds),
  just in case we get into a state where the driver is stopping the system from
  booting. Note that this must be inline code and not a function, since we want
  to break before relocation */
  const unsigned char keycode = 0x0e; /* keyboard scan code for E key */
  unsigned char keys[16];
  GetKeys((unsigned long *)keys);
  /* Test bit corresponding to keyboard scan code */
  if ((keys[keycode>>3] >> (keycode & 0x7)) & 1) {
#if defined(DEBUG)
    Debugger();
#else
    return -1;
#endif
  }

  error = noErr;

  if (dce->dCtlStorage == nil) {
    /* 
    Unlike classic Mac OS toolchains, Retro68 does NOT generate
    position-independent code, and if you use -mpcrel to force it to, it'll
    appear to work for simple programs but start to come unraveled as things get
    more complicated (specifically, libgcc is not built with -mpcrel, so the
    libgcc calls that gcc emits for, say, optimized math operations, will cause
    a crash).

    For simplicity's sake, it's much easier to just live with relocation rather
    than fighting it.

    For applications, the Retro68 runtime automatically relocates us at startup,
    but for non-application code such as a driver, we have to call the relocator
    ourselves before we can access global and static variables, or call
    functions.
    */
    RETRO68_RELOCATE();

    theGlobals = (driverGlobalsPtr)NewPtrSysClear(sizeof(driverGlobals));
    if (!theGlobals) {
      error = MemError();
#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Couldn't allocate %lu bytes for globals!", 
                        sizeof(driverGlobals));
    DebugStr((unsigned char *)strbuf);
#endif
    } else {
      error = noErr;

      /* dCtlStorage is technically a Handle, but since its use is entirely
      user-defined we can just treat it as a pointer */
      dce->dCtlStorage = (Handle)theGlobals;

#if defined(DEBUG)
      /* Define some macros pointing at interesting parts of our globals */
      strbuf[0] = sprintf(strbuf+1, ";MC driverGlobals '%08x'"
                          ";MC driverLog '%08x'"
                          ";MC driverLogHead '%08x'"
                          ";g", 
                          (unsigned int) theGlobals,
                          (unsigned int) &theGlobals->log.entries,
                          (unsigned int) &theGlobals->log.head);
      DebugStr((unsigned char *) strbuf);
      /* Define macro to dump the debug event log */
      DebugStr("\p;MC dumpLog 'dm driverLog (@driverLogHead + 1) * 4' ;g");
#endif

      if (trapAvailable(_Gestalt)) {
        theGlobals->hasGestalt = 1;
      }

      if (trapAvailable(_SlotManager)) {
        theGlobals->hasSlotMgr = 1;
      }

      SysEnvirons(curSysEnvVers, &sysEnv);
      if (sysEnv.machineType == envSE) {
        theGlobals->macSE = 1;
      }

#if defined(TARGET_SE30)
      /* SEThernet/30 driver requires the Slot Manager */
      if (!(theGlobals->hasSlotMgr)) {
        error = openErr;
        goto done;
      }

      /* Set up chip base address the clever way. We could manually compute the
      address from the slot number in dCtlSlot, but that means that we have to
      hard-code the location of the chip in the card's address space.
      dCtlDevBase points at the slot base address (i.e. Fs00 0000), with an
      optional offset defined by sResources. This means that cards with
      different address decoding will work with this driver so long as they have
      appropriate sResources (MinorBaseOS and/or MajorBaseOS) in ROM. */
      theGlobals->chip.base_address = (void *)dce->dCtlDevBase;

      /* It's a ridiculous edge case, but the SE/30 can run System 6.0.3, while
      the Gestalt Manager was only introduced in 6.0.4. VM wasn't introduced
      until System 7, so if we don't have the Gestalt Manager, we can assume
      that we're not running with VM */
      if (theGlobals->hasGestalt) {
        long gestaltResult;
        /* Check if running under virtual memory, make ourselves VM-safe if so.
        See 'Driver Considerations for Virtual Memory' in Technote NW-13 */
        if ((Gestalt(gestaltVMAttr, &gestaltResult) == noErr) &&
            (gestaltResult & (1 << gestaltVMPresent))) {
          theGlobals->vmEnabled = 1;
          /* Ask the memory manager to not page our data out */
          HoldMemory(theGlobals, sizeof(driverGlobals));
          dce->dCtlFlags |= dVMImmuneMask; /* Tell the OS that we're VM-safe */
        }
      }
#elif defined(TARGET_SE)
      /* Check to make sure we're actually running on a Macintosh SE */
      if (! (theGlobals->macSE)) {
        error = openErr;
        goto done;
      }
      /* SE: base address is hardcoded. */
      theGlobals->chip.base_address = (unsigned char *) SETHERNET_BASEADDR;
#endif

      /* Before we go any further, check to see if the ENC624J600 is actually
      there */
      if (enc624j600_detect(&theGlobals->chip) != 0) {
        error = openErr;
        goto done;
      }

      /* Save our device control entry - we need this to signal completion of IO
      at interrupt time */
      theGlobals->driverDCE = dce;

      if (dce->dCtlFlags & dRAMBasedMask) {
        /* If loaded via a Handle, detach our driver resource. This means that
        the Resource Manager can no longer 'see' it, preventing it from being
        changed, released, etc. Unfortunately this also means that Macsbug's
        heap analyzer can no longer identify it either :( */
        DetachResource((Handle)dce->dCtlDriver);
      }

      /* Initialize protocol-handler table */
      InitPHTable(theGlobals);

      /* Reset the chip */
      if (enc624j600_reset(&theGlobals->chip) != 0) {
        error = openErr;
        goto done;
      }

      /* Wait for the chip to come back after the reset. According to the
      datasheet, we must delay 25us for bus interface and MAC registers to come
      up, plus an additional 256us for the PHY. I'm not aware of any easy way to
      delay with that kind of granularity, so just busy-wait for 1 tick */
      waitTicks(1);

      /* Test the chip's memory just to be *really* sure it's working */
      if (enc624j600_memtest(&theGlobals->chip) != 0) {
        error = openErr;
        goto done;
      }

      /* Initialize the ethernet controller. */
      if (enc624j600_init(&theGlobals->chip, ENC_RX_BUF_START) != 0) {
        error = openErr;
        goto done;
      }

      /* Install a shutdown procedure to reset the ENC624J600 as mitigation for
      issue #4 (rev0 hardware produces spurious interrupts on warm restart) */
      ShutDwnInstall(doShutdown, sdRestartOrPower);

      /* Figure out our ethernet address. First we look for an 'eadr' resource
      with an ID corresponding to our slot. If one exists, we save it to our
      globals, and write it into the chip. Otherwise, we read the chip's address
      (which the reset above restored to its factory-assigned value) into our
      globals. */
      eadrResourceHandle = GetResource(EAddrRType, dce->dCtlSlot);
      if (eadrResourceHandle) {
        copyEthAddrs(theGlobals->info.ethernetAddress, (Byte *)*eadrResourceHandle);
        enc624j600_write_hwaddr(&theGlobals->chip, (Byte *)*eadrResourceHandle);
        ReleaseResource(eadrResourceHandle);
      } else {
        enc624j600_read_hwaddr(&theGlobals->chip,
                               theGlobals->info.ethernetAddress);
      }

#if defined(TARGET_SE30)
      /* Install our interrupt handler using the Slot Manager */
      theGlobals->theSInt.sqType = sIQType;
      theGlobals->theSInt.sqPrio = 199; /* priority >=200 is reserved for Apple */
      theGlobals->theSInt.sqAddr = isrWrapper;
      theGlobals->theSInt.sqParm = (long)theGlobals;
      error = SIntInstall(&theGlobals->theSInt, dce->dCtlSlot);
      if (error != noErr) {
        goto done;
      }
#elif defined(TARGET_SE)
      isrGlobals = theGlobals;
      /* No Slot Manager on the SE, we hook the Level 1 Interrupt vector. Very
      Commodore 64-style. Level 1 is normally used by the VIA and SCSI
      controller, so we have to coexist with them. */
      asm (
        /* Mask interrupts while we change out interrupt vectors */
        "   MOVE.W  %%sr, -(%%sp) \n\t"
        "   ORI.W   %[srMaskInterrupts], %%sr  \n\t"
        /* Save the original vector*/
        "   MOVE.L  %[isrVector], %[originalInterruptVector]  \n\t"
        /* Install our own */
        "   MOVE.L  %[isrWrapper], %[isrVector]  \n\t"
        /* Restore interrupts */
        "   MOVE.W  (%%sp)+, %%sr"
        : [originalInterruptVector] "=m" (originalInterruptVector)
        : [isrWrapper] "i" (isrWrapper),
          /* status register bits to set priority 7, masking all interrupts */
          [srMaskInterrupts] "i" (0x700),
          /* Location of our interrupt vector in the 68000's vector table at the 
          start of RAM. Interrupt vectors run from 0x64 for Level 1 to 0x7C for
          Level 7. */
          [isrVector] "m" (*(Byte *) (0x64 + (SETHERNET_INTERRUPT - 1) * 4))
      );
#endif
      /* Let's go! */
      enc624j600_start(&theGlobals->chip);
      enc624j600_enable_irq(&theGlobals->chip,
                            IRQ_ENABLE | IRQ_LINK | IRQ_PKT | IRQ_RX_ABORT |
                                IRQ_PCNT_FULL | IRQ_TX | IRQ_TX_ABORT);
    }
  } else {
    /* Driver was already open, nothing to do */
    error = noErr;
  }
done:
  if (error != noErr) {
    if (dce->dCtlStorage != nil) {
      DisposePtr((Ptr) dce->dCtlStorage);
      dce->dCtlStorage = nil;
    }
}

  return error;
}

/*
Entrypoint for Close call

Ethernet drivers don't generally get closed, as drivers don't (can't?) implement
reference counting and software has no way of knowing if other software is using
it. Still, drivers all seem to implement some kind of token shutdown procedure.
*/
#pragma parameter __D0 driverClose(__A0, __A1)
OSErr driverClose(__attribute__((unused)) EParamBlkPtr pb, AuxDCEPtr dce) {
  driverGlobalsPtr theGlobals = (driverGlobalsPtr)dce->dCtlStorage;

  /* Reset the chip; this is just a 'big hammer' to stop transmitting, disable
  receive, disable interrupts etc. */
  enc624j600_reset(&theGlobals->chip);

#if defined(TARGET_SE30)
  /* Uninstall our slot interrupt handler */
  SIntRemove(&theGlobals->theSInt, dce->dCtlSlot);

  if (theGlobals->vmEnabled) {
    /* Unpin if running with virtual memory */
    UnholdMemory(theGlobals, sizeof(driverGlobals));
  }
#elif defined(TARGET_SE)
  asm volatile (
    /* Mask interrupts while we change out interrupt vectors */
    "MOVE.W  %%sr, -(%%sp) \n\t"
    "ORI.W   %[srMaskInterrupts], %%sr  \n\t"
    /* Restore the original interrupt vector */
    "MOVE.L  %[originalInterruptVector], 0x64  \n\t"
    /* Restore interrupts */
    "MOVE.W  (%%sp)+, %%sr"
    :
    : [originalInterruptVector] "m" (originalInterruptVector),
      [srMaskInterrupts] "i" (0x700)
  );
#endif

  DisposePtr((Ptr)theGlobals);
  dce->dCtlStorage = nil;

  return noErr;
}

/*
Control entrypoint

This is where the magic happens. Dispatch to various operations based on the
csCode in the parameter block.

Note that control operations can be asynchronous! The wrapper code in header.s
handles this for us, all we need to do is return a value <=0 when returning
synchronously (0 for success, <0 for error) or >0 for async operations that will
be completed by a later IODone call.
*/
#pragma parameter __D0 driverControl(__A0, __A1)
OSErr driverControl(EParamBlkPtr pb, AuxDCEPtr dce) {
  driverGlobalsPtr theGlobals = (driverGlobalsPtr)dce->dCtlStorage;
  switch (pb->csCode) {
    case ENetDelMulti: /* Delete address from multicast table */
      return doEDelMulti(theGlobals, pb);
    case ENetAddMulti: /* Add address to multicast table */
      return doEAddMulti(theGlobals, pb);
    case ENetAttachPH: /* Attach receive handler for ethertype */
      return doEAttachPH(theGlobals, pb);
    case ENetDetachPH: /* Detach receive handler for ethertype */
      return doEDetachPH(theGlobals, pb);
    case ENetRead:       /* Read packets directly without a handler routine */
#if defined(DEBUG)
      DebugStr("\pENetRead not implemented!");
#endif
      return controlErr; /* TODO: support this */
    case ENetRdCancel:   /* Cancel a pending ENetRead */
#if defined(DEBUG)
      DebugStr("\pENetRdCancel not implemented!");
#endif
      return controlErr; /* TODO: support this */
    case ENetWrite:      /* Send packet */
      return doEWrite(theGlobals, pb);
    case ENetGetInfo: /* Read hardware address and statistics */
      /* We use an extended version of the driver info struct with some extra
      fields tacked onto the end. Note that we do not have counters for all the
      standard fields. */
      if (pb->u.EParms1.eBuffSize > (short) sizeof(theGlobals->info)) {
        pb->u.EParms1.eBuffSize = sizeof(theGlobals->info);
      }

      BlockMoveData(&theGlobals->info, pb->u.EParms1.ePointer,
                    pb->u.EParms1.eBuffSize);
      return noErr;

    case ENetSetGeneral: /* Enter 'general mode' */
      /* ENEtSetGeneral tells the driver to prepare to transmit general Ethernet
      packets rather than only AppleTalk packets. Drivers can use this to
      rearrange TX/RX buffer boundaries for the longer maximum frame length
      (1536 vs. 768 bytes). We have enough buffer to always operate in general
      mode, so this is a no-op. */
      return noErr;

#if 0
    /* I've seen these csCodes in the wild but my headers don't define them, and
    some drivers (e.g. MACE) that do include them don't actually do anything
    with them. Probably safe to just not implement I guess? */
    case EGetDot3Entry:
    case ESetDot3Entry:
    case EGetDot3Statistics:
    case EGetDot3CollStats:
    case LapGetLinkStatus:
      return noErr;
    case ENetEnablePromiscuous:
    case ENetDisablePromiscuous:
      reeturn controlErr;
#endif

#if 0
    /* Custom csCodes for debugging this driver. */
    case ENCReadReg: /* Read ENC624J600 register */
      return doENCReadReg(theGlobals, (CntrlParamPtr)pb);
    case ENCWriteReg: /* Write ENC624J600 register */
      return doENCWriteReg(theGlobals, (CntrlParamPtr)pb);
    case ENCReadPhy: /* Read ENC624J600 PHY register */
      return doENCReadPhy(theGlobals, (CntrlParamPtr)pb);
    case ENCWritePhy: /* Write ENC624J600 PHY register */
      return doENCWritePhy(theGlobals, (CntrlParamPtr)pb);
    case ENCEnableLoopback: /* Enable PHY internal loopback */
      return doENCEnableLoopback(theGlobals);
    case ENCDisableLoopback: /* Disable PHY internal loopback */
      return doENCDisableLoopback(theGlobals);
#endif

    default:
#if defined(DEBUG)
      strbuf[0] = sprintf(strbuf + 1,
                        "Unhandled csCode %d", pb->csCode);
      DebugStr((unsigned char *) strbuf);
#endif
      return controlErr;
  }
}

#if defined(DEBUG)
void debug_log(driverGlobals *theGlobals, logEvent eventType,
               unsigned short eventData) {
  eventLog *log = &theGlobals->log;

  /* Disable interrupts so that log operations are atomic */
  unsigned short srSave;
  asm("MOVE.W  %%sr, %[srSave] \n\t"
      "ORI.W   %[srMaskInterrupts], %%sr  \n\t"
      : [srSave] "=dm"(srSave)
      : [srMaskInterrupts] "i"(0x700));

  log->entries[log->head].eventType = eventType;
  log->entries[log->head].eventData = eventData;

  log->head = (log->head + 1) % LOG_LEN;
  /* Make head of log buffer look distinctive so that we can spot it in a dump */
  log->entries[log->head].eventType = 0xffff;
  log->entries[log->head].eventData = 0xffff;

  /* Restore processor state */
  asm volatile("MOVE.W  %[srSave], %%sr \n\t" : : [srSave] "dm"(srSave));
}
#endif
