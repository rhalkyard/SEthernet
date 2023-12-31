#pragma once

#include <MacTypes.h>

#include "driver.h"

#if defined(TARGET_SE)
/* The original level-1 interrupt vector. If the interrupt fires but we don't
have a pending interrupt flag, we pass the interrupt through to it*/
extern void (*originalInterruptVector)();

/* Pointer to driver globals so our ISR can reference them */
extern driverGlobalsPtr isrGlobals;
#endif

/* Assembly-language wrapper for our ISRs written in C; implementation in 
isrwrapper.S */
void isrWrapper(void);
