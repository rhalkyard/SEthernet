/*
Simple tool to test card memory and calculate approximate memory bandwidth

Separate tests for byte, word, and long-sized accesses in order to check for
back-to-back access timing issues.
*/

#include <Gestalt.h>
#include <MacTypes.h>
#include <Memory.h>
#include <ROMDefs.h>
#include <Slots.h>
#include <Timer.h>
#include <ctype.h>
#include <stdio.h>

#include "sethernet_board_defs.h"
#include "sethernet30_board_defs.h"

#define TICK_SECONDS (1 / 60.0)

static int memtest_byte(volatile char *addr, unsigned int len,
                        unsigned int repeat) {
  volatile char *ptr;
  char pattern = 0x55;

  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr++) {
      *ptr = pattern;
    }
    for (ptr = addr; ptr < addr + len; ptr++) {
      if (*ptr != pattern) {
        printf("Miscompare at 0x%08x: wrote %02x, read %02x\n",
               (unsigned int)ptr, pattern, *ptr);
        return 1;
      }
    }
    pattern = ~pattern;
  }
  return 0;
}

static int memspeed_bytewrite(volatile char *addr, unsigned int len,
                              unsigned int repeat) {
  volatile char *ptr;
  char pattern = 0x55;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr++) {
      *ptr = pattern;
    }
    pattern = ~pattern;
  }
  end = TickCount();
  return end - start;
}

static int memspeed_byteread(volatile char *addr, unsigned int len,
                             unsigned int repeat) {
  volatile char *ptr;
  char pattern;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr++) {
      pattern = *ptr;
      (void)pattern;
    }
  }
  end = TickCount();
  return end - start;
}

static int memtest_word(volatile char *addr, unsigned int len,
                        unsigned int repeat) {
  volatile char *ptr;
  unsigned short pattern = 0x55aa;

  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned short)) {
      *(unsigned short *)ptr = pattern;
    }
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned short)) {
      if (*(unsigned short *)ptr != pattern) {
        printf("Miscompare at 0x%08x: wrote %04x, read %04x\n",
               (unsigned int)ptr, pattern, *(unsigned short *)ptr);
        return 1;
      }
    }
    pattern = ~pattern;
  }
  return 0;
}

static int memspeed_wordwrite(volatile char *addr, unsigned int len,
                              unsigned int repeat) {
  volatile char *ptr;
  unsigned short pattern = 0x55aa;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned short)) {
      *(unsigned short *)ptr = pattern;
    }
    pattern = ~pattern;
  }
  end = TickCount();
  return end - start;
}

static int memspeed_wordread(volatile char *addr, unsigned int len,
                             unsigned int repeat) {
  volatile char *ptr;
  unsigned short pattern;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i += sizeof(unsigned short)) {
    for (ptr = addr; ptr < addr + len; ptr++) {
      pattern = *(unsigned short *)ptr;
      (void)pattern;
    }
  }
  end = TickCount();
  return end - start;
}

static int memtest_long(volatile char *addr, unsigned int len,
                        unsigned int repeat) {
  volatile char *ptr;
  unsigned int pattern = 0x5555aaaa;

  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned int)) {
      *(unsigned int *)ptr = pattern;
    }
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned int)) {
      if (*(unsigned int *)ptr != pattern) {
        printf("Miscompare at 0x%08x: wrote %08x, read %08x\n",
               (unsigned int)ptr, pattern, *(unsigned int *)ptr);
        return 1;
      }
    }
    pattern = ~pattern;
  }
  return 0;
}

static int memspeed_longwrite(volatile char *addr, unsigned int len,
                              unsigned int repeat) {
  volatile char *ptr;
  unsigned long pattern = 0x55aa;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i++) {
    for (ptr = addr; ptr < addr + len; ptr += sizeof(unsigned long)) {
      *(unsigned long *)ptr = pattern;
    }
    pattern = ~pattern;
  }
  end = TickCount();
  return end - start;
}

