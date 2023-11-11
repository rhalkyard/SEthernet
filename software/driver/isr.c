#include "isr.h"

#include <Debugging.h>

#include "driver.h"
#include "enc624j600.h"
#include "multicast.h"
#include "protocolhandler.h"

#if defined(TARGET_SE)
/* I really wanted to keep register-poking abstracted out of the core driver
code, but on the SE we need to examine the interrupt status in the
assembly-language wedge for the interrupt vector */
#include "enc624j600_registers.h"

/* Dirty macro-quoting tricks to inject the status register's address into our
inline asm*/
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)
#define ESTAT_ADDR ENC624J600_BASE + ESTAT

/* The original level-1 interrupt vector. If the interrupt fires but we don't
have a pending interrupt flag, we pass the interrupt through to it*/
void (*originalInterruptVector)();

/* Pointer to driver globals so our ISR can reference them */
driverGlobalsPtr isrGlobals;
#endif

/*
ReadPacket and ReadRest are called by protocol handlers to copy data from
the receive FIFO into their own buffers. Their calling conventions and register
usage are particularly awkward, hence implementing them in asm.

ReadPacket reads a given number of bytes from the packet. ReadRest does the
same, but signals completion to the driver and discards any remaining unread
data. Protocol handlers can call ReadPacket any number of times, but they MUST
call ReadRest once (and only once) when they are finished with a packet.

The address of ReadPacket must be in A4 when the protocol handler is called.
DO NOT CALL THIS FUNCTION FROM THE DRIVER.

On entry:
  A0: Pointer to globals (guaranteed preserved by protocol handler)
  A1: Unused, but guaranteed preserved by protocol handler.
  A3: buffer to write into
  D1: number of bytes remaining (*** IM only documents this for AppleTalk
      .MPP protocol handlers, but looking at the MACE driver, ethernet
      does this too ***)
  D3: maximum number of bytes to read

On exit:
  A0-A2: Preserved
  A3: updated buffer pointer (byte following last byte)
  A4-A5: Preserved
  D0: clobbered
  D1: number of bytes remaining
  D2: preserved
  D3: 0 if requested number of bytes read
      <0 if packet was (-D3) bytes too large to fit in buffer (ReadRest)
      >0 if D3 bytes weren't read
  D4-D7: Preserved
*/
static void ReadPacket() {
  asm volatile(
      /* ReadRest is defined to start two bytes after ReadPacket */
      "   BRA        RealReadPacket_%=\n\t"
      /* ReadRest */
      "   MOVE.W     %%D3, %%D0\n\t" /* d0 = d3 = maximum number of bytes to
                                      * read */
      "   CMP.W      %%D1, %%D3\n\t"
      "   BLS        SizeOK1_%=\n\t" /* if d3 >= number of bytes remaining... */
      "   MOVE.W     %%D1, %%D0\n"   /* read all remaining bytes */
      "SizeOK1_%=:\n\t"
      "   SUB.W      %%D0, %%D3\n\t"
      "   TST.W      %%D0\n\t"        /* if read length is zero... */
      "   BEQ        ReadDone_%=\n\t" /* nothing more to do */
      "   BSR        ReadBuf\n"       /* otherwise read some bytes*/
      "   BRA        ReadDone_%=\n\t"

      "RealReadPacket_%=:\n\t"
      "   MOVE.W     %%D3, %%D0\n\t" /* size check as above */
      "   CMP.W      %%D1, %%D3\n\t"
      "   BLS        SizeOK2_%=\n\t"
      "   MOVE.W     %%D1, %%D0\n"
      "SizeOK2_%=:\n\t"
      "   SUB.W      %%D0, %%D3\n\t"
      "   SUB.W      %%D0, %%D1\n\t"
      "   TST.W      %%D0\n\t"
      "   BEQ        ReadDone_%=\n\t"
      "   BSR        ReadBuf\n"
      "ReadDone_%=:\n\t"
      :
      :
      :);
}

