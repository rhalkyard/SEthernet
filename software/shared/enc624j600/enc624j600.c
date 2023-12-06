#include "enc624j600.h"

#include "enc624j600_registers.h"

#include <MacTypes.h>
#include <string.h>

#include <Debugging.h>
#include <stdio.h>

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

/*
Promiscuous-mode receive configuration:
    CRCEN:    discard frames with invalid CRC
    RUNTEN:   discard runt frames
    UCEN:     accept unicast frames addressed to us
    NOTMEEN:  accept unicast frames addressed to destinations other than us
    MCEN:     accept all multicast frames
*/
#define RXFCON_PROMISCUOUS \
  ERXFCON_CRCEN | ERXFCON_RUNTEN | ERXFCON_UCEN | ERXFCON_NOTMEEN | ERXFCON_MCEN

/* Default receive configuration:
    CRCEN:    discard frames with invalid CRC
    RUNTEN:   discard runt frames
    UCEN:     accept unicast frames addressed to us
    BCEN:     accept broadcast frames
    HTEN:     accept frames with destination address in our hash table
              (used for multicast)
*/
#define RXFCON_DEFAULT ERXFCON_CRCEN | ERXFCON_RUNTEN | ERXFCON_UCEN | ERXFCON_BCEN | ERXFCON_HTEN

int enc624j600_reset(enc624j600 *chip) {
  /* Write and read-back a 'magic' value to user data start pointer to verify
  that chip is present and functioning */
  unsigned short magic = 0x1234;
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
  unsigned short tmp;
  unsigned short rxbuf_size, rx_tail, flow_hwm, flow_lwm;
  if (txbuf_size & 1) {
    /* Buffer boundary must be word-aligned */
    return -1;
  }

  /* Set up receive buffer between end of transmit buffer and end of RAM */
  ENC624J600_WRITE_REG(chip->base_address, ERXST, SWAPBYTES(txbuf_size));
  rx_tail = ENC624J600_MEM_END - 2;
  ENC624J600_WRITE_REG(chip->base_address, ERXTAIL, SWAPBYTES(rx_tail));
  chip->rxbuf_start = enc624j600_addr_to_ptr(chip, txbuf_size);
  chip->rxptr = chip->rxbuf_start;
  chip->rxbuf_end = enc624j600_addr_to_ptr(chip, ENC624J600_MEM_END);

  /* Set up flow control parameters. We only enable flow control for full-duplex
  links, as half-duplex flow control operates by jamming the medium, which is an
  extremely antisocial thing to do on shared-media links (such as if connected
  to a hub rather than a switch). */
  rxbuf_size = ENC624J600_MEM_END - txbuf_size;
  /* High water mark: Assert flow control when recieve buffer is 3/4 full (in
  units of 96 bytes) */
  flow_hwm = (rxbuf_size - (rxbuf_size / 4)) / 96;
  /* Low water mark: Deassert flow control when receive buffer is 1/2 full (in
  units of 96 bytes) */
  flow_lwm = (rxbuf_size / 2) / 96;
  tmp = (flow_hwm << ERXWM_RXFWM_SHIFT) | (flow_lwm << ERXWM_RXEWM_SHIFT);
  ENC624J600_WRITE_REG(chip->base_address, ERXWM, tmp);

  /* Set up 25MHz clock output (used by glue logic for timing generation). */
  tmp = ENC624J600_READ_REG(chip->base_address, ECON2);
  tmp &= ~ECON2_COCON_MASK;
  tmp |= 0b0010 << ECON2_COCON_SHIFT;
  ENC624J600_WRITE_REG(chip->base_address, ECON2, tmp);

  /* LED A = link, LED B = activity */
  ENC624J600_WRITE_REG(
      chip->base_address, EIDLED,
      (0b0010 << EIDLED_LACFG_SHIFT) | (0b0110 << EIDLED_LBCFG_SHIFT));

  return 0;
}

void enc624j600_duplex_sync(enc624j600 *chip) {
  /*
  Read autonegotiated full/half-duplex status from PHY, set MAC duplex and
  back-to-back interpacket gap as appropriate. Call on initial startup and after
  link state change.
  */
  unsigned fullduplex =
      ENC624J600_READ_REG(chip->base_address, ESTAT) & ESTAT_PHYDPX;

  /* Wait for flow control state machine to be idle before changing duplex mode
  or flow control settings */
  while (!(ENC624J600_READ_REG(chip->base_address, ESTAT) & ESTAT_FCIDLE)) {};
  
  if (fullduplex) {
    ENC624J600_SET_BITS(chip->base_address, MACON2, MACON2_FULDPX);
    ENC624J600_WRITE_REG(chip->base_address, MABBIPG,
                         0x15 << MABBIPG_BBIPG_SHIFT);
    /* Enable automtaic flow control */
    ENC624J600_SET_BITS(chip->base_address, ECON2, ECON2_AUTOFC);
  } else {
    ENC624J600_CLEAR_BITS(chip->base_address, MACON2, MACON2_FULDPX);
    ENC624J600_WRITE_REG(chip->base_address, MABBIPG,
                         0x12 << MABBIPG_BBIPG_SHIFT);
    /* Disable automatic flow control */
    ENC624J600_CLEAR_BITS(chip->base_address, ECON2, ECON2_AUTOFC);
    /* Ensure flow control is deasserted */
    ENC624J600_CLEAR_BITS(chip->base_address, ECON1, ECON1_FCOP1 | ECON1_FCOP1);
  }
}

