#include "enc624j600.h"
#include "enc624j600_registers.h"
#include "memtest.h"

#include <MacTypes.h>
#include <string.h>

#if defined(DEBUG)
#include <Debugging.h>
#include <stdio.h>
extern char strbuf[255];
#endif

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
#define RXFCON_DEFAULT \
  ERXFCON_CRCEN | ERXFCON_RUNTEN | ERXFCON_UCEN | ERXFCON_BCEN | ERXFCON_HTEN

int enc624j600_reset(const enc624j600 *chip) {
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

int enc624j600_init(enc624j600 *chip, const unsigned short txbuf_size) {
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
  tmp |= 0x2 << ECON2_COCON_SHIFT; /* COCON=0010 = 25MHz clock output */
  ENC624J600_WRITE_REG(chip->base_address, ECON2, tmp);

  /* LED A = link, LED B = activity */
  ENC624J600_WRITE_REG(
      chip->base_address, EIDLED,
      (0x2 << EIDLED_LACFG_SHIFT) | /* LACFG=0010 = LED A indicates link state */
      (0x6 << EIDLED_LBCFG_SHIFT)); /* LBCFG=0110 = LED B indicates activity */

  return 0;
}

void enc624j600_duplex_sync(enc624j600 *chip) {
  /*
  Read autonegotiated full/half-duplex status from PHY, set MAC duplex and
  back-to-back interpacket gap as appropriate. Call on initial startup and after
  link state change.
  */
  unsigned short estat = ENC624J600_READ_REG(chip->base_address, ESTAT);

  /* Get link state info. TODO: read link speed from PHY */
  if (estat & ESTAT_PHYLNK) {
    if (estat & ESTAT_PHYDPX) {
      chip->link_state = LINK_UP_FULLDPX;
    } else {
      chip->link_state = LINK_UP;
    }
  } else {
    /* Don't bother if link is down */
    chip->link_state = LINK_DOWN;
  }

  /* Wait for flow control state machine to be idle before changing duplex mode
  or flow control settings */
  while (!(ENC624J600_READ_REG(chip->base_address, ESTAT) & ESTAT_FCIDLE)) {};

  if (estat & ESTAT_PHYDPX) {
    /* Full duplex */
    ENC624J600_SET_BITS(chip->base_address, MACON2, MACON2_FULDPX);
    ENC624J600_WRITE_REG(chip->base_address, MABBIPG,
                         0x15 << MABBIPG_BBIPG_SHIFT);
    /* Enable automtaic flow control */
    ENC624J600_SET_BITS(chip->base_address, ECON2, ECON2_AUTOFC);
  } else {
    /* Half duplex */
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

void enc624j600_read_id(const enc624j600 *chip, unsigned char *device_id,
                        unsigned char *revision) {
  unsigned short result = ENC624J600_READ_REG(chip->base_address, EIDLED);
  *device_id = (result & EIDLED_DEVID_MASK) >> EIDLED_DEVID_SHIFT;
  *revision = (result & EIDLED_REVID_MASK) >> EIDLED_REVID_SHIFT;
}

void enc624j600_read_hwaddr(const enc624j600 *chip, unsigned char addrbuf[6]) {
  unsigned short *words = (unsigned short *)addrbuf;

  words[0] = ENC624J600_READ_REG(chip->base_address, MAADR1);
  words[1] = ENC624J600_READ_REG(chip->base_address, MAADR2);
  words[2] = ENC624J600_READ_REG(chip->base_address, MAADR3);
}

void enc624j600_write_hwaddr(const enc624j600 *chip,
                             const unsigned char addrbuf[6]) {
  unsigned short *words = (unsigned short *)addrbuf;

  ENC624J600_WRITE_REG(chip->base_address, MAADR1, words[0]);
  ENC624J600_WRITE_REG(chip->base_address, MAADR2, words[1]);
  ENC624J600_WRITE_REG(chip->base_address, MAADR3, words[2]);
}

void enc624j600_write_multicast_table(const enc624j600 *chip,
                                      const unsigned short table[4]) {
  ENC624J600_WRITE_REG(chip->base_address, EHT1, SWAPBYTES(table[0]));
  ENC624J600_WRITE_REG(chip->base_address, EHT2, SWAPBYTES(table[1]));
  ENC624J600_WRITE_REG(chip->base_address, EHT3, SWAPBYTES(table[2]));
  ENC624J600_WRITE_REG(chip->base_address, EHT4, SWAPBYTES(table[3]));
}

void enc624j600_enable_promiscuous(const enc624j600 *chip) {
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_PROMISCUOUS);
}

void enc624j600_disable_promiscuous(const enc624j600 *chip) {
  ENC624J600_WRITE_REG(chip->base_address, ERXFCON, RXFCON_DEFAULT);
}

void enc624j600_transmit(const enc624j600 *chip,
                         const unsigned char *start_addr,
                         const unsigned short length) {
  /* Cancel any transmit that's currently in-progress. This shouldn't happen,
  but if it does, the transmit data will have been stomped on when the transmit
  buffer was rewritten prior to this call, so it's better to stop it now than
  wait for it to finish. */
  ENC624J600_CLEAR_BITS(chip->base_address, ECON1, ECON1_TXRTS);

  unsigned short addr = enc624j600_ptr_to_addr(chip, start_addr);

  /* Set transmit start address (should always be chip base address, but set it
  for safety) */
  ENC624J600_WRITE_REG(chip->base_address, ETXST, SWAPBYTES(addr));
  /* Set transmit length */
  ENC624J600_WRITE_REG(chip->base_address, ETXLEN, SWAPBYTES(length));
  /* Enable transmit (TXRTS bit will clear itself when transmit is complete) */
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_TXRTS);
}

inline void enc624j600_update_rxptr(enc624j600 *chip, const unsigned char * rxptr) {
  chip->rxptr = rxptr;

  /* Recieve buffer tail must word aligned and at least 2 bytes behind read
  pointer */
  const unsigned char *tail = rxptr - 2;
  if (tail < chip->rxbuf_start) {
    tail = chip->rxbuf_end - 2;
  }
  unsigned short addr = enc624j600_ptr_to_addr(chip, tail);
  ENC624J600_WRITE_REG(chip->base_address, ERXTAIL, SWAPBYTES(addr));
}

/* Read the number of pending bytes in the receive FIFO */
unsigned short enc624j600_read_rx_fifo_level(const enc624j600 *chip) {
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

void enc624j600_write_phy_reg(const enc624j600 *chip,
                              const unsigned char phyreg,
                              const unsigned short value) {
  /* Wait for internal MII to become available */
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  /* only write low half of MIREGADR, the high half is reserved */
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  ENC624J600_WRITE_REG(chip->base_address, MIWR, SWAPBYTES(value));
}

unsigned short enc624j600_read_phy_reg(const enc624j600 *chip,
                                       const unsigned char phyreg) {
  /* Wait for internal MII to become available */
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  /* only write low half of MIREGADR, the high half is reserved */
  ENC624J600_WRITE_REG8(chip->base_address, MIREGADR, phyreg);
  ENC624J600_SET_BITS(chip->base_address, MICMD, MICMD_MIIRD);
  /* Wait for internal MII to finish read operation */
  while (ENC624J600_READ_REG(chip->base_address, MISTAT) & MISTAT_BUSY) {
  }
  ENC624J600_CLEAR_BITS(chip->base_address, MICMD, MICMD_MIIRD);
  return ENC624J600_READ_REG(chip->base_address, MIRD);
}

void enc624j600_enable_phy_loopback(const enc624j600 *chip) {
  unsigned short old_phcon1 = enc624j600_read_phy_reg(chip, PHCON1);
  enc624j600_write_phy_reg(chip, PHCON1, old_phcon1 | PHCON1_PLOOPBK);
}

void enc624j600_disable_phy_loopback(const enc624j600 *chip) {
  unsigned short old_phcon1 = enc624j600_read_phy_reg(chip, PHCON1);
  enc624j600_write_phy_reg(chip, PHCON1, old_phcon1 & ~PHCON1_PLOOPBK);
}

void enc624j600_memcpy(unsigned char *dest, const unsigned char *source,
                       const unsigned short len) {
  /* TODO: get rid of this and just use memcpy once issue #3 is resolved */
  for (int i = 0; i < len; i++) {
    *dest++ = *source++;
  }
}

#pragma parameter __D0 enc624j600_read_rxbuf(__A0, __A3, __D0)
unsigned short enc624j600_read_rxbuf(enc624j600 *chip, unsigned char * dest, 
                                     const unsigned short len) {
  unsigned short chunk_len, remainder;
  const unsigned char * source = chip->rxptr;

#if defined(DEBUG)
  /* Don't try to read more data than is actually available. This shouldn't ever
  happen, but check for it as an indicator of misbehaving software */
  if (len > chip->rxbuf_end - chip->rxbuf_start) {
    strbuf[0] =
        sprintf(strbuf + 1, "Read length %d exceeds RX buffer size %ld!!", 
                len, chip->rxbuf_end - chip->rxbuf_start);
    DebugStr((unsigned char *)strbuf);
  } else if (len > enc624j600_read_rx_fifo_level(chip)) {
    strbuf[0] = sprintf(
        strbuf + 1, "Read length %d exceeds current RX buffer occupancy %d!!",
        len, enc624j600_read_rx_fifo_level(chip));
    DebugStr((unsigned char *)strbuf);
  }
#endif

  /* Do first read, going as far as the end of the buffer */
  if (source + len > chip->rxbuf_end) {
    chunk_len = chip->rxbuf_end - source;
    remainder = len - chunk_len;
  } else {
    chunk_len = len;
    remainder = 0;
  }
  memcpy(dest, source, chunk_len);
  dest += chunk_len;
  source += chunk_len;

  /* Wrap read pointer if we hit the end */
  if (source >= chip->rxbuf_end) {
    source = chip->rxbuf_start;
  }

  /* Do another read if the first read didn't get everything */
  if (remainder) {
    memcpy(dest, source, remainder);
    source += remainder;
  }

  enc624j600_update_rxptr(chip, source);

  return len;
}

short int enc624j600_detect(const enc624j600 * chip) {
  const int detect_memlen = 64;
  unsigned short uda_readptr, uda_readptr_after;
  unsigned char regdata, ramdata;

  /*
  The ENC624J600 is somewhat lacking in ways to positively identify the device -
  Microchip seems to use a number of different MAC OUIs, and while there is a
  hardware ID and revision register, the datasheet does not indicate what these
  values should look like!

  Thus, we have to get a bit creative and try to identify the chip by its
  behavior, while avoiding doing things that might upset other hardware that
  might be present (i.e. writes). Thankfully, the indirection registers for
  accessing buffer RAM are perfect for this - we don't use them otherwise, so
  it's safe for us to mess with them, and the auto-increment behavior that they
  exhibit means that we can induce identifiable behavior solely through read
  accesses.

  This test may return a false negative if the chip is 'running' and receiving
  data and happens to overwrite the memory area that we are testing. However,
  this is unlikely.
  */
  for (int i = 0; i < detect_memlen; i++) {
    /* Read the User Data read pointer */
    uda_readptr = ENC624J600_READ_REG(chip->base_address, EUDARDPT);
    uda_readptr = SWAPBYTES(uda_readptr);

    /* Read a byte of data through the User Data window */
    regdata = ENC624J600_READ_REG8(chip->base_address, EUDADATA);
    /* ... and read what should be the same byte of data directly from RAM */
    ramdata = *(chip->base_address + uda_readptr);

    /* The values read back should be the same */
    if (regdata != ramdata) {
      return -1;
    }

    /* Read the User Data read pointer again; accessing the User Data window
    register should have caused it to either increment by 1 or wrap around to a
    smaller value */
    uda_readptr_after = ENC624J600_READ_REG(chip->base_address, EUDARDPT);
    uda_readptr_after = SWAPBYTES(uda_readptr_after);
    if (!(uda_readptr_after == uda_readptr + 1 
          || uda_readptr_after < uda_readptr)) {
      return -1;
    }
  }

  return 0;
}

short int enc624j600_memtest(const enc624j600 * chip) {
  if (memTestDevice((unsigned short *) chip->base_address, ENC624J600_MEM_END)) {
    return -1;
  }
  return 0;
}