/*
Copy routine used internally by ReadBuf, broken out into a separate function
for clarity. Don't call this!

On entry:
  A1: Source address
  A3: Destination address
  D0: Number of bytes to read

Internal:
  D0: Loop counter
  D5: Saved read length

On exit:
  A1: 1 byte past last byte read
  A3: 1 byte past last byte written
  D0: destroyed
  D5: destroyed
  D6: destroyed
*/
__attribute__((used)) static void ReadChunk(void) {
  asm volatile(
      /* Check for starting address word-alignment */
      "   MOVE.W     %%A1, %%D5\n\t"
      "   BTST       #0, %%D5\n\t"
      "   BEQ        evenRead_%=\n\t"

      /* if start is not word-aligned, read 1 byte before entering loop */
      "   SUBQ.W     #1, %%A1\n\t"
      "   MOVE.W     (%%A1)+, %%D5\n\t"
      "   MOVE.B     %%D5, (%%A3)+\n\t"
      "   SUBQ.W     #1, %%D0\n"
      "evenRead_%=:\n\t"
      /* Set up loop */
      "   MOVE.W     %%D0, %%D5\n\t" /* D0 is loop counter; save read length for
                                     later */
      "   LSR.W      #2, %%D0\n\t"   /* we're reading 4 bytes per iteration,
                                     divide counter by 4 */
      "   BRA        loopCnt_%=\n"
      "readLoop_%=:\n\t"
      /* Read 4 bytes at a time. Presumably using MOVE.Ws to avoid having to
      handle both word and long alignment cases */
      "   MOVE.W     (%%A1)+, (%%A3)+\n\t"
      "   MOVE.W     (%%A1)+, (%%A3)+\n"
      "loopCnt_%=:\n\t"
      "   DBRA       %%D0, readLoop_%=\n\t"

      /* fixup read length */
      "   BTST       #1, %%D5\n\t"
      "   BEQ        finishByte_%=\n\t"
      "   MOVE.W     (%%A1)+, (%%A3)+\n" /* handle extra word */
      "finishByte_%=:\n\t"
      "   BTST       #0, %%D5\n\t"
      "   BEQ        chunkDone_%=\n\t"
      "   MOVE.B     (%%A1)+, (%%A3)+\n" /* handle extra byte */
      "chunkDone_%=:"
      :
      :
      :);
}

