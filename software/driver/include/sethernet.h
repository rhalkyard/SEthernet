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

#include <MacTypes.h>
#pragma once

/* Non-standard Control csCodes used by our driver */
enum {
  ENCReadReg = 0x7000,  /* Read register, csParam is encRegister* */
  ENCWriteReg = 0x7001, /* Write register, csParam is encRegister* */
  ENCReadPhy = 0x7002,  /* Read PHY register, csParam is encRegister* */
  ENCWritePhy = 0x7003, /* Write PHY register, csParam is encRegister* */

  ENCEnableLoopback = 0x7004, /* Set PHY to loopback mode, csParam unused */
  ENCDisableLoopback = 0x7005 /* Take PHY out of loopback, csParam unused */
};

/* Register address-value pair used for register-access Control calls */
struct encRegister {
  unsigned short reg;
  unsigned short value;
};
typedef struct encRegister encRegister;

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
