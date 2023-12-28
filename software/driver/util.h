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
static inline Boolean ethAddrsEqual(const Byte *addr1, const Byte *addr2) {
  /* Compare first 4 bytes */
  if (*(unsigned long *) addr1 != *(unsigned long *) addr2) {
    return false;
  }

  /* Compare remaining 2 bytes */
  if (*(unsigned short *) (addr1 + 4) != *(unsigned short *) (addr2 + 4)) {
    return false;
  }

  return true;
}

/* Copy an ethernet address */
static inline void copyEthAddrs(Byte *dest, const Byte *source) {
  /* Copy first 4 bytes */
  *(unsigned long *) dest = *(unsigned long *) source;
  /* Copy remaining 2 bytes */
  *(unsigned short *) (dest + 4) = *(unsigned short *) (source + 4);
}
