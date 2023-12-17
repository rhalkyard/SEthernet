#include "macsbug.inc"

#if defined(TARGET_SE)
#include "sethernet_board_defs.h"
#include "enc624j600_registers.h"
#endif

/*
Assembly-language wrappers for calling ISRs.
*/

.global isrWrapper

isrWrapper:
#if defined(TARGET_SE30)
/* SE/30: isrWrapper is called by the Slot Manager to service card interrupts.
All it needs to do is preserve registers that C normally doesn't, and call our
'real' ISR */
    MOVEM.L     %a0/%d1-%d2, -(%sp)
    JSR         driverISR
    MOVEM.L     (%sp)+, %a0/%d1-%d2
    RTS
#elif defined(TARGET_SE)
/* SE: isrWrapper has to do a bit more. Because we don't have the Slot Manager
to handle interrupts for us, we 'hijack' the Level 1 interrupt vector to point
to isrWrapper, which has the job of checking if the interrupt was for us or not,
and calling either our driverISR routine, or jumping to the original 
interrupt vector that we saved. */
    /*
    Check to see if the interrupt came from our card
    
    This is kinda ugly. Bit 7 of ESTAT indicates interrupt status (the datasheet
    says bit 15, but register bytes are swapped because ENC624J600 is little
    endian), but for memory operands, BTST operates on bytes, not whole words,
    so we actually want to test bit 7 of the byte at ESTAT+1. Trust me.
    */
    BTST        #7, SETHERNET_BASEADDR + ESTAT + 1
    BEQ         not_us

    /* We got an interrupt! Save registers and call our handler */
    MOVEM.L     %a0-%a1/%d0-%d2, -(%sp)
    LEA         isrGlobals, %a1
    JSR         driverISR
    MOVEM.L     (%sp)+, %a0-%a1/%d0-%d2
    RTE         /* We're returning from an interrupt, so we use RTE, not RTS */

not_us:
    /* ESTAT_INT bit was not clear, interrupt was not for us, call the original
    interrupt handler through the vector that we saved. The "push address and
    RTS" trick saves us having to use a register and is apparently faster than
    an indirect jump. The system interrupt handler will be none the wiser, and
    return with an RTE */
    MOVE.L      originalInterruptVector, -(%sp)
    RTS
#endif
    MacsbugSymbol isrWrapper
