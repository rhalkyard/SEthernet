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