/*
ReadBuf: copy from receive FIFO into memory

Weird ugly asm code in order to comply with the awkward register usage specified
for ReadPacket/ReadRest.

On entry:
  A0: Pointer to driver globals
  A3: Destination buffer
  D0: Number of bytes to read

  theGlobals->rx_read_ptr pointing to first byte to read from RX FIFO

Internal:
  D0: Byte count for ReadChunk (used by ReadChunk call)
  D5: Used by ReadChunk
  D6: Temporary byte count when splitting a wraparound read

On exit:
  A0: Preservd
  A1: Receive FIFO read pointer (1 byte after last read location)
  A2: Preserved
  A3: Updated destination pointer
  D0: Destroyed

  theGlobals->rx_read_ptr pointing to byte following last byte read
  enc624j600 RX tail pointing to last whole word read (i.e. 2-3 bytes behind
    rx_read_ptr)
*/
#pragma parameter __A1 ReadBuf(__A0, __A3, __D0)
Byte *ReadBuf(driverGlobalsPtr theGlobals, Byte *dest, unsigned short len) {
  register Byte *src asm("a1");
  asm volatile(
      "   MOVEM.L    %%D5-%%D6, -(%%SP)\n\t"
      "   MOVE.L     %[readptr],%%A1\n\t"
      "   MOVE.L     %[rxbuf_end], %%D6\n\t"

      /* handle wraparound of circular buffer and split read into chunks if
         needed */
      "   SUB.L      %%A1, %%D6\n\t"
      "   BLS        OneAndDone_%=\n\t" /* Non-wrapping read, just one chunk */
      "   SUB.W      %%D6, %%D0\n\t"    /* Set up first half of wrapped read */
      "   EXG        %%D6, %%D0\n\t"
      "   BSR        ReadChunk\n\t" /* Read first chunk */

      /* Set up for second half and fall through to non-wrapping case */
      "   MOVE.W     %%D6, %%D0\n\t"
      "   MOVEA.L    %[rxbuf_start], %%A1\n"

      "OneAndDone_%=:\n\t"
      "   BSR        ReadChunk\n\t"
      "   MOVEM.L    (%%SP)+, %%D5-%%D6\n\t" /* Done with temporary registers */
      "   MOVE.L     %%A1, %[readptr]\n\t" /* update read pointer in globals */

      /* update ENC624J600 RX tail pointer to free up buffer space as we read */
      "   MOVEM.L    %%A0-%%A1/%%D0-%%D2,-(%%SP)\n\t" /* save call-clobbered
                                                         regs */
      "   MOVE.L     %%A1, -(%%SP)\n\t"
      "   MOVE.L     %[chip], -(%%SP)\n\t"
      "   BSR        enc624j600_update_rx_tail\n\t" /* (&theGlobals->chip, A1)
                                                     */
      "   ADDQ.L     #8, %%SP\n\t"
      "   MOVEM.L    (%%SP)+, %%A0-%%A1/%%D0-%%D2\n\t"

      : "=r"(dest), "=r"(src), "+r"(len)
      : [readptr] "m"(theGlobals->rx_read_ptr),
        [rxbuf_start] "m"(theGlobals->chip.rxbuf_start),
        [rxbuf_end] "m"(theGlobals->chip.rxbuf_end),
        [chip] "m"(theGlobals->chip)
      :);
  return src;
}

/*
Wrapper to call protocol handlers from C.

Protocol handlers have an unusual register-based calling convention - it's
obvious that ethernet ISRs are intended to be all handcoded asm, but who's got
the time for that?

On protocol handler entry:
  A0: driver-specific ReadPacket argument (pointer to driver globals)
  A1: driver-specific ReadPacket argument (pointer to protocol handler)
  A3: pointer into Receive Header Area, immediately after the header bytes
  A4: pointer to ReadPacket/ReadRest routine
  D1: number of bytes remaining in packet

The handler calls ReadPacket/ReadRest with the above register definitions, but
may return with them destroyed.

On protocol handler exit:
  A0-A4: destroyed
  D0-D3: destroyed

C assumes that A0-A1 and D0-D2 will be destroyed, we just need to save A2, A3,
and D3.
*/
#pragma parameter __D0 callPH(__A0, __A1, __A3, __A4, __D1)
static void callPH(driverGlobalsPtr theGlobals, void *phProc, Byte *payloadPtr,
                   void (*readPacketProc)(), unsigned short payloadLen) {
  /* make our register arguments look used */
  (void)(theGlobals);
  (void)(phProc);
  (void)(payloadPtr);
  (void)(readPacketProc);
  (void)(payloadLen);

  /* C calling conventions expect A0-A1, D0-D2 to be clobbered by functions
  anyway. Only save the extra clobbered registers (A2, A3, D3). */
  asm("MOVEM    %A2-%A3/%D3, -(%SP)\n\t"
      "JSR      (%A1)\n\t"
      "MOVEM    (%SP)+, %A2-%A3/%D3");
}

