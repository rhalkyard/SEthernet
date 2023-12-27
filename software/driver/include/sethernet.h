#include <MacTypes.h>
#pragma once

enum {
  ENCReadReg = 0x7000,
  ENCWriteReg = 0x7001,
  ENCReadPhy = 0x7002,
  ENCWritePhy = 0x7003,
  ENCEnableLoopback = 0x7004,
  ENCDisableLoopback = 0x7005
};

struct ENCRegister {
  unsigned short reg;
  unsigned short value;
};
typedef struct ENCRegister ENCRegister;

/*
Information returned by EGetInfo

'Standard' EGetInfo responses are defined for EtherTalk NB and SONIC cards. We
use the more detailed SONIC format, plus some of our own fields tacked on to the
end.
*/
struct driverInfo {
  Byte ethernetAddress[6]; /* Our ethernet address */

  Byte unused[12];

  /* Fields supported by SONIC-type cards */
  unsigned long txFrameCount; /* Frames transmitted without error */
  unsigned long
      singleCollisionFrames; /* Frames transmitted with 1 collision retry */
  unsigned long multiCollisionFrames; /* Frames transmitted with multiple
                                         collision retries */
  unsigned long collisionFrames; /* Total frames transmitted with collisions */
  unsigned long deferredFrames;  /* Total frames transmitted with deferrals */
  unsigned long lateCollisions;  /* Transmit failures due to late collision */
  unsigned long
      excessiveCollisions; /* Transmit failures due to excessive collisions */
  unsigned long
      excessiveDeferrals; /* Transmit failures due to excessive deferrals */
  unsigned long internalTxErrors; /* Transmit failures due to internal errors
                                     (anything other than the above) */
  unsigned long rxFrameCount;     /* Frames received without error */
  unsigned long multicastRxFrameCount; /* Multicast frames received */
  unsigned long broadcastRxFrameCount; /* Broadcast frames received */
  unsigned long fcsErrors;        /* Receive failure due to checksum errors (not
                                     reported by default on ENC624J600) */
  unsigned long alignmentErrors;  /* Receive failures due to alignment errors
                                     (not reported by ENC624J600) */
  unsigned long internalRxErrors; /* Receive failures due to internal errors
                                     (buffer overflow or receive canceled) */

  /* Fields specific to SEthernet */
  unsigned long
      rxPendingBytesHWM; /* Maximum number of bytes pending in receive FIFO */
  unsigned long rxPendingPacketsHWM; /* Maximum number of packets pending in
                                        receive FIFO */
  unsigned long rxBadLength; /* 802.2 Type 1 frames with bad length field */
  unsigned long rxRunt; /* Runt frames (<64 bytes) received */
  unsigned long rxTooLong; /* Too-long frames (>1518 bytes) received */
  unsigned long
      rxUnwanted; /* Frames received with an 'unwanted' destination address
                     (likely hash collisions in the multicast table) */
  unsigned long rxUnknownProto; /* Packets received with an unknown protocol */
} __attribute__((packed));
typedef struct driverInfo driverInfo;
