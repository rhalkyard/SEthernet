#include "enc624j600.h"

#include "enc624j600_registers.h"

#define RXFCON_PROMISCUOUS \
  ERXFCON_CRCEN | ERXFCON_RUNTEN | ERXFCON_UCEN | ERXFCON_NOTMEEN | ERXFCON_MCEN
#define RXFCON_DEFAULT ERXFCON_HTEN | ERXFCON_BCEN

int enc624j600_reset(enc624j600 *chip) {
  /* Write and read-back a 'magic' value to user data start pointer to verify
  that chip is present and functioning */
  short magic = 0x1234;
  ENC624J600_WRITE_REG(chip->base_address, EUDAST, SWAPBYTES(magic));
  if (ENC624J600_READ_REG(chip->base_address, EUDAST) != SWAPBYTES(magic)) {
    return -1;
  } else {
    /* Wait for clock to become ready */
    while (!(ENC624J600_READ_REG(chip->base_address, ESTAT) & ESTAT_CLKRDY)) {
    };
    /* Trigger a reset */
    ENC624J600_SET_BITS(chip->base_address, ECON2, ECON2_ETHRST);
  }

  return 0;
}

int enc624j600_init(enc624j600 *chip, unsigned short txbuf_size) {
  if (txbuf_size & 1) {
    /* Buffer boundary must be word-aligned */
    return -1;
  }

  /* Set up receive buffer between end of transmit buffer and end of RAM */
  ENC624J600_WRITE_REG(chip->base_address, ERXST, SWAPBYTES(txbuf_size));
  ENC624J600_WRITE_REG(chip->base_address, ERXTAIL,
                       SWAPBYTES(ENC624J600_MEM_END - 2));
  chip->rxbuf_start = enc624j600_addr_to_ptr(chip, txbuf_size);
  chip->rxbuf_end = enc624j600_addr_to_ptr(chip, ENC624J600_MEM_END);

  /* Disable clock output; we don't use it */
  ENC624J600_CLEAR_BITS(chip->base_address, ECON2,
                        ECON2_COCON_MASK << ECON2_COCON_SHIFT);

  /* LED A = link, LED B = activity */
  ENC624J600_WRITE_REG(
      chip->base_address, EIDLED,
      (0b0010 << EIDLED_LACFG_SHIFT) | (0b0110 << EIDLED_LBCFG_SHIFT));

  return 0;
}

void enc624j600_duplex_sync(enc624j600 *chip) {
  /*
  Read autonegotiated full/half-duplex status from PHY, set MAC duplex and
  back-to-back interpacket gap as appropriate. Call on initial startup and
  after link state change.
  */
  int fullduplex =
      ENC624J600_READ_REG(chip->base_address, ESTAT) & ESTAT_PHYDPX;
  if (fullduplex) {
    ENC624J600_SET_BITS(chip->base_address, MACON2, MACON2_FULDPX);
    ENC624J600_WRITE_REG(chip->base_address, MABBIPG,
                         0x15 << MABBIPG_BBIPG_SHIFT);
  } else {
    ENC624J600_CLEAR_BITS(chip->base_address, MACON2, MACON2_FULDPX);
    ENC624J600_WRITE_REG(chip->base_address, MABBIPG,
                         0x12 << MABBIPG_BBIPG_SHIFT);
  }
}

void enc624j600_start(enc624j600 *chip) {
  /* Sync MAC duplex configuration with autonegotiated values from PHY */
  enc624j600_duplex_sync(chip);

  /* Accept broadcast packets, use hash table matching for multicast packets */
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_DEFAULT);
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_RXEN);
}

void enc624j600_read_id(enc624j600 *chip, unsigned char *device_id,
                        unsigned char *revision) {
  unsigned short result = ENC624J600_READ_REG(chip->base_address, EIDLED);
  *device_id = (result >> EIDLED_DEVID_SHIFT) & EIDLED_DEVID_MASK;
  *revision = (result >> EIDLED_REVID_SHIFT) & EIDLED_REVID_MASK;
}

void enc624j600_read_hwaddr(enc624j600 *chip, unsigned char addrbuf[6]) {
  unsigned short *words = (unsigned short *)addrbuf;

  words[0] = ENC624J600_READ_REG(chip->base_address, MAADR1);
  words[0] = SWAPBYTES(words[0]);
  words[1] = ENC624J600_READ_REG(chip->base_address, MAADR2);
  words[1] = SWAPBYTES(words[1]);
  words[2] = ENC624J600_READ_REG(chip->base_address, MAADR3);
  words[2] = SWAPBYTES(words[2]);
}

void enc624j600_write_hwaddr(enc624j600 *chip, const unsigned char addrbuf[6]) {
  unsigned short *words = (unsigned short *)addrbuf;

  ENC624J600_WRITE_REG(chip->base_address, MAADR1, SWAPBYTES(words[0]));
  ENC624J600_WRITE_REG(chip->base_address, MAADR2, SWAPBYTES(words[1]));
  ENC624J600_WRITE_REG(chip->base_address, MAADR3, SWAPBYTES(words[2]));
}