/* Handle a packet from the receive FIFO */
static void handlePacket(driverGlobalsPtr theGlobals) {
  unsigned short
      nextPkt_chip; /* address (in chip space) of next packet. LITTLE-ENDIAN.*/
  enc624j600_rsv rsv;            /* Receive status vector */
  Byte *destMac;                 /* Destination ethernet address */
  unsigned short *protocol;      /* Protocol number/ethertype */
  unsigned short pktLen;         /* Length of packet */
  unsigned short bytesPending;   /* Number of bytes pending in receive FIFO */
  unsigned short packetsPending; /* Number of packets pending in receive FIFO */
  protocolHandlerEntry *protocolSlot; /* Protocol handler */

  Byte *rhaPtr = theGlobals->recvHeaderArea;  /* Pointer into header buffer */

  /* this should have been set for us already, but just to make sure ... */
  if (theGlobals->rx_read_ptr != theGlobals->nextPkt) {
    DebugStr("\pstarting a new packet in the wrong place!");
  }

  /* Record some FIFO stats */
  packetsPending = enc624j600_read_rx_pending_count(&theGlobals->chip);
  if (packetsPending > theGlobals->info.rxPendingPacketsHWM) {
    theGlobals->info.rxPendingPacketsHWM = packetsPending;
  }
  bytesPending = enc624j600_read_rx_fifo_level(&theGlobals->chip);
  if (bytesPending > theGlobals->info.rxPendingBytesHWM) {
    theGlobals->info.rxPendingBytesHWM = bytesPending;
  }

  /*
  ENC624J600 receive FIFO entry layout (in ascending address order):

    2 bytes         pointer to next entry (relative to chip base address)
    6 bytes         receive status vector
    64-1518 bytes   layer 2 frame
  */
  /* Read next-packet pointer*/
  ReadBuf(theGlobals, (Byte *)&nextPkt_chip, sizeof(nextPkt_chip));
  /* Next-packet pointer is little-endian and relative to the chip
  address space. Convert this to a 'real' pointer. */
  theGlobals->nextPkt =
      enc624j600_addr_to_ptr(&theGlobals->chip, SWAPBYTES(nextPkt_chip));

  /* Read packet length */
  ReadBuf(theGlobals, (Byte *)&rsv, sizeof(rsv));
  pktLen = SWAPBYTES(rsv.pkt_len_le);
  /* pktLen is the entire length of the layer 2 frame, including padding and
  CRC*/
  if (pktLen > 1518 || pktLen < 64) {
    /* Packet too long or short. These shouldn't make it past our receive
    filters, but drop them here just in case. */
    goto drop;
  }

  /* The actual frame starts here. Read the destination, source, and ethertype
  into the Receive Header Area */
  ReadBuf(theGlobals, rhaPtr, 6 * sizeof(unsigned short));
  destMac = rhaPtr;
  rhaPtr += 6;

  ReadBuf(theGlobals, rhaPtr, 6 * sizeof(unsigned short));
  /* sourceMac = rhaPtr; */
  rhaPtr += 6;

  ReadBuf(theGlobals, rhaPtr, sizeof(protocol));
  protocol = (unsigned short *)rhaPtr;
  rhaPtr += 2;

  /* An ethertype field of < 0x600 indicates an 802.2 Type 1 frame (Ethernet
  Phase II in Apple parlance). We assign this the protocol number 0. The LAP
  manager always registers itself as the handler for this protocol. */
  if (*protocol < 0x0600) {
    *protocol = phProtocolPhaseII;
  }

  /* Search the protocol-handler table for a handler for this ethertype */
  protocolSlot = findPH(theGlobals, *protocol);
  if (protocolSlot == nil) {
    /* no handler for this protocol, drop it */
    goto drop;
  }

  /* Sanity-check our receive filters */
  if (RSV_BIT(rsv, RSV_BIT_UNICAST) || RSV_BIT(rsv, RSV_BIT_BROADCAST)) {
    /* Destination is broadcast or unicast to us */
    goto accept;
  } else if (RSV_BIT(rsv, RSV_BIT_HASH_MATCH) &&
             RSV_BIT(rsv, RSV_BIT_MULTICAST)) {
    /* Destination is multicast AND address hash matches a multicast we're
    listening to */
    if (findMulticastEntry(theGlobals, destMac)) {
      /* Actual destination address matches a multicast we're listening to */
      goto accept;
    } else {
      /* Multicast hash collision */
      theGlobals->info.stdInfo.rxIncorectAddressCount++;
      goto drop;
    }
  } else {
    /* Hash collision with a non-multicast address */
    theGlobals->info.stdInfo.rxIncorectAddressCount++;
    goto drop;
  }

accept:
  theGlobals->info.rxPackets++;
  theGlobals->info.rxBytes += pktLen;

  /* Call the protocol handler to read the rest of the packet */
  callPH(theGlobals, protocolSlot->handler, rhaPtr, ReadPacket, pktLen - 18);

drop:
  /* finished with packet, discard any remaining data by advancing read pointer
  and rx buffer tail to the start of the next packet */
  theGlobals->rx_read_ptr = theGlobals->nextPkt;
  enc624j600_update_rx_tail(&theGlobals->chip, theGlobals->nextPkt - 2);

  /* decrement pending-receive counter */
  enc624j600_decrement_rx_pending_count(&theGlobals->chip);
}