static int memspeed_longread(volatile char *addr, unsigned int len,
                             unsigned int repeat) {
  volatile char *ptr;
  unsigned int pattern;
  unsigned int start, end;

  start = TickCount();
  for (unsigned int i = 0; i < repeat; i += sizeof(unsigned int)) {
    for (ptr = addr; ptr < addr + len; ptr++) {
      pattern = *(unsigned int *)ptr;
      (void)pattern;
    }
  }
  end = TickCount();
  return end - start;
}

void test_memory(Ptr addr, unsigned int len, int iterations) {
  int err;

  unsigned int nTicks;
  float speed;

  printf("Testing byte access...\n");
  err = memtest_byte(addr, len, 1);
  if (!err) {
    printf("Memory check passed using byte read and write\n");
    nTicks = memspeed_bytewrite(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Byte write: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
    nTicks = memspeed_byteread(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Byte read: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
  }

  printf("Testing word access...\n");
  err = memtest_word(addr, len, 1);
  if (!err) {
    printf("Memory check passed using word read and write\n");
    nTicks = memspeed_wordwrite(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Word write: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
    nTicks = memspeed_wordread(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Word read: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
  }

  printf("Testing long access...\n");
  err = memtest_long(addr, len, 1);
  if (!err) {
    printf("Memory check passed using long read and write\n");
    nTicks = memspeed_longwrite(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Long write: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
    nTicks = memspeed_longread(addr, len, iterations);
    speed = (len * iterations) / (nTicks * TICK_SECONDS);
    printf("Long read: %d iterations in %d ticks = %f bytes/s\n", iterations,
           nTicks, speed);
  }
}

int findCards(Ptr cardAddresses[16]) {
  int cardCount = 0;
  long result;
  OSErr err;
  SpBlock spb;

  for (int i = 0; i < 16; i++) {
    cardAddresses[i] = nil;
  }


      spb.spParamData = 1 << fall;
      spb.spCategory = catNetwork;
      spb.spCType = typeEtherNet;
      spb.spDrvrSW = SETHERNET30_DRSW;
      spb.spDrvrHW = SETHERNET30_DRHW;
      spb.spTBMask = 0;
      spb.spSlot = 1;
      spb.spID = 1;
      spb.spExtDev = 0;

      err = SGetTypeSRsrc(&spb);
      while (err == noErr) {
        result = SFindDevBase(&spb);
        if (result == noErr) {
          printf("Found SEthernet/30 board in slot %x, base address %08x\n",
                 spb.spSlot, (unsigned int)spb.spResult);
          cardAddresses[cardCount++] = (Ptr)spb.spResult;
        } else {
          printf(
              "Found SEthernet/30 board in slot %x, but SFindDevBase() "
              "returned an error: %d\n",
              spb.spSlot, (int)result);
        }
        err = SGetTypeSRsrc(&spb);
      }
      printf("SGetTypeSRsrc: %d\n", err);
  return cardCount;
}

void help(void) {
    printf(
        "SEthernet Memory Tester\n"
        "Choose an option:\n"
        "  C: Search for and test installed cards\n"
        "  R: Test and benchmark system RAM\n"
        "  Q: Quit\n");
}

int main(int argc, char **argv) {
  (void)argc;
  (void)argv;

  char choice;
  const unsigned int memlen = 0x6000;
  const int iterations = 1000;
  Ptr cardAddresses[16];
  Ptr memstart;

  help();
  while (1) {

    choice = getchar();

    switch (toupper(choice)) {
      case 'C':
        printf("Searching for cards...\n");
        int nCards = findCards(cardAddresses);
        // int nCards = 1;
        // cardAddresses[0] = 0xfe000000;

        if (nCards > 0) {
          printf("Found %d cards...\n", nCards);
          for (int i = 0; i < nCards; i++) {
            printf("Testing card at %08x...\n", (unsigned int)cardAddresses[i]);
            test_memory(cardAddresses[i], memlen, iterations);
          }
        } else {
          printf("No cards found\n");
        }
        break;
      case 'R':
        memstart = NewPtr(memlen);
        printf("Testing RAM...\n");
        test_memory(memstart, memlen, iterations);
        DisposePtr(memstart);
        break;
      case 'Q':
        return 0;
      case '\r':
      case '\n':
        continue;
      default:
        help();
        break;
    }
    printf("\nTest [C]ard, Test [R]am, [Q]uit?\n");
  }
}
