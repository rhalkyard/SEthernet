#pragma once

#include <Devices.h>
#include <MacTypes.h>
#include <Slots.h>
#include <stddef.h>

#include "enc624j600.h"
#include "sethernet.h"

#if !(defined(TARGET_SE30) || defined(TARGET_SE))
#error Must define a target! (TARGET_SE or TARGET_SE30)
#endif

#if defined(TARGET_SE)
#define ENC624J600_BASE 0x800000
#endif

/* Number of protocol handlers to support */
#define numberOfPhs 16

/* Number of multicast addresses to support */
#define numberofMulticasts 8

/* ENC624J600 buffer configuration. Allocate 1536 bytes for a transmit buffer
(just enough for one frame), leaving the remainder (23040 bytes) as a receive
buffer. */
#define ENC_TX_BUF_START 0x0000
#define ENC_RX_BUF_START 0x0600

/* Protocol-handler protocol numbers are usually Ethernet II ethertypes except
for: */
enum {
  phProtocolPhaseII = 0, /* 802.2 Type 1 (ethertype < 0x600) */
  phProtocolFree = 1,    /* Invalid value used to signal a free
                            protocol-handler table entry */
};

/* Entry in our list of protocol handlers */
struct protocolHandlerEntry {
  unsigned short
      ethertype; /* Protocol number (ethertype except for those above) */
  void* handler; /* Pointer to protocol handler routine (see IM: Networking
                   chapter on ethernet protocol handlers)*/
#if 0
  void* readPB;  /* Parameter block for pending ERead operation. */
#endif
};
typedef struct protocolHandlerEntry protocolHandlerEntry;

/* Entry in our list of multicast addresses */
struct multicastEntry {
  Byte address[6];        /* Ethernet address */
  unsigned char refCount; /* Reference count */
};
typedef struct multicastEntry multicastEntry;

/* Global state used by the driver */
typedef struct driverGlobals {
  enc624j600 chip; /* Ethernet chip state */

  unsigned short phCount;
  protocolHandlerEntry
      protocolHandlers[numberOfPhs];             /* Protocol handler table */
  multicastEntry multicasts[numberofMulticasts]; /* Multicast address table */

  /* Receive Header Area that packet headers are read into before calling a
  Protocol Handler. 8 bytes following the packet header must be provided as
  workspace for the Protocol Handler */
  Byte recvHeaderArea[8 + 14 + 8];

  SlotIntQElement theSInt; /* Our slot interrupt queue entry */
  AuxDCEPtr driverDCE;     /* Our device control entry */

  Byte* nextPkt; /* pointer to next packet in receive FIFO */

  Boolean usingVM; /* are we running with Virtual Memory enabled? */
  driverInfo info; /* Device info packaged up suitably for EGetInfo */
} driverGlobals, *driverGlobalsPtr;