void enc624j600_start(enc624j600 *chip) {
  /* Sync MAC duplex configuration with autonegotiated values from PHY */
  enc624j600_duplex_sync(chip);

  /* Accept broadcast packets, use hash table matching for multicast packets */
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_DEFAULT);
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_RXEN);
}

void enc624j600_suspend(enc624j600 *chip) {
  /* Disable receive */
  ENC624J600_CLEAR_BITS(chip->base_address, ECON1, ECON1_RXEN);

  /* Discard any pending packets */
  while (enc624j600_read_rx_pending_count(chip)) {
    enc624j600_decrement_rx_pending_count(chip);
  }
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
  words[1] = ENC624J600_READ_REG(chip->base_address, MAADR2);
  words[2] = ENC624J600_READ_REG(chip->base_address, MAADR3);
}

void enc624j600_write_hwaddr(enc624j600 *chip, const unsigned char addrbuf[6]) {
  unsigned short *words = (unsigned short *)addrbuf;

  ENC624J600_WRITE_REG(chip->base_address, MAADR1, words[0]);
  ENC624J600_WRITE_REG(chip->base_address, MAADR2, words[1]);
  ENC624J600_WRITE_REG(chip->base_address, MAADR3, words[2]);
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
  unsigned short addr = enc624j600_ptr_to_addr(chip, start_addr);

  /* Wait for any in-progress transmit to finish before starting a new one */
  while (ENC624J600_READ_REG(chip->base_address, ECON1) & ECON1_TXRTS) {
  };

  /* Set transmit start address (should always be chip base address, but set it
  for safety) */
  ENC624J600_WRITE_REG(chip->base_address, ETXST,  SWAPBYTES(addr));
  /* Set transmit length */
  ENC624J600_WRITE_REG(chip->base_address, ETXLEN, SWAPBYTES(length));
  /* Enable transmit (TXRTS bit will clear itself when transmit is complete) */
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_TXRTS);
}

void enc624j600_update_rxptr(enc624j600 *chip, unsigned char *rxptr) {
  chip->rxptr = rxptr;

  /* Recieve buffer tail must word aligned and at least 2 bytes behind read
  pointer */
  unsigned char * tail = rxptr - 2;
  if (tail < chip->rxbuf_start) {
    tail = chip->rxbuf_end - 2;
  }
  unsigned short addr = enc624j600_ptr_to_addr(chip, tail);
  ENC624J600_WRITE_REG(chip->base_address, ERXTAIL, SWAPBYTES(addr));
}

/* Read the number of pending bytes in the receive FIFO */
unsigned short enc624j600_read_rx_fifo_level(enc624j600 *chip) {
  unsigned short rxstart, rxhead, rxtail, buffersize;

  rxstart = ENC624J600_READ_REG(chip->base_address, ERXST);
  rxstart = SWAPBYTES(rxstart);
  
  rxhead = ENC624J600_READ_REG(chip->base_address, ERXHEAD);
  rxhead = SWAPBYTES(rxhead);
  
  rxtail = ENC624J600_READ_REG(chip->base_address, ERXTAIL);
  rxtail = SWAPBYTES(rxtail);

  buffersize = ENC624J600_MEM_END - rxstart;

  /* Subtract 2 to account for the 2 reserved bytes at the RX tail pointer */
  if (rxtail > rxhead) {
    return buffersize - (rxtail - rxhead) - 2;
  } else {
    return rxhead - rxtail - 2;
  }
}

void enc624j600_write_phy_reg(enc624j600 *chip, unsigned char phyreg,
                              unsigned short value) {
  /* Wait for internal MII to become available */
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  ENC624J600_WRITE_REG8(chip->base_address, MIWR, value & 0xff);
  ENC624J600_WRITE_REG8(chip->base_address, MIWR + 1, value >> 8);
}

unsigned short enc624j600_read_phy_reg(enc624j600 *chip, unsigned char phyreg) {
  /* Wait for internal MII to become available */
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  /* Wait for internal MII to finish read operation */
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
  enc624j600_write_phy_reg(chip, PHCON1, old_phcon1 & ~PHCON1_PLOOPBK);
}

void enc624j600_memcpy(unsigned char * dest, unsigned char * source, unsigned short len) {
  /* TODO: get rid of this and just use memcpy once issue #3 is resolved */
  for (int i = 0; i < len; i++) {
    *dest++ = *source++;
  }
}

unsigned short enc624j600_read_rxbuf(enc624j600 *chip, unsigned char * dest, unsigned short len) {
  unsigned short count, chunk_len, fifo_level;
  unsigned char * source;
  
  source = chip->rxptr;

  /* Don't try to read more data than is actually available */
  fifo_level =  enc624j600_read_rx_fifo_level(chip);
  if (len > fifo_level) {
    DebugStr("\pFlying too close to the sun");
  }
  len = MIN(len, fifo_level);
  count = len;

  do {
    if (source >= chip->rxbuf_end) {
      source = chip->rxbuf_start;
    }

    if (source + len >= chip->rxbuf_end) {
      chunk_len = chip->rxbuf_end - source;
    } else {
      chunk_len = len;
    }

    my_memcpy(dest, source, chunk_len);
    dest += chunk_len;
    source += chunk_len;
    len -= chunk_len;
    enc624j600_update_rxptr(chip, source);
  } while (len);

  return count;
}
