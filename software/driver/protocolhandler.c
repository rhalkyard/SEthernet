/*
SEthernet and SEthernet/30 Driver

Copyright (C) 2023-2024 Richard Halkyard

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "protocolhandler.h"

#include "driver.h"

#include "enc624j600.h"

#if defined(DEBUG)
#include <Debugging.h>
#include <stdio.h>
extern char strbuf[255];
extern void ReadPacket();
extern void * header_start;
#endif

/*
Find a protocol-handler table entry matching protocol number 'theProtocol'.
Returns a pointer to the entry or nil if no match found.

We (arbitrarily) support 16 protocol handler entries, but in practice, most
systems will only ever have a maximum of 3 handlers active - the LAP manager,
and the ARP and IP handlers for MacTCP. This is too few to justify the overhead
of a proper hash table over linear search.

As an optimization, we maintain the protocol handler table as contiguous - new
handlers are installed to the first free entry, and the table is compacted when
handlers are uninstalled.
*/
protocolHandlerEntry *findPH(const driverGlobalsPtr theGlobals,
                             const unsigned short theProtocol) {
  for (unsigned short i = 0; i < numberOfPhs; i++) {
    if (theGlobals->protocolHandlers[i].ethertype == theProtocol) {
      return &theGlobals->protocolHandlers[i];
    } else if (theGlobals->protocolHandlers[i].ethertype == phProtocolFree) {
      return nil;
    }
  }
  return nil;
}

/* Find a free entry in the protocol-handler table. Returns a pointer to the
entry or nil if no free entries available. */
static protocolHandlerEntry *findFreePH(const driverGlobalsPtr theGlobals) {
  for (unsigned short i = 0; i < numberOfPhs; i++) {
    if (theGlobals->protocolHandlers[i].ethertype == phProtocolFree) {
      return &theGlobals->protocolHandlers[i];
    }
  }
  return nil;
}

/*
EAttachPH call (a.k.a. Control with csCode=ENetAttachPH)

Attach a protocol handler to our driver.

Note that software MUST provide a protocol-handler routine for us to call here.
It is legal for software to pass in a nil pointer for this routine, indicating
that they will use ERead to read packets instead. However this feature seems to
be little-used, and this driver does not implement ERead.
*/
OSStatus doEAttachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  unsigned short theProtocol;
  protocolHandlerEntry *thePHSlot;
  OSErr error = noErr;

  /* Disable ethernet interrupts so that the ISR won't see the protocol handler
  table in an inconsistent state */
  unsigned short old_eie = enc624j600_disable_irq(&theGlobals->chip, IRQ_ENABLE);

  theProtocol = pb->u.EParms1.eProtType;
  if (theProtocol > 0 && theProtocol <= 1500) {
    /* Not a valid ethertype (note that we reserve the invalid ethertype 0 for
    handling 802.2 Type 1 packets) */
  #if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. Invalid.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    error = lapProtErr;
    goto done;
  }
  if (findPH(theGlobals, theProtocol) != nil) {
    /* Protocol handler already installed*/
#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. Protocol in use.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    error = lapProtErr;
    goto done;
  }
  if (pb->u.EParms1.ePointer == nil) {
    /* TODO: support ERead */

#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install ENetRead handler for protocol %04x. Not implemented.", theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    error = lapProtErr;
    goto done;
  }

  /* Find an empty slot in the protocol handler table */
  thePHSlot = findFreePH(theGlobals);

  if (thePHSlot == nil) {
#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. No free slots.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    error = lapProtErr;
    goto done;
  } else {
  /* install the handler */
    thePHSlot->ethertype = theProtocol;
    thePHSlot->handler = (void *)pb->u.EParms1.ePointer;
    // thePHSlot->readPB = -1; /* not used */
  }
done:

  enc624j600_enable_irq(&theGlobals->chip, old_eie);
  return error;
}

/*
EDetachPH call (a.k.a. Control with csCode=ENetDetachPH)

Detach a protocol handler from our driver.

Once again, if we supported ERead we would need to do some cleanup of pending
calls, but we don't, so we don't.
*/
OSStatus doEDetachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  protocolHandlerEntry * thePHSlot;
  OSErr error = noErr;

  /* Disable ethernet interrupts so that the ISR won't see the protocol handler
  table in an inconsistent state */
  unsigned short old_eie = enc624j600_disable_irq(&theGlobals->chip, IRQ_ENABLE);

  thePHSlot = findPH(theGlobals, pb->u.EParms1.eProtType);
  if (thePHSlot != nil) {
    thePHSlot->ethertype = phProtocolFree;
    thePHSlot->handler = nil;
    // if (thePHSlot->readPB != -1){
    //     /* Cancel pending ERead calls */
    // }

    /* Compact the protocol-handler table */
    for (unsigned short i = 0; i < numberOfPhs - 1; i++) {
      if (theGlobals->protocolHandlers[i].ethertype == phProtocolFree) {
        if (theGlobals->protocolHandlers[i+1].ethertype != phProtocolFree) {
          theGlobals->protocolHandlers[i] = theGlobals->protocolHandlers[i+1];
          theGlobals->protocolHandlers[i+1].ethertype = phProtocolFree;
        }
      }
    }
  } else {
    error = lapProtErr;
  }
  enc624j600_enable_irq(&theGlobals->chip, old_eie);

  return error;
}

/*
Initialize the protocol handler table, called during initial Open routine.
*/
void InitPHTable(driverGlobalsPtr theGlobals) {
    for (unsigned short i = 0; i < numberOfPhs; i++) {
        theGlobals->protocolHandlers[i].ethertype = phProtocolFree;
        theGlobals->protocolHandlers[i].handler = nil;
        // theGlobals->protocolHandlers[i].readPB = -1; /* not used */
    }
}
