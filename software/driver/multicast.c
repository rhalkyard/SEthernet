#include "multicast.h"

#include "enc624j600.h"
#include "util.h"

#include <string.h>

/* Look up an address in our table of multicast addresses. Returns a pointer to
the multicast table entry if found, nil if no match */
multicastEntry* findMulticastEntry(const driverGlobalsPtr theGlobals,
                                   const Byte address[6]) {
  for (unsigned short i = 0; i < numberofMulticasts; i++) {
    if (theGlobals->multicasts[i].refCount > 0) {
      if (ethAddrsEqual(address, theGlobals->multicasts[i].address)) {
        return &theGlobals->multicasts[i];
      }
    }
  }
  return nil;
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
      hashValue = crc32(theGlobals->multicasts[i].address, 6);

      /* Use bits 28:23 of CRC32 as bitwise index into hash table */
      hashValue = (hashValue >> 23) & 0x3f;
      hashTable[hashValue >> 4] |= (1 << (hashValue & 0x0f));
    }
  }
  enc624j600_write_multicast_table(&theGlobals->chip, hashTable);
}

/*
EAddMulti call (a.k.a Control with csCode=ENetAddMulti)

Add an address to our multicast list
*/
OSStatus doEAddMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  multicastEntry* multicastSlot;
  unsigned char* addressPtr;

  addressPtr = (unsigned char*)&pb->u.EParms2.eMultiAddr;
  /* Check that it is a valid multicast address (bit 0 of first byte is 1) */
  if ((addressPtr[0] & 0x01) == 0) {
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
    copyEthAddrs(multicastSlot->address, addressPtr);
    
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
  unsigned char* addressPtr;

  addressPtr = (unsigned char*)&pb->u.EParms2.eMultiAddr;
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
