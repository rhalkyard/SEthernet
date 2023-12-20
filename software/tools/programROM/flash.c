#include "flash.h"

#include <stddef.h>

enum {
  cmd_chiperase = 0x10,
  cmd_byteerase = 0x30,
  cmd_erase = 0x80,
  cmd_id = 0x90,
  cmd_bytewrite = 0xa0,
  cmd_idexit = 0xf0
};

/* Send JEDEC '3-byte write' command to device at base_address */
static void flash_3byte(volatile unsigned char* base_address,
                        unsigned char command) {
  *(base_address + 0x5555) = 0xaa;
  *(base_address + 0x2aaa) = 0x55;
  *(base_address + 0x5555) = command;
}

int flash_probe(volatile unsigned char* base_address, flash_id* id) {
  unsigned char origdata_0 = *base_address;
  unsigned char origdata_1 = *(base_address + 1);
  unsigned char manufacturer, device;

  flash_3byte(base_address, cmd_id);
  manufacturer = *base_address;
  device = *(base_address + 1);
  flash_3byte(base_address, cmd_idexit);

  if (manufacturer == origdata_0 && device == origdata_1) {
    return -1;
  }

  if (id != NULL) {
    id->manufacturer = manufacturer;
    id->device = device;
  }

  return 0;
}

void flash_erase(volatile unsigned char* base_address) {
  flash_3byte(base_address, cmd_erase);
  flash_3byte(base_address, cmd_chiperase);
  while (*base_address != 0xff) {
  };
}

static void flash_writebyte(volatile unsigned char* base_address,
                            unsigned int offset, unsigned char data) {
  flash_3byte(base_address, cmd_bytewrite);
  *(base_address + offset) = data;

  while (*(base_address + offset) != data) {
  };
}

int flash_write(volatile unsigned char* base_address, unsigned int offset,
                unsigned char* data, unsigned int len) {
  for (unsigned int i = 0; i < len; i++) {
    flash_writebyte(base_address, offset + i, data[i]);
  }
  for (unsigned int i = 0; i < len; i++) {
    if (*(base_address + offset + i) != data[i]) {
      return -1;
    }
  }
  return 0;
}

int flash_program(volatile unsigned char* base_address, unsigned int offset,
                  unsigned char* data, unsigned int len) {
  flash_erase(base_address);
  return flash_write(base_address, offset, data, len);
}