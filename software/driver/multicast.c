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

#include "multicast.h"

#include "enc624j600.h"
#include "util.h"

#include <string.h>

/* Naive CRC32 implementation, used in calculating the multicast-filter hash
table. Doesn't need to be fast or fancy since it's only called when we add or
remove a multicast address */
static unsigned long crc32(const Byte *data, const unsigned short len) {
  const unsigned long polynomial = 0x04c11db7;
  unsigned short i, j;
  unsigned long byte, crc;

  crc = 0xffffffff;
  for (i = 0; i < len; i++) {
    byte = data[i];
    for (j = 0; j < 8; j++) {
      if ((byte & 1) ^ (crc >> 31)) {
        crc <<= 1;
        crc ^= polynomial;
      } else
        crc <<= 1;
      byte >>= 1;
    }
  }
  return crc;
}

/* Find a free entry in the multicast table. Returns a pointer to the first free
entry found, nil if no free entries */
static multicastEntry* findFreeMulticastEntry(
    const driverGlobalsPtr theGlobals) {
  for (unsigned short i = 0; i < numberofMulticasts; i++) {
    if (theGlobals->multicasts[i].refCount == 0) {
      return &theGlobals->multicasts[i];
    }
  }
  return nil;
}

/* Generate the 8-byte multicast hash table used by the ENC624J600 and load it
into the chip. See the data sheet for hash table format. */
static void updateMulticastHashTable(const driverGlobalsPtr theGlobals) {
  unsigned short hashTable[4];
  unsigned long hashValue;

  /* Zero out hash table */
  memset(hashTable, 0, 4 * sizeof(unsigned short));

  for (unsigned short i = 0; i < numberofMulticasts; i++) {
    if (theGlobals->multicasts[i].refCount > 0) {
      hashValue = crc32(theGlobals->multicasts[i].address.bytes, 6);

      /* Use bits 28:23 of CRC32 as bitwise index into hash table */
      hashValue = (hashValue >> 23) & 0x3f;
      hashTable[hashValue >> 4] |= (1 << (hashValue & 0x0f));
    }
  }
  enc624j600_write_multicast_table(&theGlobals->chip, hashTable);
}

/* Look up an address in our table of multicast addresses. Returns a pointer to
the multicast table entry if found, nil if no match */
multicastEntry* findMulticastEntry(const driverGlobalsPtr theGlobals,
                                   const hwAddr *address) {
  for (unsigned short i = 0; i < numberofMulticasts; i++) {
    if (theGlobals->multicasts[i].refCount > 0) {
      if (ethAddrsEqual(address, &theGlobals->multicasts[i].address)) {
        return &theGlobals->multicasts[i];
      }
    }
  }
  return nil;
}

/*
EAddMulti call (a.k.a Control with csCode=ENetAddMulti)

Add an address to our multicast list
*/
OSStatus doEAddMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  multicastEntry* multicastSlot;
  hwAddr* addressPtr;

  addressPtr = (hwAddr*)&pb->u.EParms2.eMultiAddr;
  /* Check that it is a valid multicast address (bit 0 of first byte is 1) */
  if ((addressPtr->bytes[0] & 0x01) == 0) {
    return eMultiErr;
  }
  /* See if the address is already in our multicast list */
  multicastSlot = findMulticastEntry(theGlobals, addressPtr);
  if (multicastSlot != nil) {
    /* Yes, increment the refcount of the existing entry */
    multicastSlot->refCount++;
    return noErr;
  } else {
    /* No, try to add it to the list */
    multicastSlot = findFreeMulticastEntry(theGlobals);
    if (multicastSlot == nil) {
      return eMultiErr;
    }
    /* Mark entry as in use */
    multicastSlot->refCount = 1;
    copyEthAddrs(&multicastSlot->address, addressPtr);
    
    /* Update the hash table to include new entry */
    updateMulticastHashTable(theGlobals);
    return noErr;
  }
}

/*
EDelMulti call (a.k.a. Control with csCode=ENetDelMulti)

Remove an address from our multicast list
*/
OSStatus doEDelMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  multicastEntry* multicastSlot;
  hwAddr* addressPtr;

  addressPtr = (hwAddr*)&pb->u.EParms2.eMultiAddr;
  /* Find the entry in the list */
  multicastSlot = findMulticastEntry(theGlobals, addressPtr);
  if (multicastSlot == nil) {
    return eMultiErr;
  }
  /* Decrement reference count */
  multicastSlot->refCount--;

  /* If no longer in use, update the hash table */
  if (multicastSlot->refCount <= 0) {
    updateMulticastHashTable(theGlobals);
  }
  return (noErr);
}
