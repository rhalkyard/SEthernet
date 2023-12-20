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
