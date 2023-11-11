#pragma once

#include <MacTypes.h>

unsigned long crc32(const Byte *data, const unsigned short len);
void busyWait(const unsigned long time_us);
Boolean ethAddrsEqual(const Byte *addr1, const Byte *addr2);
void copyEthAddrs(const Byte *source, Byte *dest);
