#include "macsbug.inc"

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
  A0: ours (pointer to chip data structure)
  A1: ours (unused)
  A3: buffer to write into
  D1: number of bytes remaining
  D3: maximum number of bytes to read

On exit:
  A0: preserved
  A1: changed
  A2: preserved
  A3: buffer pointer (updated to point to byte following last byte written)
  A4-A5: preserved
  D0: changed (OSErr value)
  D1: number of bytes remaining (updated to reflect bytes read)
  D2: preserved
  D3: 0 if requested number of bytes read
      <0 if packet was (-D3) bytes too large to fit in buffer (ReadRest only)
      >0 if D3 bytes weren't read
  D4-D7: preserved

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
    TST.W       %d3                     /* check for zero-size read */
    JEQ         1f                      /* nothing to do */
    JSR         ReadBuf                 /* read the data */
/* 
ReadBuf returns with:
    D1 = number of bytes remaining in packet
    D3 = difference between requested bytes and actual bytes read 
            D3 = requested - MIN(available, requested)
Possible outcomes:
    - We asked for more data than was left in the packet
        D1 = 0 (no data remaining in packet)
        D3 > 0 (number of bytes that we asked for but didn't get)
        => D3 = D3 - 0 = D3
    - We got exactly as much data as was available
        D1 = 0 (no data remaining)
        D3 = 0 (we got as many bytes as we asked for)
        => D3 = 0 - 0 = 0
    - There was more data left in the packet than we asked for
        D1 > 0 (bytes remaining in packet)
        D3 = 0 (we got as many bytes as we asked for)
        => D3 = 0 - D1 = -D1
*/
1:
    SUB.W       %d1, %d3                /* D3 = D3 - D1 (see comment above) */
    MOVEQ       #0, %d0                 /* set Z flag, no failure no matter what */
    RTS
    MacsbugSymbol "ReadRest"

RealReadPacket:
    JSR         ReadBuf                 /* otherwise, read the data */
    JNE         1f                      /* ReadBuf returns with Z flag set if OK, clear if error */
    RTS
    MacsbugSymbol "ReadPacket"

1:
#ifdef DEBUG
    .short      0xa9ff                  /* Debugger */
#endif
    MOVEQ       #-92, %d0               /* eLenErr */
    RTS

/*
Read routine for ReadPacket/ReadRest. Calls enc624j600_read_rxbuf() to do the
heavy lifting.

On entry:
    A0:     Address of chip data structure
    A3:     Destination pointer
    D1:     Remaining bytes in packet
    D3:     Number of bytes to read

On exit:
    A0:     Preserved
    A1:     Changed
    A2:     Preserved
    A3:     Pointer to one byte past last byte written
    A4-A5:  Preserved
    D0:     Number of bytes actually read
    D1:     Remaining bytes in packet (updated)
    D2:     Preserved
    D3:     Difference between requested bytes and actual bytes read 
            (requested - MIN(available, requested))

    CCR Z flag reflects value of D3 (set = no delta, clear = fewer bytes were
    read than requested)
*/
ReadBuf:
    MOVE.W      %d3, %d0                /* d0 = number of bytes to read */
    CMP.W       %d1, %d0                /* d0 = MIN(d1, d0) */
    JLS         1f                      /*  ... nothing to do if d0 <= d1 */
    MOVE.W      %d1, %d0                /*  ... otherwise, d0 = d1 */
1:
#ifdef DEBUG
    MOVEM.L     %a0/%d0-%d2, -(%sp)     /* Preserve registers changed by C */
    MOVE.W      %d0, -(%sp)
    MOVE.W      #0x8020, -(%sp)
    MOVE.L      %a0, -(%sp)
    JSR         debug_log               /* debug_log(A0, #0x8020, D0.W) */
    ADDQ        #8, %sp                 /* Remove args from stack */
    MOVEM.L     (%sp)+, %a0/%d0-%d2     /* Restore registers */
#endif

    /* Note that we don't preserve A1 here - it's reserved for our use, but we 
    don't use it for anything, so no need to waste cycles saving and restoring
    it. */
    MOVEM.L     %a0/%d0-%d2, -(%sp)     /* Preserve registers changed by C. */
    JSR         enc624j600_read_rxbuf   /* enc624j600_read_rxbuf(A0, A3, D0.W) */
    MOVEM.L     (%sp)+, %a0/%d0-%d2     /* Restore registers */

    ADD.W       %d0, %a3                /* Advance destination buffer pointer */
    SUB.W       %d0, %d1                /* Update remaining-byte count */

    /* This operation must come last so that a successful read sets the zero flag */
    SUB.W       %d0, %d3                /* Calculate remainder for this read */
    RTS
    MacsbugSymbol "ReadBuf"
