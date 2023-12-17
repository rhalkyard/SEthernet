#include "util.h"

#include <MacTypes.h>
#include <OSUtils.h>
#include <Timer.h>
#include <Traps.h>

#if defined(DEBUG)
char strbuf[255];
#endif

#define CRC_POLYNOMIAL (0x04c11db7)

/* Naive CRC32 implementation, used in calculating the multicast-filter hash
table. Doesn't need to be fast or fancy since it's only called when we add or
remove a multicast address */
unsigned long crc32(const Byte *data, const unsigned short len) {
  unsigned short i, j;
  unsigned long byte, crc;

  crc = 0xffffffff;
  for (i = 0; i < len; i++) {
    byte = data[i];
    for (j = 0; j < 8; j++) {
      if ((byte & 1) ^ (crc >> 31)) {
        crc <<= 1;
        crc ^= CRC_POLYNOMIAL;
      } else
        crc <<= 1;
      byte >>= 1;
    }
  }
  return crc;
}

/* Busy-wait for one Tick (1/60s) */
void waitTicks(const unsigned short ticks) {
  unsigned int start, now;
  start = TickCount();
  do {
    now = TickCount();
  } while (now - start < ticks);
}

/* Compare two ethernet addresses for equality */
Boolean ethAddrsEqual(const Byte *addr1, const Byte *addr2) {
  /* could do this as a long and a word but lets keep things simple for now */
  for (unsigned short i = 0; i < 6; i++) {
    if (addr1[i] != addr2[i]) {
      return false;
    }
  }
  return true;
}

/* Copy an ethernet address */
void copyEthAddrs(Byte *dest, const Byte *source) {
  /* could do this as a long and a word but lets keep things simple for now */
  for (unsigned short i = 0; i < 6; i++) {
    dest[i] = source[i];
  }
}

/* Check whether a given trap is available. Adapted from IM: Devices listing
   8-1 */
Boolean trapAvailable(const unsigned short trap) {
  TrapType type;
  /* First determine whether it is an OS or Toolbox routine */
  if (trap & 0x800) {
    type = OSTrap;
  } else {
    type = ToolTrap;
  }

  /* filter cases where older systems mask with 0x1ff rather than 0x3ff */
  if (type == ToolTrap && (trap & 0x3ff) >= 0x200 &&
      GetToolboxTrapAddress(0xa86e) == GetToolboxTrapAddress(0xaa6e)) {
    return false;
  } else {
    return NGetTrapAddress(trap, type) != GetToolboxTrapAddress(_Unimplemented);
  }
}
