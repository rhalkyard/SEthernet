#include <enc624j600.h>

/* ReadPacket callback function that we pass to protocol handlers, defined in
readpacket.S. We don't (and shouldn't) call it directly. */
extern void readPacket();

/* C wrapper to read data from receive buffer */
static inline void readBuf(struct enc624j600 * chip, void * dest,
                              unsigned short len) {
  asm volatile(
    "   MOVE.L  %[chip], %%a1   \n"
    "   MOVE.L  %[dest], %%a3   \n"
    "   MOVE.W  %[len], %%d3    \n"
    "   MOVE.W  %%d3, %%d1      \n"
    "   JSR     _readBuf"
    :
    : [chip] "g" (chip),
      [dest] "g" (dest),
      [len] "g" (len)
    : "d0", "d1", "d2", "a0", "a1", /* Registers that we normally expect to be 
                                       trashed across calls */
      "d3", "a3"                    /* Extra registers that we change */
  );
}
