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

#if defined(DEBUG)
#include <Debugging.h>
#include <stdarg.h>
#include <stdio.h>
#endif

#include "driver.h"

Boolean trapAvailable(const unsigned short trap);

#if defined(DEBUG)
/* Write an event to the debugging event log */
void debug_log(driverGlobals* theGlobals, unsigned short eventType,
               unsigned short eventData);

/* Break into MacsBug with a printf-formatted string */
void DebugPrintf(const char * format, ...);

#define DBGP(...) DebugPrintf(__VA_ARGS__)
#define DBGS(str) DebugStr(str)
#define DBG() Debugger()
#else
#define debug_log(theGlobals, eventType, eventData)
#define DBGP(...)
#define DBGS(str)
#define DBG()
#endif

/* Compare two ethernet addresses for equality */
static inline Boolean ethAddrsEqual(const hwAddr *addr1, const hwAddr *addr2) {
  /* Compare first 4 bytes */
  if (addr1->first4 != addr2->first4) {
    return false;
  }

  /* Compare remaining 2 bytes */
  if (addr1->last2 != addr2->last2) {
    return false;
  }

  return true;
}

/* Copy an ethernet address */
static inline void copyEthAddrs(hwAddr *dest, const hwAddr *source) {
  dest->first4 = source->first4;
  dest->last2 = source->last2;
}
