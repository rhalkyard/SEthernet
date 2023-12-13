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
        .short dNeedLockMask + dCtlEnableMask /* drvrFlags - lock driver in memory, we respond to Control calls */
        .short 0 /* drvrDelay - ticks between poll intervals. We don't poll. */
        .short 0 /* drvrEMask - event mask for DAs */
        .short 0 /* drvrMenu - menu resource ID for DAs */

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

/* version number as long and as string */
        .long 0x00000001
#if defined(TARGET_SE30)
        pstring "SEthernet/30 Driver v0.0.1 git:", GIT_REV
#elif defined(TARGET_SE)
        pstring "SEthernet Driver v0.0.1 git:", GIT_REV
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
OSErr driverOpen(EParamBlkPtr pb, DCtlPtr dce)
OSErr driverControl(EParamBlkPtr pb, DCtlPtr dce)
OSErr driverClose(EParamBlkPtr pb, DCtlPtr dce)

Note that BSR must be used here rather than JSR because our code may not have
been relocated yet!
*/
doOpen:
        MOVEM.L %A0-%A1,-(%SP)          /* Save registers */
        MOVEM.L %A0-%A1,-(%SP)          /* Push args onto stack for C */
        BSR     driverOpen
        ADDQ    #8, %SP                 /* Dispose of args */
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */
        RTS
        MacsbugSymbol doOpen

doControl:
        MOVEM.L %A0-%A1,-(%SP)          /* Save registers */
        MOVEM.L %A0-%A1,-(%SP)          /* Push args onto stack for C */
        BSR     driverControl
        ADDQ    #8, %SP                 /* Dispose of args */
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */
        /* Any Control call except KillIO may return asynchronously. */
        CMP.W   #killCode, csCode(%A0)
        BNE     IOReturn                /* Not KillIO - handle async return */
        RTS                             /* KillIO - just return */
        MacsbugSymbol doControl

IOReturn:
        MOVE.W  ioTrap(%A0), %D1
        BTST    #noQueueBit, %D1        /* Was IO operation queued or immediate? */
        BEQ     Queued

        /* Immediate calls return directly through RTS */
        TST.W   %D0                 /* test asynchronous return result */
        BLE     ImmedRTS            /* result must be <= 0 */
        CLR.W   %D0                 /* "in progress" result (> 0) not passed back */
ImmedRTS:
        MOVE.W  %D0,ioResult(%A0)   /* for immediate calls you must explicitly place the result in the ioResult field */
        RTS
        MacsbugSymbol IOReturn

Queued:
        /* Queued calls must call IODone on completion */
        TST.W   %D0                 /* test asynchronous return result */
        BLE     MyIODone            /* I/O is complete if result <= 0 */
        CLR.W   %D0                 /* "in progress" result (> 0) not passed back */
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
        MOVEM.L %A0-%A1,-(%SP)          /* Push args onto stack for C */
        BSR     driverClose
        ADDQ    #8, %SP                 /* Dispose of args */
        MOVEM.L (%SP)+,%A0-%A1          /* Restore registers */     
        RTS
        MacsbugSymbol doClose
