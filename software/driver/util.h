#pragma once

#include <MacTypes.h>

unsigned long crc32(const Byte *data, const unsigned short len);
void waitTicks(const unsigned short ticks);
Boolean ethAddrsEqual(const Byte *addr1, const Byte *addr2);
void copyEthAddrs(Byte *dest, const Byte *source);
void my_memcpy(unsigned char * dest, unsigned char * source, unsigned short len);