#ifndef _ENC624J600_H_
#define _ENC624J600_H_

struct enc624j600 {
  unsigned char *base_address; /* Base address of chip (also start of transmit
                                  buffer) */
  unsigned char *rxbuf_start;  /* Pointer to start of receive buffer */
  unsigned char *rxbuf_end;    /* Pointer to end of receive buffer */
  unsigned char *rxptr;
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
int enc624j600_reset(enc624j600 *chip);

/* Synchronise MAC duplex settings with PHY values. Call after link-change
 * event. */
void enc624j600_duplex_sync(enc624j600 *chip);

/* Initialize the chip, with the given receive buffer size. Transmit buffer
begins immediately after receive buffer and continues to end of memory. Receive
buffer size must be in multiples of 1 word. */
int enc624j600_init(enc624j600 *chip, unsigned short rxbuf_len);

/* Start accepting packets */
void enc624j600_start(enc624j600 *chip);

void enc624j600_suspend(enc624j600 *chip);

/* Read device-ID and revision registers
    device_id: out-parameter, 1 byte
    revision:  out-parameter, 1 byte
 */
void enc624j600_read_id(enc624j600 *chip, unsigned char *device_id,
                        unsigned char *revision);

/* Read ethernet address into addrbuf */
void enc624j600_read_hwaddr(enc624j600 *chip, unsigned char addrbuf[6]);

/* Set ethernet address */
void enc624j600_write_hwaddr(enc624j600 *chip, const unsigned char addrbuf[6]);

/* Enable promiscuous mode */
void enc624j600_enable_promiscuous(enc624j600 *chip);

/* Disable promiscuous mode */
void enc624j600_disable_promiscuous(enc624j600 *chip);

/* Update the multicast hash table */
void enc624j600_write_multicast_table(enc624j600 *chip,
                                      const unsigned short table[4]);

/* Enable or disable interrupts. Bits of irqmask are defined below */
void enc624j600_enable_irq(enc624j600 *chip, unsigned short irqmask);
void enc624j600_disable_irq(enc624j600 *chip, unsigned short irqmask);

/* Read interrupt state. Bits of return value are defined below */
unsigned short enc624j600_read_irqstate(enc624j600 *chip);

/* Clear interrupts. Bits of irqmask are defined below */
void enc624j600_clear_irq(enc624j600 *chip, unsigned short irqmask);

/* Read count of pending frames in receive buffer */
unsigned char enc624j600_read_rx_pending_count(enc624j600 *chip);

/* Decrement pending frame count */
void enc624j600_decrement_rx_pending_count(enc624j600 *chip);

/* Update tail of receive ring buffer. tail is a 'real' pointer into the receive
buffer (as opposed to an offset relative to the chip base address).
Automatically aligns to word boundaries */
void enc624j600_update_rxptr(enc624j600 *chip, unsigned char *rxptr);

/* Read the number of pending bytes in the receive FIFO */
unsigned short enc624j600_read_rx_fifo_level(enc624j600 *chip);

/* Convert a chip address into a real pointer */
unsigned char *enc624j600_addr_to_ptr(enc624j600 *chip, unsigned short addr);

/* Transmit a packet. src must be within the chip transmit buffer */
void enc624j600_transmit(enc624j600 *chip, const unsigned char *src,
                         unsigned short length);

/* Read and write PHY registers. Use with caution! */
unsigned short enc624j600_read_phy_reg(enc624j600 *chip, unsigned char phyreg);
void enc624j600_write_phy_reg(enc624j600 *chip, unsigned char phyreg,
                              unsigned short value);

/* Enable/disable internal loopback in the PHY */
void enc624j600_enable_phy_loopback(enc624j600 * chip);
void enc624j600_disable_phy_loopback(enc624j600 * chip);

/* Our own memcpy implementation that avoids longword writes */
void enc624j600_memcpy(unsigned char * dest, unsigned char * source, unsigned short len);

unsigned short enc624j600_read_rxbuf(enc624j600 *chip, unsigned char * dest, unsigned short len);

/* Exchange the bytes in a word value */
#define SWAPBYTES(value) (((value) >> 8) | ((value) << 8))

/* An integer with bit n set */
#define BIT(n) (1 << (n))

/* Accessor macro for bits in the Receive Status Vector */
#define RSV_BIT(rsv, bitnum) \
  ((rsv).bytes[((bitnum) >> 3)] & (BIT((bitnum)&0x7)))

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
