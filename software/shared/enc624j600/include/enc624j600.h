#ifndef _ENC624J600_H_
#define _ENC624J600_H_

#include "enc624j600_registers.h"

enum enc624j600_link_state {
  LINK_DOWN = 0,
  LINK_UP,
  LINK_UP_FULLDPX
};
typedef enum enc624j600_link_state enc624j600_link_state;

struct enc624j600 {
  unsigned char *base_address; /* Base address of chip (also start of transmit
                                  buffer) */
  const unsigned char *rxbuf_start;  /* Pointer to start of receive buffer */
  const unsigned char *rxbuf_end;    /* Pointer to end of receive buffer */
  const unsigned char *rxptr;
  enc624j600_link_state link_state;
};
typedef struct enc624j600 enc624j600;

/* Receive Status Vector */
union enc624j600_rsv {
  struct {
    unsigned short pkt_len_le; /* packet length - LITTLE ENDIAN VALUE */
    unsigned char bits_23_16;  /* Bits 23-16 */
    unsigned char bits_31_24;  /* Bits 31-24 */
    unsigned char bits_39_32;  /* Bits 39-32 */
    unsigned char bits_47_40;  /* Bits 47-40 (all zeroes) */
  } __attribute__((packed));
  unsigned char bytes[6]; /* Access as a byte array, for use with RSV_BIT()
                           macro */
};
typedef union enc624j600_rsv enc624j600_rsv;

/* Note: While the ENC624J600 is a natively little-endian device, all the
functions below automatically byte-swap values as necessary. Manual
byte-swapping is only required when reading the next-packet pointer and the
pkt_len_le Receive Status Vector field from the receive buffer. */

/* Reset the chip. Must wait at least 25+256us before accessing chip again*/
int enc624j600_reset(const enc624j600 *chip);

/* Synchronise MAC duplex settings with PHY values. Call after link-change
 * event. */
void enc624j600_duplex_sync(enc624j600 *chip);

/* Initialize the chip, with the given receive buffer size. Transmit buffer
begins immediately after receive buffer and continues to end of memory. Receive
buffer size must be in multiples of 1 word. */
int enc624j600_init(enc624j600 *chip, const unsigned short rxbuf_len);

/* Start accepting packets */
void enc624j600_start(enc624j600 *chip);

/* Read device-ID and revision registers
    device_id: out-parameter, 1 byte
    revision:  out-parameter, 1 byte
 */
void enc624j600_read_id(const enc624j600 *chip, unsigned char *device_id,
                        unsigned char *revision);

/* Read ethernet address into addrbuf */
void enc624j600_read_hwaddr(const enc624j600 *chip, unsigned char addrbuf[6]);

/* Set ethernet address */
void enc624j600_write_hwaddr(const enc624j600 *chip,
                             const unsigned char addrbuf[6]);

/* Enable promiscuous mode */
void enc624j600_enable_promiscuous(const enc624j600 *chip);

/* Disable promiscuous mode */
void enc624j600_disable_promiscuous(const enc624j600 *chip);

/* Update the multicast hash table */
void enc624j600_write_multicast_table(const enc624j600 *chip,
                                      const unsigned short table[4]);

/* Enable or disable interrupts. Bits of irqmask are defined below */
static inline void enc624j600_enable_irq(const enc624j600 *chip,
                           const unsigned short irqmask) {
  ENC624J600_SET_BITS(chip->base_address, EIE, irqmask);
}

static inline void enc624j600_disable_irq(const enc624j600 *chip,
                            const unsigned short irqmask) {
  ENC624J600_CLEAR_BITS(chip->base_address, EIE, irqmask);
}

/* Read interrupt state. Bits of return value are defined below */
static inline unsigned short enc624j600_read_irqstate(const enc624j600 *chip) {
  /* CRYPTEN bit of EIR is not an interrupt flag! mask it out */
  return ENC624J600_READ_REG(chip->base_address, EIR) & (~EIR_CRYPTEN);
}

/* Clear interrupts. Bits of irqmask are defined below */
static inline void enc624j600_clear_irq(const enc624j600 *chip,
                          const unsigned short irqmask) {
  /* CRYPTEN bit of EIR is not an interrupt flag! mask it out */
  ENC624J600_CLEAR_BITS(chip->base_address, EIR, irqmask & (~EIR_CRYPTEN));
}

/* Read count of pending frames in receive buffer */
static inline unsigned char enc624j600_read_rx_pending_count(const enc624j600 *chip) {
  return (ENC624J600_READ_REG(chip->base_address, ESTAT) &
         ESTAT_PKTCNT_MASK) >> ESTAT_PKTCNT_SHIFT;
}

