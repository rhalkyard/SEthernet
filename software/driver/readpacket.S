/*
ReadPacket and ReadRest are called by protocol handlers to copy data from
the receive FIFO into their own buffers. Their calling conventions and register
usage are particularly awkward, hence implementing them in asm.

ReadPacket reads a given number of bytes from the packet into a buffer provided
by the protocol handler. ReadRest does the same, but signals completion to the
driver and discards any remaining unread data. Protocol handlers can call
ReadPacket any number of times, but they MUST call ReadRest once (and only once)
when they are finished with a packet.

The address of ReadPacket must be in A4 when the protocol handler is called.
DO NOT CALL THIS FUNCTION DIRECTLY FROM THE DRIVER.

On entry:
  A0: Pointer to chip data structure (guaranteed preserved by protocol handler)
  A1: Unused, but guaranteed preserved by protocol handler.
  A3: buffer to write into
  D1: number of bytes remaining (*** IM:N only documents this for AppleTalk
      .MPP protocol handlers, but the MACE and SONIC drivers' ReadPacket
      routines use D1 in this way too ***)
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

  CCR Z flag indicates error state (set if no error, clear if error)
*/

.global ReadPacket
ReadPacket:
    /* ReadRest is called as ReadPacket+2, this branch must fit into 2 bytes! */
    BRA.B       RealReadPacket

ReadRest:
    .if . != ReadPacket+2   /* just to make sure */
    .err
    .endif
    MOVE.W      %d3, %d0                /* d0 = requested byte count */
    SUB.W       %d1, %d0                /* d0 = requested - available */
    TST.W       %d3                     /* check for zero-size read */
    BEQ         1f                      /* nothing to do */
    BSR         ReadBuf                 /* read the data */
1:
    MOVE.W      %d0, %d3                /* d3 = requested - available */
    MOVEQ       #0, %d0                 /* set Z flag, no failure no matter what */
    RTS

RealReadPacket:
    CMP.W       %d3, %d1                /* compare requested byte count (D3) against remaining bytes (D1) */
    BLO         1f                      /* bail out if requested > remaining */
    BSR         ReadBuf                 /* otherwise, read the data */
    TST.W       %d3                     /* check for leftover bytes */
    BEQ         2f
1:
#ifdef DEBUG
    .short      0xa9ff                  /* Debugger */
#endif
    MOVEQ       #-92, %d0               /* eLenErr */
2:
    RTS

ReadBuf:
    MOVE.W      %d3, %d0                /* d0 = byte count */
    CMP.W       %d1, %d3                /* Check for byte count > remaining bytes */
    BLS         1f
    MOVE        %d1, %d0                /* If so, only read what's available */
1:
    MOVEM.L     %a0-%a1/%d1-%d2, -(%sp) /* Preserve registers clobbered by C */
    MOVE.W      %d0, -(%sp)             /* D0.W - number of bytes to read */
    MOVE.L      %a3, -(%sp)             /* A3   - destination address */
    MOVE.L      %a0, -(%sp)             /* A0   - address of chip struct */
    BSR         enc624j600_read_rxbuf   /* D0.W = enc624j600_read_rxbuf(A0, A3, D0.W) */
    ADD.W       #10, %sp                /* Dispose of args */
    MOVEM.L     (%sp)+, %a0-%a1/%d1-%d2 /* Restore registers */

    ADD.W       %d0, %a3                /* Advance destination buffer pointer */
    SUB.W       %d0, %d1                /* Decrement remaining-byte count */
    SUB.W       %d0, %d3                /* Calculate remainder for this read */
    RTS
