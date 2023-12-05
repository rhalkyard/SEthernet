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
*/

.global ReadPacket
ReadPacket:
    /* ReadRest is called as ReadPacket+2, this branch must fit into 2 bytes! 
    gas is apparently not smart enough to use the narrowest possible branch
    displacement. Use BRA.B to expliclty emit a single-byte BRA (60 xx) so that
    we fit. */
    BRA.B       RealReadPacket

ReadRest:
    MOVE.W      %d3, %d0    /* d0 = d3 = maximum number of bytes to read */
    CMP.W       %d1, %d3
    BLS         1f
    MOVE.W      %d1, %d0    /* limit read length to remaining bytes */
1:
    SUB.W       %d0, %d3    /* generate return code */
    TST.W       %d0
    BEQ         ReadDone    /* exit if read length = 0 */
    BRA         ReadBuf     /* otherwise read some bytes */

RealReadPacket:
    MOVE.W      %d3, %d0    /* size check as above */
    CMP.W       %d1, %d3
    BLS         1f
    MOVE.W      %d1, %d0
1:
    SUB.W       %d0, %d3    /* generate return code */
    SUB.W       %d0, %d1    /* Update bytes-remaining count */
    TST.W       %d0
    BEQ         ReadDone    /* exit if read length = 0 */
    /* fall through to ReadBuf */
ReadBuf:
    MOVEM.L     %a0-%a1/%d1-%d2, -(%sp) /* Preserve registers clobbered by C */
    LINK        %a6, #0
    MOVEM.W     %d0, -(%sp) /* D0 - number of bytes to read */
    MOVEM.L     %a3, -(%sp) /* A3 - destination address */
    MOVEM.L     %a0, -(%sp) /* A0 - address of chip data structure */
    JSR         enc624j600_read_rxbuf /* D0 = enc624j600_read_rxbuf(A0, A3, D0) */
    EXT.L       %d0
    ADD.L       %d0, %a3 /* Advance destination buffer pointer */
    UNLK        %a6
    MOVEM.L     (%sp)+, %a0-%a1/%d1-%d2
    TST.W       %d3 /* Z flag must be set if OK, clear if error */
ReadDone:
    RTS

/* The ReadRest entrypoint is called as ReadPacket+2, if ReadRest starts
somewhere else, we have a problem. */
.if ReadRest != ReadPacket+2
.err
.endif
