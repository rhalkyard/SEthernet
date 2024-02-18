/*
Utility functions for programming JEDEC parallel flash memories

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

struct flash_id {
  unsigned char manufacturer;
  unsigned char device;
};

typedef struct flash_id flash_id;

/*
Probe for flash device
    Returns 0 if probable flash device found, -1 if not found.

    Arguments:
        base_address - base address to probe
        id - out-parameter (may be NULL) - JEDEC manufacturer and device ID
        bytes
 */
int flash_probe(volatile unsigned char* base_address, flash_id* id);

/* Erase flash device at base_address */
void flash_erase(volatile unsigned char* base_address);

/*
Write data to a flash device

    Arguments:
        base_address    - base address of flash device
        offset          - offset within flash device to write to
        data            - buffer containing data to write
        len             - length of data to write
*/
int flash_write(volatile unsigned char* base_address, unsigned int offset,
                unsigned char* data, unsigned int len);

/*
Erase and program a flash device (equivalent to calling flash_erase followed by
flash_write)

   Arguments:
        base_address    - base address of flash device
        offset          - offset within flash device to write to
        data            - buffer containing data to write
        len             - length of data to write
*/
int flash_program(volatile unsigned char* base_address, unsigned int offset,
                  unsigned char* data, unsigned int len);