/* User-memory-accessing section of ISR, called through DeferUserFn on VM
systems. Enters with IRQs already disabled, must re-enable them on exit. */
static void userISR(driverGlobalsPtr theGlobals) {
  short irq_status = enc624j600_read_irqstate(&theGlobals->chip);

  if (irq_status & IRQ_TX) {
    /* Transmit complete; signal successful completion */
    IODone((DCtlPtr)theGlobals->driverDCE, noErr);
    enc624j600_clear_irq(&theGlobals->chip, IRQ_TX);
  }

  if (irq_status & IRQ_TX_ABORT) {
    /*
    Transmit aborted due to one of:
      - Collision count exceeded MACLCON_MAXRET (count in ETXSTAT_COLCNT)
      - Collision occurred after 63 bytes transmitted (ETXSTAT_LATECOL set)
      - Medium was busy, transmission deferred for longer than timeout
        (ETXSTAT_EXDEFER set)
      - Transmit aborted in software by clearing ECON1_TXRTS

    Not sure how best to express these so for simplicity let's just call them
    all timeouts.
    */
    theGlobals->info.stdInfo.txTimeoutCount++;
    IODone((DCtlPtr)theGlobals->driverDCE, excessCollsns);
    enc624j600_clear_irq(&theGlobals->chip, IRQ_TX_ABORT);
  }

  if (irq_status & IRQ_PKT) {
    /* We have pending packets. Handle them. */
    do {
      handlePacket(theGlobals);
    } while (enc624j600_read_rx_pending_count(&theGlobals->chip));

    /* IRQ_PKT flag is not directly clearable, it is cleared when
    pending-receive counter reaches zero */
  }

  enc624j600_enable_irq(&theGlobals->chip, IRQ_ENABLE);
}

