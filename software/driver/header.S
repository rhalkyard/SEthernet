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

#include "version.h"
#include "macsbug.inc"

/* Header for 'enet' driver resource */

/* output a length-prefixed "pascal" style string */
.macro pstring str1, str2, str3, str4, str5, str6
        .byte pstring_end_\@ - . - 1
        .ascii "\str1"
        .ascii "\str2"
        .ascii "\str3"
        .ascii "\str4"
        .ascii "\str5"
        .ascii "\str6"
pstring_end_\@:
.endm

/* Retro68 doesn't have assembler includes :( Define our own constants here */

/* DRVR resource flags */
dNeedLockMask   = 0x4000        /* Lock code resource in memory */
dCtlEnableMask  = 0x0400        /* Driver responds to Control call */

/* Offsets to fields in IOParam struct */
ioTrap          = 6             /* System trap that issued this call */
ioResult        = 16            /* Result of call */
csCode          = 26            /* Call function code */

killCode        = 1             /* csCode for KillIO */
noQueueBit      = 9             /* Index for no-queue bit in ioTrap */

JIODone         = 0x08fc        /* Low-memory jump vector for IODone */

.global header_start

/* The .rsrcheader section is placd before .text and is normally left empty, so
anything put here shows up right at the start of the binary, which is exactly
what we want for a code-resource header */
.section .rsrcheader
header_start:
        .short dNeedLockMask + dCtlEnableMask /* drvrFlags - lock driver in 
                                                 memory, we respond to Control 
                                                 calls */
        .short 0 /* drvrDelay - ticks between poll intervals. 0 = Don't poll */
        .short 0 /* drvrEMask - event mask for DAs. Not used. */
        .short 0 /* drvrMenu - menu resource ID for DAs. Not used */

/* offsets to entrypoints */
        .short doOpen-header_start      /* Open */
        .short 0                        /* Prime (not used) */
        .short doControl-header_start   /* Control */
        .short 0                        /* Status (not used) */
        .short doClose-header_start     /* Close */

#if defined(TARGET_SE30)
        pstring ".ENET"
#elif defined(TARGET_SE)
        pstring ".ENET0"
#endif
        .align 2

/* version number in 'vers' resource format */
        .byte VERSION_MAJOR             /* major version */
        .byte VERSION_MINOR             /* minor version in BCD format */
        .byte VERSION_DEVSTAGE          /* release stage */
        .byte VERSION_INTERNAL_ID       /* release number for non-final build */
        .word 0x0000                    /* region */
        pstring VERSION_SHORT           /* short version */
        /* Long version string */
#if defined(TARGET_SE30)
        pstring "SEthernet/30 Driver ", VERSION_SHORT, " git:", GIT_REV
#elif defined(TARGET_SE)
        pstring "SEthernet Driver ", VERSION_SHORT, " git:", GIT_REV
#endif
        .align 2

/* 
Driver entry points have a 'special' calling convention - they are called with
their arguments (pointers to the parameter block and device control structure)
in A0 and A1 respectively, and must preserve these two registers on exit. 

Additionally, the Control entrypoint needs special return handling to support
the Mac OS's async IO model (the Prime and Status entrypoints would also need
this if we supported them). Control, Prime and Status handlers should return >0
if an async operation has been started.

These wrappers (adapted from IM: Devices listing 1-8) allow the actual
implementations to be written in C.

The C impls should be declared with:
#pragma parameter __D0 driverOpen(__A0, __A1)
OSErr driverOpen(EParamBlkPtr pb, DCtlPtr dce)
#pragma parameter __D0 driverControl(__A0, __A1)
OSErr driverControl(EParamBlkPtr pb, DCtlPtr dce)
#pragma parameter __D0 driverClose(__A0, __A1)
OSErr driverClose(EParamBlkPtr pb, DCtlPtr dce)

Note that BSR must be used here rather than JSR because our code may not have
been relocated yet!
*/
doOpen:
        MOVEM.L %A0-%A1,-(%SP)          /* Save registers */
        BSR     driverOpen
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */
        RTS
        MacsbugSymbol doOpen

doControl:
        MOVEM.L %A0-%A1,-(%SP)          /* Save registers */
        BSR     driverControl
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */
        /* Any Control call except KillIO may return asynchronously. */
        CMP.W   #killCode, csCode(%A0)
        JNE     IOReturn                /* Not KillIO - handle async return */
        RTS                             /* KillIO - just return */
        MacsbugSymbol doControl

IOReturn:
        MOVE.W  ioTrap(%A0), %D1
        BTST    #noQueueBit, %D1    /* Was IO operation queued or immediate? */
        JEQ     Queued

        /* Immediate calls return directly through RTS */
        TST.W   %D0                 /* test asynchronous return result */
        JLE     ImmedRTS            /* result must be <= 0 */
        CLR.W   %D0                 /* in-progress result (> 0) returned as 0 */
ImmedRTS:
        MOVE.W  %D0,ioResult(%A0)   /* for immediate calls you must explicitly 
                                       place the result in the ioResult field */
        RTS
        MacsbugSymbol IOReturn

Queued:
        /* Queued calls must call IODone on completion */
        TST.W   %D0                 /* test asynchronous return result */
        JLE     MyIODone            /* I/O is complete if result <= 0 */
        CLR.W   %D0                 /* in-progress result (> 0) returned as 0 */
        RTS
        MacsbugSymbol QueuedIOReturn

MyIODone:
        /* For tail calls through a vector, it's faster to push the address onto
        the stack and 'return' to it than to do an indirect jump */
        MOVE.L  JIODone,-(%SP)
        RTS
        MacsbugSymbol MyIODone

doClose:
        MOVEM.L %A0-%A1,-(%SP)          /* Save registers */
        BSR     driverClose
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */     
        RTS
        MacsbugSymbol doClose
