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

#include "macsbug.inc"

.global readPacket
.global _readBuf

/* Offsets of fields within enc624j600 struct */
enc624j600_base_address = 0     /* Base address of chip (also start of transmit
                                buffer) */
enc624j600_rxbuf_start  = 4     /* Pointer to start of receive buffer */
enc624j600_rxbuf_end    = 8     /* Pointer to end of receive buffer */
enc624j600_rxptr        = 12    /* Receive buffer read pointer */
enc624j600_link_state   = 16    /* Current link state (updated by calls to 
                                enc624j600_duplex_sync) */
/*
BlockMove A-traps

Arguments:
    A0      Source
    A1      Destination
    D0.L    Count

Changes A0-A1, D0-D2. Returns with D0=0

BlockMove flushes processor caches. In later versions of the Memory Manager
(which?), BlockMoveData does not flush caches, in early versions it is a synonym
for BlockMove.
*/
.macro _BlockMove
    .word 0xa02e
.endm

.macro _BlockMoveData
    .word 0xa22e
.endm

/*
readPacket and readRest are called by protocol handlers to copy data from
the receive FIFO into their own buffers. Their calling conventions and register
usage are particularly awkward, hence implementing them in asm.

readPacket reads a given number of bytes from the packet into a buffer provided
by the protocol handler. readRest does the same, but signals completion to the
driver and discards any remaining unread data. Protocol handlers can call
readPacket any number of times, but they MUST call readRest once (and only once)
when they are finished with a packet.

The address of readPacket must be in A4 when the protocol handler is called.
DO NOT CALL THIS FUNCTION DIRECTLY FROM THE DRIVER.

On entry:
  A0: ours (unused)
  A1: ours (pointer to chip data structure)
  A3: buffer to write into
  D1: number of bytes remaining
  D3: maximum number of bytes to read

On exit:
  A0: changed
  A1: preserved
  A2: preserved
  A3: buffer pointer (updated to point to byte following last byte written)
  A4-A5: preserved
  D0: changed (OSErr value)
  D1: number of bytes remaining (updated to reflect bytes read)
  D2: preserved
  D3: 0 if requested number of bytes read
      <0 if packet was (-D3) bytes too large to fit in buffer (readRest only)
      >0 if D3 bytes weren't read
  D4-D7: preserved

  CCR Z flag indicates error state (set if no error, clear if error)
*/

readPacket:
    /* readRest is called as readPacket+2, this branch must fit into 2 bytes! */
    BRA.B       realReadPacket

readRest:
    .if . != readPacket+2   /* just to make sure */
    .err
    .endif
    TST.W       %d3                     /* check for zero-size read */
    JEQ         readRest_done           /* nothing to do */
    JBSR        _readBuf                /* read the data */
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
readRest_done:
    SUB.W       %d1, %d3                /* D3 = D3 - D1 (see comment above) */
    MOVEQ       #0, %d0                 /* set Z flag, no failure no matter what */
    RTS

realReadPacket:
    JBSR        _readBuf                /* otherwise, read the data */
    JNE         readPacket_err          /* Z flag set if OK, clear if error */
    RTS

readPacket_err:
#ifdef DEBUG
    _Debugger
#endif
    MOVEQ       #-92, %d0               /* eLenErr */
    RTS
    MacsbugSymbol "readPacket"

/*
Copy data out of the ENC624J600's receive ring buffer

On entry:
    A1:     Address of chip data structure (struct enc624j600)
    A3:     Destination pointer
    D1:     Remaining bytes in packet
    D3:     Number of bytes to read

On exit:
    A0:     Changed
    A1:     Preserved
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
_readBuf:
    MOVE.W      %d3, %d0                /* D0 = number of bytes to read */
    CMP.W       %d1, %d0
    JLS         1f                      /* D0 = MIN(D1, D0) */
    MOVE.W      %d1, %d0
1:
#ifdef DEBUG
    MOVEM.L     %a1/%d0-%d2, -(%sp)     /* Preserve registers changed by C */
    MOVE.W      %d0, -(%sp)
    MOVE.W      #0x8020, -(%sp)
    MOVE.L      %a1, -(%sp)
    JSR         debug_log               /* debug_log(A1, #0x8020, D0.W) */
    ADDQ        #8, %sp                 /* Remove args from stack */
    MOVEM.L     (%sp)+, %a1/%d0-%d2     /* Restore registers */
#endif

    MOVEM.L     %a1/%d0-%d2, -(%sp)     /* BlockMove changes A0-A1, D0-D2 */

    /* Clear the top half of D0 since BlockMove takes its byte count as a
    longword quantity, and we've been calculating it as a word so far. The
    SWAP/CLR.W trick is apparently faster than AND.L #ffff */
    SWAP        %d0
    CLR.W       %d0
    SWAP        %d0

    MOVE.L      enc624j600_rxptr(%a1), %a0  /* A0 = read ptr */
    MOVE.L      %a0, %d2
    ADD.W       %d0, %d2                    /* D2 = read ptr + bytes to copy */
    CMP.L       enc624j600_rxbuf_end(%a1), %d2 /* Check against buffer bounds */
    JGT         readBuf_wrap                /* Handle wraparound case */

readBuf_main:
    MOVE.L      %d2, enc624j600_rxptr(%a1)  /* Save updated read pointer */
    MOVE.L      %a3, %a1                    /* A1 = write pointer */
    ADD.W       %d0, %a3                    /* Advance write pointer */
    _BlockMoveData
    MOVEM.L     (%sp)+, %a1/%d0-%d2 

    SUB.W       %d0, %d1                    /* Update remaining-byte count */
    /* This operation must come last so that a successful read sets the Z flag */
    SUB.W       %d0, %d3                    /* Calculate remaining bytes in pkt */
    RTS

readBuf_wrap:
    /* Read to end of buffer, then jump to readBuf_main to read remaining data
    from the start of the buffer */
    MOVE.L      enc624j600_rxbuf_end(%a1), %d1
    SUB.L       %a0, %d1                    /* D1 = bytes to end of buffer */
    SUB.W       %d1, %d0                    /* D0 = size of 2nd chunk */
    MOVEM.L     %a1/%d0, -(%sp)             /* Save struct ptr and 2nd chunk size */

    MOVE.W      %d1, %d0                    /* D0 = bytes to end of buffer */
    MOVE.L      %a3, %a1                    /* A1 = write pointer */
    ADD.W       %d0, %a3                    /* Advance write pointer */
    _BlockMoveData

    MOVEM.L     (%sp)+, %a1/%d0             /* Restore struct ptr and 2nd chunk size */
    MOVE.L      enc624j600_rxbuf_start(%a1), %a0
    MOVE.L      %a0, %d2
    ADD.W       %d0, %d2                    /* D2 = buffer start + 2nd chunk size */
    JRA         readBuf_main                /* Finish up second chunk */

    RTS                                     /* Dummy RTS for Macsbug symbol */
    MacsbugSymbol "_readBuf"