/*
Our interrupt service routine - actually just a wrapper that calls the 'real'
_driverISR() routine below.

On the SE/30, we register our ISR with the Slot Manager, so all we need to do is
wrap it in some MOVEMs to preserve the right registers.

On the SE, there is no system-provided mechanism to register expansion-hardware
ISRs, so we hijack the vector for the interrupt level we use (Level 1). Level 1
is also used by the VIA, so our ISR must query the card's interrupt status, and
decide whether to service it with _driverISR() or jump to the original Level 1
vector to service a VIA interrupt.
*/
void driverISR() {
#if defined(TARGET_SE30)
  /*
  SE/30: register-preservation wrapper for slot interrupt

  On entry:
    A1: contents of Slot Interrupt Queue entry sqParm field

  On exit:
    A1: destroyed
    A0,A2-6: preserved
    D0: 1 if IRQ was handled, 0 otherwise
    D1-D7: preserved

  C always saves A2-A6 and D3-D7, so we just need to save A0, D1, D2.
  */
  asm("MOVEM %A0/%D1-%D2, -(%SP)\n\t"
      "BSR _driverISR\n\t"
      "MOVEM (%sp)+, %A0/%D1-%D2");
#elif defined(TARGET_SE)
  asm volatile (
    /* Read the ENC624J600 EIR register to see if we have an interrupt from it */
    "   MOVE.W  %%d0, -(%%sp) \n\t"
    /* Have to pull some dirty macro-stringification tricks here because gcc
    *really* doesn't want me to poke at memory directly like this */
    "   MOVE.W  " STR(ESTAT_ADDR) ", %%d0  \n\t"
    "   ANDI.W  %[estat_int_mask], %%d0  \n\t"
    "   BEQ     not_us_%= \n\t"

    /* We have an interrupt waiting: call our ISR */
    "   MOVEM   %%a0-%%a1/%%d1-%%d2,  -(%%sp) \n\t"
    "   LEA     isrGlobals(%%pc), %%a1 \n\t"
    "   BSR     _driverISR  \n\t"
    "   MOVEM   (%%sp)+, %%a0-%%a1/%%d1-%%d2\n\t"
    "   MOVE.W  (%%sp)+, %%d0  \n\t"
    "   RTE\n"

    /* The interrupt wasn't us: chain through to the original vector */
    "not_us_%=:\n\t"
    "   MOVE.W  (%%sp)+, %%d0  \n\t"
    "   MOVE.L  originalInterruptVector(%%pc), -(%%sp)  \n\t"
    "   RTS"  /* push-and-RTS is apparently the quickest way to jump through a
              vector in memory. Once again, shades of the C64 here */
    :
    : [estat_int_mask] "n" (ESTAT_INT)
  );
#endif
}

/* The 'real' interrupt handler, called by driverISR above. */
#pragma parameter __D0 _driverISR(__A1)
__attribute__((used)) static unsigned long _driverISR(
    driverGlobalsPtr theGlobals) {
  unsigned short irq_status;
  int irq_handled = 0;

  /* Mask all interrupts inside ISR */
  enc624j600_disable_irq(&theGlobals->chip, IRQ_ENABLE);
  irq_status = enc624j600_read_irqstate(&theGlobals->chip);

  if (irq_status & IRQ_LINK) {
    /* Link status has changed; update MAC duplex configuration to match
    autonegotiated PHY values */
    enc624j600_duplex_sync(&theGlobals->chip);
    enc624j600_clear_irq(&theGlobals->chip, IRQ_LINK);
    irq_handled = 1;
  }

  if (irq_status & (IRQ_RX_ABORT | IRQ_PCNT_FULL)) {
    /* Packet dropped due to full receive FIFO or packet-counter saturation.
    Unlike the DP8390 we don't need to do anything to recover from this state
    except process some pending packets (below) */
    theGlobals->info.stdInfo.rxOverflowCount++;

    enc624j600_clear_irq(&theGlobals->chip,
                         irq_status & (IRQ_RX_ABORT | IRQ_PCNT_FULL));
    irq_handled = 1;
  }

  if (irq_status & (IRQ_TX | IRQ_TX_ABORT | IRQ_PKT)) {
    /* Transmit and receive handlers touch user memory. On Virtual Memory
    systems, this could cause a double fault if the ISR runs during a page fault
    and the user buffer is not paged in. DeferUserFn will delay calling the
    handler until a safe time. */
    if (theGlobals->usingVM) {
      DeferUserFn(userISR, theGlobals);
    } else {
      /* No VM, just call the handler directly. */
      userISR(theGlobals);
    }

    /* Note that in this case we return immediately without re-enabling IRQs;
    userISR may run AFTER we return if it gets deferred, so we leave re-enabling
    IRQs to it */
    return 1;
  }

  enc624j600_enable_irq(&theGlobals->chip, IRQ_ENABLE);

  return irq_handled;
}
