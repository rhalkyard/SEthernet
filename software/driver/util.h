#pragma once

#include <MacTypes.h>

#include "driver.h"

Boolean trapAvailable(const unsigned short trap);

#if defined(DEBUG)
void debug_log(driverGlobals* theGlobals, unsigned short eventType,
               unsigned short eventData);
#else
#define debug_log(theGlobals, eventType, eventData)
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