/* Decrement pending frame count */
static inline void enc624j600_decrement_rx_pending_count(const enc624j600 *chip) {
  ENC624J600_SET_BITS(chip->base_address, ECON1, ECON1_PKTDEC);
}

/* Update tail of receive ring buffer. tail is a 'real' pointer into the receive
buffer (as opposed to an offset relative to the chip base address).
Automatically aligns to word boundaries */
void enc624j600_update_rxptr(enc624j600 *chip, const unsigned char *rxptr);

/* Read the number of pending bytes in the receive FIFO */
unsigned short enc624j600_read_rx_fifo_level(const enc624j600 *chip);

/* Convert a chip address into a real pointer */
static inline unsigned char *enc624j600_addr_to_ptr(const enc624j600 *chip,
                                      const unsigned short addr) {
  return chip->base_address + addr;
}

static inline unsigned short enc624j600_ptr_to_addr(const enc624j600 *chip,
                                             const unsigned char *ptr) {
  return ptr - chip->base_address;
}

/* Transmit a packet. src must be within the chip transmit buffer */
void enc624j600_transmit(const enc624j600 *chip, const unsigned char *src,
                         unsigned short length);

/* Read and write PHY registers. Use with caution! */
unsigned short enc624j600_read_phy_reg(const enc624j600 *chip,
                                       const unsigned char phyreg);
void enc624j600_write_phy_reg(const enc624j600 *chip,
                              const unsigned char phyreg,
                              const unsigned short value);

/* Enable/disable internal loopback in the PHY */
void enc624j600_enable_phy_loopback(const enc624j600 *chip);
void enc624j600_disable_phy_loopback(const enc624j600 *chip);

/* Our own memcpy implementation that avoids longword writes */
void enc624j600_memcpy(unsigned char *dest, const unsigned char *source,
                       const unsigned short len);

#pragma parameter __D0 enc624j600_read_rxbuf(__A0, __A3, __D0)
unsigned short enc624j600_read_rxbuf(enc624j600 *chip, unsigned char *dest,
                                     unsigned short len);

/* Check to see if an ENC624J600 is present and functioning at baseaddress */
short int enc624j600_detect(const enc624j600 * chip);

/* Exchange the bytes in a word value */
#define SWAPBYTES(value) ((((value) & 0xff00) >> 8) | (((value) & 0x00ff) << 8))

/* An integer with bit n set */
#define BIT(n) (1 << (n))

/* Accessor macro for bits in the Receive Status Vector */
#define RSV_BIT(rsv, bitnum) \
  ((rsv).bytes[((bitnum) >> 3)] & (BIT((bitnum) & 0x7)))

/* Flag bits for irq functions */

/* Master IRQ enable (only valid for enc624j600_enable/disable_irq) */
#define IRQ_ENABLE BIT(7)
/* Modular exponentiation intrrupt */
#define IRQ_MODEX BIT(6)
/* Hashing engine interrupt */
#define IRQ_HASH BIT(5)
/* AES engine interrupt */
#define IRQ_AES BIT(4)
/* Link state change interrupt */
#define IRQ_LINK BIT(3)
/* Packet receive interrupt */
#define IRQ_PKT BIT(14)
/* DMA engine interrupt */
#define IRQ_DMA BIT(13)
/* Transmit-complete interrupt */
#define IRQ_TX BIT(11)
/* Transmit-abort inteerrupt */
#define IRQ_TX_ABORT BIT(10)
/* Receive-abort (a.k.a buffer overflow) interrupt */
#define IRQ_RX_ABORT BIT(9)
/* Receive packet counter overflow interrupt */
#define IRQ_PCNT_FULL BIT(8)

/* Useful bits in the Receive Status Vector, for use with RSV_BIT() macro */

/* Packet was received with CRC error */
#define RSV_BIT_CRC_ERR (20)
/* Packet length check error */
#define RSV_BIT_LENGTH_CHECK_ERR (21)
/* Packet length out of range */
#define RSV_BIT_LENGTH_RANGE_ERR (22)
/* Packet was received without errors */
#define RSV_BIT_OK (23)
/* Destination is multicast */
#define RSV_BIT_MULTICAST (24)
/* Destination is broadcast */
#define RSV_BIT_BROADCAST (25)
/* Destination matched a hash table entry */
#define RSV_BIT_HASH_MATCH (33)
/* Destination is unicast to us */
#define RSV_BIT_UNICAST (36)

#endif /* _ENC624J600_H_ */
