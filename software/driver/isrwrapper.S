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
All it needs to do is preserve a few registers that C doesn't save (Slot Manager 
ISRs must preserve all registers except A1 and D0), and call our 'real' ISR */
    MOVEM.L     %a0/%d1-%d2, -(%sp)
    JSR         driverISR
    MOVEM.L     (%sp)+, %a0/%d1-%d2
    RTS

#elif defined(TARGET_SE)
/* SE: isrWrapper has to do a bit more. Because we don't have the Slot Manager
to handle interrupts for us, we 'hijack' the Level 1 interrupt vector to point
to isrWrapper, which has the job of checking if the interrupt was for us or not,
and calling either our driverISR routine, or jumping through the original 
interrupt vector that we saved. */

    /*
    Check to see if the interrupt came from our card
    
    This is kinda ugly. Bit 7 of the 16-bit ESTAT register indicates interrupt
    status (the datasheet says bit 15, but register bytes are swapped because
    the ENC624J600 is little endian). For memory operands, the BTST instruction
    only operates on bytes, not whole words, so we actually want to test bit 7
    of the byte at ESTAT+1. Trust me.
    */
    BTST        #7, SETHERNET_BASEADDR + ESTAT + 1
    JEQ         not_us

    /* We got an interrupt! Save registers and call our handler. In this case we
    must return with ALL registers preserved, so we need to save all of C's
    unsaved registers */
    MOVEM.L     %a0-%a1/%d0-%d2, -(%sp)
    MOVE.L      isrGlobals, %a1 /* driverISR takes pointer to globals in A1 */
    JSR         driverISR
    MOVEM.L     (%sp)+, %a0-%a1/%d0-%d2
    RTE         /* We're returning from an interrupt, so we use RTE, not RTS */

not_us:
    /* The ESTAT_INT bit was clear - this means that the interrupt came from
    something else, presumably the VIA or SCSI controller.
    
    Call the original interrupt handler through the vector that we saved. The 
    "push address and RTS" trick saves us having to use (and subsequently
    restore) a register. */
    MOVE.L      originalInterruptVector, -(%sp)
    RTS
#endif
    MacsbugSymbol isrWrapper
