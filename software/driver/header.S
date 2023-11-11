/* Header for 'enet' driver resource */

/* output a length-prefixed "pascal" style string */
.macro pstring str1, str2
        .byte pstring_end_\@ - . - 1
        .ascii "\str1"
        .ascii "\str2"
pstring_end_\@:
.endm

/* Retro68 doesn't have assembler includes :( Define our own constants here */

/* DRVR resource flags */
dNeedLockMask   = 0x4000        /* Lock code resource in memory */
dCtlEnableMask  = 0x0400        /* Driver responds to Control call */

/* Offsets to fields in IOParam struct */
ioTrap          = 6             /* System trap that issued this call */
ioResult        = 16            /* Result of call */
csCode          = 22            /* Call function code */

killCode        = 1             /* csCode for KillIO */
noQueueBit      = 9             /* Index for no-queue bit in ioTrap */

JIODone         = 0x08fc        /* Jump vector for IODone */

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
        pstring "SEthernet/30 Driver v0.0.1 ", __DATE__
#elif defined(TARGET_SE)
        pstring "SEthernet Driver v0.0.1 ", __DATE__
#endif

.text
/* 
Driver entry points have a 'special' calling convention - they are called with
their arguments (pointers to the parameter block and device control structure)
in A0 and A1 respectively, and must preserve these two registers on exit. The
Control entrypoint additionally needs special return handling to support async
IO.

These wrappers (adapted from IM: Devices listing 1-8) allow the actual
implementations to be written in C.

The C impls should be declared with:
#pragma parameter __D0 driverOpen(__A0, __A1)
#pragma parameter __D0 driverControl(__A0, __A1)
#pragma parameter __D0 driverClose(__A0, __A1)
*/
doOpen:
        MOVEM.L %A0-%A1,-(%SP)
        BSR     driverOpen
        MOVEM.L (%SP)+,%A0-%A1
        MOVE.L  %D0, ioResult(%A0)      /* Return code from Open must go into ioResult */
        RTS

doControl:
        MOVEM.L %A0-%A1,-(%SP)
        BSR     driverControl
        MOVEM.L (%SP)+,%A0-%A1
        CMPI.W  #killCode, csCode(%A0)
        BNE.B   IOReturn
        RTS                             /* Special case for KillIO - skip all the async IO handler stuff and just return */

IOReturn:
        MOVE.W  ioTrap(%A0), %D1
        BTST    #noQueueBit, %D1
        BEQ.B   Queued              /* Handle queued I/O */

        TST.W   %D0                 /* test asynchronous return result */
        BLE.B   ImmedRTS            /* result must be <= 0 */
        CLR.W   %D0                 /* "in progress" result (> 0) not passed back */
ImmedRTS:
        MOVE.W  %D0,ioResult(%A0)   /* for immediate calls you must explicitly place the result in the ioResult field */
        RTS

Queued:
        TST.W   %D0                 /* test asynchronous return result */
        BLE.B   MyIODone            /* I/O is complete if result <= 0 */
        CLR.W   %D0                 /* "in progress" result (> 0) not passed back */
        RTS
MyIODone:
        MOVE.L  JIODone,-(%SP)       /* push IODone jump vector onto stack */
        RTS                          /* 'return' through IODone */

doClose:
        MOVEM.L %A0-%A1,-(%SP)
        BSR     driverClose
        MOVEM.L (%SP)+,%A0-%A1        
        RTS