void enc624j600_write_multicast_table(enc624j600 *chip,
                                      const unsigned short table[4]) {
  ENC624J600_WRITE_REG(chip->base_address, EHT1, SWAPBYTES(table[0]));
  ENC624J600_WRITE_REG(chip->base_address, EHT2, SWAPBYTES(table[1]));
  ENC624J600_WRITE_REG(chip->base_address, EHT3, SWAPBYTES(table[2]));
  ENC624J600_WRITE_REG(chip->base_address, EHT4, SWAPBYTES(table[3]));
}

void enc624j600_enable_promiscuous(enc624j600 *chip) {
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_PROMISCUOUS);
}

void enc624j600_disable_promiscuous(enc624j600 *chip) {
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_DEFAULT);
}

void enc624j600_enable_irq(enc624j600 *chip, unsigned short irqmask) {
  ENC624J600_SET_BITS(chip->base_address, EIE, irqmask);
}

void enc624j600_disable_irq(enc624j600 *chip, unsigned short irqmask) {
  ENC624J600_CLEAR_BITS(chip->base_address, EIE, irqmask);
}

unsigned short enc624j600_read_irqstate(enc624j600 *chip) {
  /* CRYPTEN bit of EIR is not an interrupt flag! mask it out */
  return ENC624J600_READ_REG(chip->base_address, EIR) & (~EIR_CRYPTEN);
}

void enc624j600_clear_irq(enc624j600 *chip, unsigned short irqmask) {
  /* CRYPTEN bit of EIR is not an interrupt flag! mask it out */
  ENC624J600_CLEAR_BITS(chip->base_address, EIR, irqmask & (~EIR_CRYPTEN));
}

unsigned char enc624j600_read_rx_pending_count(enc624j600 *chip) {
  return (ENC624J600_READ_REG(chip->base_address, ESTAT) >>
          ESTAT_PKTCNT_SHIFT) &
         ESTAT_PKTCNT_MASK;
}

void enc624j600_decrement_rx_pending_count(enc624j600 *chip) {
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_PKTDEC);
}

unsigned char *enc624j600_addr_to_ptr(enc624j600 *chip, unsigned short addr) {
  return chip->base_address + addr;
}

static unsigned short enc624j600_ptr_to_addr(enc624j600 *chip,
                                             const unsigned char *ptr) {
  return ptr - chip->base_address;
}

void enc624j600_transmit(enc624j600 *chip, const unsigned char *start_addr,
                         unsigned short length) {
  while (ENC624J600_READ_REG(chip->base_address, ECON1) & ECON1_TXRTS) {
  };

  ENC624J600_WRITE_REG(chip->base_address, ETXST,
                       SWAPBYTES(enc624j600_ptr_to_addr(chip, start_addr)));
  ENC624J600_WRITE_REG(chip->base_address, ETXLEN, SWAPBYTES(length));
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_TXRTS);
}

void enc624j600_update_rx_tail(enc624j600 *chip, unsigned char *tail) {
  /* Buffer tail must be word-aligned */
  tail = (unsigned char *)((unsigned long)tail & 0xFFFFFFFE);
  ENC624J600_WRITE_REG(chip->base_address, ERXTAIL,
                       SWAPBYTES(enc624j600_ptr_to_addr(chip, tail)));
}

unsigned short enc624j600_read_rx_fifo_level(enc624j600 *chip) {
  unsigned short bufsize = ENC624J600_READ_REG(chip->base_address, ERXST) -
                           ENC624J600_READ_REG(chip->base_address, ERXHEAD);
  int bytesfree = ENC624J600_READ_REG(chip->base_address, ERXTAIL) - ENC624J600_MEM_END;
  if (bytesfree < 0) {
    bytesfree = -bytesfree;
  }
  return bufsize - bytesfree;
}

void enc624j600_write_phy_reg(enc624j600 *chip, unsigned char phyreg,
                              unsigned short value) {
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  ENC624J600_WRITE_REG8(chip->base_address, MIWR, value & 0xff);
  ENC624J600_WRITE_REG8(chip->base_address, MIWR + 1, value >> 8);
}

unsigned short enc624j600_read_phy_reg(enc624j600 *chip, unsigned char phyreg) {
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  return ENC624J600_READ_REG(chip->base_address, MIRD);
}

void enc624j600_enable_phy_loopback(enc624j600 *chip) {
  unsigned short old_phcon1 = enc624j600_read_phy_reg(chip, PHCON1);
  enc624j600_write_phy_reg(chip, PHCON1, old_phcon1 | PHCON1_PLOOPBK);
}

void enc624j600_disable_phy_loopback(enc624j600 *chip) {
  unsigned short old_phcon1 = enc624j600_read_phy_reg(chip, PHCON1);
  enc624j600_write_phy_reg(chip, PHCON1, old_phcon1);
}
