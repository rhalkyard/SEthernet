/*
SEthernet/30 declaration ROM utility

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

#include <OSUtils.h>
#include <ctype.h>
#include <stdio.h>

#include "buserror.h"
#include "enc624j600.h"
#include "flash.h"
#include "se30-u2.h"

/* Start of SEthernet/30 declaration ROM within slot space */
#define DECLROM_OFFSET 0xff0000

/* Turn a slot number and an offset into slot space, into a pointer */
static inline unsigned char *slotptr(unsigned char slot, unsigned int offset) {
  if (GetMMUMode() == true32b) {
    /* 32 bit mode: slot space is 16MB, addressed at 0xFSxxxxxx*/
    return (unsigned char *)0xf0000000 + (slot << 24) + offset;
  } else {
    /* 24 bit mode: slot space is 1MB, addressed at 0xSxxxxx*/
    return (unsigned char *)(slot << 20) + (offset & 0xfffff);
  }
}

/*
Check to see which slots appear to have something in them. We can't use the
regular Slot Manager calls for this because we need to support the case where a
card has a blank or invalid declaration ROM

TODO: be smarter about this. We should only offer slots that we KNOW are
SEthernet/30s (i.e. have an SEthernet/30 board ID), or occupied slots that the
Slot Manager has no data on (likely an SEthernet/30 with a blank ROM)
*/
unsigned int probe_slots(void) {
  unsigned int result = 0;

  for (unsigned int slot = 9; slot < 0xf; slot++) {
    /* A valid slot will have the first byte of its declaration rom
    somewhere in the top of the slot address space */
    for (int offset = DECLROM_OFFSET+0xffff; offset >= DECLROM_OFFSET+0xfff0;
         offset--) {
      if (buserror_probe(slotptr(slot, offset)) >= 0) {
        result |= 1 << slot;
        break;
      }
    }
  }
  return result;
}

/* Try to detect an ENC624J600 */
int check_slot(int slot) {
  enc624j600 chip = {.base_address = slotptr(slot, 0)};

  return enc624j600_detect(&chip);
}

int main(__attribute__((unused)) int argc,
         __attribute__((unused)) char **argv) {
  unsigned int occupied_slots;
  unsigned int slot;
  unsigned char ch;
  printf("**** SEthernet/30 ROM programming tool ****\n\n");
  
redo:
  occupied_slots = probe_slots();
  printf("Occupied slots: ");
  for (slot = 9; slot < 0xf; slot++) {
    if (occupied_slots & (1 << slot)) {
      printf("%x ", slot);
    }
  }
  printf("\n");
  printf("Select a slot to program, or Q to quit:\n");
  ch = getchar();
  switch (ch) {
    case '9':
      slot = 0x9;
      break;
    case 'a':
    case 'A':
      slot = 0xa;
      break;
    case 'b':
    case 'B':
      slot = 0xb;
      break;
    case 'c':
    case 'C':
      slot = 0xc;
      break;
    case 'd':
    case 'D':
      slot = 0xd;
      break;
    case 'e':
    case 'E':
      slot = 0xe;
      break;
    case 'q':
    case 'Q':
      return 0;
    default:
      goto redo;
  }

  if (!(occupied_slots & (1 << slot))) {
    goto redo;
  }

  printf(
      "Are you SURE you want to program the Declaration ROM for Slot %x? "
      "(Y/N)\n",
      slot);
  do {
    ch = toupper(getchar());
  } while (ch != 'Y' && ch != 'N');
  if (ch != 'Y') {
    goto redo;
  }
  getchar(); /* eat newline */

  if (check_slot(slot) != 0) {
    printf(
        "Slot %x does not seem to have an ENC624J600 chip present. Bailing "
        "out.\n",
        slot);
    goto redo;
  }

  if (flash_program(slotptr(slot, DECLROM_OFFSET), 0, se30_u2_rom,
                    se30_u2_rom_len) == 0) {
    printf("Programming completed.\n");
  } else {
    printf("Programming failed!\n");
  }
  printf("Please restart your computer after running this application.\n");

  printf("Press RETURN to exit\n");
  getchar();
  return 0;
}
