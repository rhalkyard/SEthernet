#ifndef ENC624J600_REGISTERS_H
#define ENC624J600_REGISTERS_H

#define ENC624J600_MEM_END ((unsigned short) 0x6000)

#define BIT(n) (1 << (n))

/*
Accessor macros for ENC624J600 registers:

  base: the base address of the ENC624J600
  reg_offset: the address of the register in the ENC624J600's memory map
  value: a 16-bit value to write to the register

Note that for some reason the datasheet's register table for the 16 bit PSP bus
register map gives register addresses as *word* rather than byte offsets. The
address map for the 8 bit bus gives byte offsets.
*/

/* Create a word pointer from a register */
#define ENC624J600_REG(base, reg_offset) \
  ((volatile unsigned short *)((base) + (reg_offset)))

/* Create a byte pointer from a register */
#define ENC624J600_REG8(base, reg_offset) \
  ((volatile unsigned char *)((base) + (reg_offset)))

/* Write a 16-bit value to a register*/
#define ENC624J600_WRITE_REG(base, reg_offset, value) \
  (*ENC624J600_REG(base, reg_offset) = (value))

/* Read a 16-bit value from a register */
#define ENC624J600_READ_REG(base, reg_offset) \
  (*ENC624J600_REG(base, reg_offset))

/* Write an 8-bit value to a register */
#define ENC624J600_WRITE_REG8(base, reg_offset, value) \
  (*ENC624J600_REG8(base, reg_offset) = (value))

/* Read an 8-bit value from a register */
#define ENC624J600_READ_REG8(base, reg_offset) \
  (*ENC624J600_REG8(base, reg_offset))

/*
The ENC624J600 has special registers that allow individual bits of certain
registers to be set or cleared, saving us a read-modify-write cycle. Note that
while the bit-set and -clear registers are at a fixed offset from the main
registers, not all registers can be manipulated in this way!
*/

/*
Set bits in a register using the set-bit register at reg_offset + 0x100

Equivalent to (but faster than):
  unsignd short tmp = ENC624J600_READ_REG(base, reg_offset);
  tmp |= bitfield
  ENC624J600_WRITE_REG(base, reg_offset, tmp);
*/
#define ENC624J600_SET_BITS(base, reg_offset, bitfield)                       \
  ENC624J600_WRITE_REG(base, reg_offset + ENC624J600_SET_BIT_REGISTER_OFFSET, \
                       bitfield)

/*
Clear bits in a register using the clear-bit register at reg_offset + 0x180

Equivalent to (but faster than):
  unsigned short tmp = ENC624J600_READ_REG(base, reg_offset);
  tmp &= ~bitfield
  ENC624J600_WRITE_REG(base, reg_offset, tmp);
*/
#define ENC624J600_CLEAR_BITS(base, reg_offset, bitfield) \
  ENC624J600_WRITE_REG(                                   \
      base, reg_offset + ENC624J600_CLEAR_BIT_REGISTER_OFFSET, bitfield)

/*
As per best practice when connecting little-endian and big-endian devices (see
http://www.cpu-ns32k.net/files/AN591.pdf), the ENC624J600 is connected to the
68k bus with its low and high bytes swapped. This means that 'stream of bytes'
data (i.e. network packets) is addressed in the right order, but word-length
data has the wrong byte order.

For bitfields, this is taken care of in the bit definitions below (i.e. bit 15
in the datasheet is represented as bit 7, bit 0 as bit 8, etc.), but pointers
etc. will need to be byteswapped.

This makes register access a bit convoluted but it's much less of a performance
hit than having to swap the bytes in every network packet!

Some general rules for register access:
  - Always access bitfield registers as whole words and select bits using the
    definitions below.

  - Use set-bit (register + 0x100) and clear-bit (register + 0x180) registers
    whenever possible - it's faster than a read-modify-write, and it avoids any
    risk of disturbing other data in the register.

  - Swap bytes when accessing word registers such as pointers.

  - Swap bytes when reading the next-packet pointer and packet-length fields in
    the receive buffer.

  - Don't swap bytes when reading or writing packet data.
*/

/* Set-bit registers are 0x100 bytes offset from their corresponding register.
 */
#define ENC624J600_SET_BIT_REGISTER_OFFSET 0x100
/* Clear-bit registers are 0x180 bytes offset from their corresponding register
 */
#define ENC624J600_CLEAR_BIT_REGISTER_OFFSET 0x180

#define ETXST 0x7e00
#define ETXLEN 0x7e02
#define ERXST 0x7e04
#define ERXTAIL 0x7e06
#define ERXHEAD 0x7e08
#define EDMAST 0x7e0a
#define EDMALEN 0x7e0c
#define EDMADST 0x7e0e
#define EDMACS 0x7e10
#define ETXSTAT 0x7e12
#define ETXWIRE 0x7e14

#define EUDAST 0x7e16
#define EUDAND 0x7e18
#define ESTAT 0x7e1a
#define EIR 0x7e1c
#define ECON1 0x7e1e

#define EHT1 0x7e20
#define EHT2 0x7e22
#define EHT3 0x7e24
#define EHT4 0x7e26
#define EPMM1 0x7e28
#define EPMM2 0x7e2a
#define EPMM3 0x7e2c
#define EPMM4 0x7e2e
#define EPMCS 0x7e30
#define EPMOL 0x7e32
#define ERXFCON 0x7e34

#define MACON1 0x7e40
#define MACON2 0x7e42
#define MABBIPG 0x7e44
#define MAIPG 0x7e46
#define MACLCON 0x7e48
#define MAMXFLL 0x7e4a
#define MICMD 0x7e52
#define MIREGADR 0x7e54

#define MAADR3 0x7e60
#define MAADR2 0x7e62
#define MAADR1 0x7e64
#define MIWR 0x7e66
#define MIRD 0x7e68
#define MISTAT 0x7e6a
#define EPAUS 0x7e6c
#define ECON2 0x7e6e
#define ERXWM 0x7e70
#define EIE 0x7e72
#define EIDLED 0x7e74

#define EGPRDPT 0x7e86
#define EGPWRPT 0x7e88
#define ERXRDPT 0x7e8a
#define ERXWRPT 0x7e8c
#define EUDARDPT 0x7e8e
#define EUDAWRPT 0x7e90

/* WARNING: 8 bit registers!!!*/
#define EGPDATA 0x7e81
#define ERXDATA 0x7e83
#define EUDADATA 0x7e85

/* PHY registers */
#define PHCON1  0x00
#define PHSTAT1 0x01
#define PHANA   0x04
#define PHANLPA 0x05
#define PHANE 0x06
#define PHCON2 0x11
#define PHSTAT2 0x1b
#define PHSTAT3 0x1f

/* PHCON1 */
#define PHCON1_PRST BIT(7)
#define PHCON1_PLOOPBK BIT(6)
#define PHCON1_SPD100 BIT(5)
#define PHCON1_ANEN BIT(4)
#define PHCON1_PSLEEP BIT(3)
#define PHCON1_RENEG BIT(1)
#define PHCON1_PFULDPX BIT(0)

/* PHSTAT1 */
#define PHSTAT1_FULL100 BIT(6)
#define PHSTAT1_HALF100 BIT(5)
#define PHSTAT1_FULL10 BIT(4)
#define PHSTAT1_HALF10 BIT(3)
#define PHSTAT1_ANDONE BIT(13)
#define PHSTAT1_LRFAULT BIT(12)
#define PHSTAT1_ANABLE BIT(11)
#define PHSTAT1_LLSTAT BIT(10)
#define PHSTAT1_EXTREGS BIT(8)

/* PHANA */
#define PHANA_ADNP BIT(7)
#define PHANA_ADFAULT BIT(5)
#define PHANA_ADPAUS1 BIT(3)
#define PHANA_ADPAUS0 BIT(2)
#define PHANA_AD100FD BIT(0)
#define PHANA_AD100 BIT(15)
#define PHANA_AD10FD BIT(14)
#define PHANA_AD10 BIT(13)
#define PHANA_ADIEEE_SHIFT (8)
#define PHANA_ADIEEE_MASK (0x00ff)

/* PHANLPA */
#define PHANLPA_LPNP BIT(7)
#define PHANLPA_LPACK BIT(6)
#define PHANLPA_LPFAULT BIT(5)
#define PHANLPA_LPPAUS1 BIT(3)
#define PHANLPA_LPPAUS0 BIT(2)
#define PHANLPA_LP100T4 BIT(1)
#define PHANLPA_LP100FD BIT(0)
#define PHANLPA_LP100 BIT(15)
#define PHANLPA_LP10FD BIT(14)
#define PHANLPA_LP10 BIT(13)
#define PHANLPA_LPIEEE_SHIFT (8)
#define PHANLPA_LPIEEE_MASK (0x00ff)

/* PHANE */
#define PHANE_PDFLT BIT(12)
#define PHANE_LPARCD BIT(9)
#define PHANE_LPANABL BIT(8)

/* PHCON2 */
#define PHCON2_EDPWRDN BIT(5)
#define PHCON2_EDTHRES BIT(3)
#define PHCON2_FRCLNK BIT(10)
#define PHCON2_EDSTAT BIT(9)

/* PHSTAT2 */
#define PHSTAT2_PLRITY BIT(12)

/* PHSTAT3 */
#define PHSTAT3_SPDDPX_SHIFT (10)
#define PHSTAT3_SPDDPX_MASK (0x0007)

/* Bit definitions */
/* ESTAT */
#define ESTAT_INT BIT(7)
#define ESTAT_FCIDLE BIT(6)
#define ESTAT_RXBUSY BIT(5)
#define ESTAT_CLKRDY BIT(4)
#define ESTAT_PHYDPX BIT(2)
#define ESTAT_PHYLNK BIT(0)
#define ESTAT_PKTCNT_SHIFT (8)
#define ESTAT_PKTCNT_MASK (0x00ff)

/* EIR */
#define EIR_CRYPTEN BIT(7)
#define EIR_MODEXIF BIT(6)
#define EIR_HASHIF BIT(5)
#define EIR_AESIF BIT(4)
#define EIR_LINKIF BIT(3)
#define EIR_PKTIF BIT(14)
#define EIR_DMAIF BIT(13)
#define EIR_TXIF BIT(11)
#define EIR_TXABTIF BIT(10)
#define EIR_RXABTIF BIT(9)
#define EIR_PCFULIF BIT(8)

/* ECON1 */
#define ECON1_MODEXST BIT(7)
#define ECON1_HASHEN BIT(6)
#define ECON1_HASHOP BIT(5)
#define ECON1_HASHLST BIT(4)
#define ECON1_AESST BIT(3)
#define ECON1_AESOP1 BIT(2)
#define ECON1_AESOP0 BIT(1)
#define ECON1_PKTDEC BIT(0)
#define ECON1_FCOP1 BIT(15)
#define ECON1_FCOP0 BIT(14)
#define ECON1_DMAST BIT(13)
#define ECON1_DMACPY BIT(12)
#define ECON1_DMACSSD BIT(11)
#define ECON1_DMANOCS BIT(10)
#define ECON1_TXRTS BIT(9)
#define ECON1_RXEN BIT(8)

/* ETXSTAT */
#define ETXSTAT_LATECOL BIT(2)
#define ETXSTAT_MAXCOL BIT(1)
#define ETXSTAT_EXDEFER BIT(0)
#define ETXSTAT_DEFER BIT(15)
#define ETXSTAT_CRCBAD BIT(12)
#define ETXSTAT_COLCNT_SHIFT (8)
#define ETXSTAT_COLCNT_MASK (0x000f)

/* ERXFCON */
#define ERXFCON_HTEN BIT(7)
#define ERXFCON_MPEN BIT(6)
#define ERXFCON_NOTPM BIT(4)
#define ERXFCON_PMEN_SHIFT (0)
#define ERXFCON_PMEN_MASK (0x000f)
#define ERXFCON_CRCEEN BIT(15)
#define ERXFCON_CRCEN BIT(14)
#define ERXFCON_RUNTEEN BIT(13)
#define ERXFCON_RUNTEN BIT(12)
#define ERXFCON_UCEN BIT(11)
#define ERXFCON_NOTMEEN BIT(10)
#define ERXFCON_MCEN BIT(9)
#define ERXFCON_BCEN BIT(8)

/* MACON1 */
#define MACON1_LOOPBK BIT(12)
#define MACON1_RXPAUS BIT(10)
#define MACON1_PASSALL BIT(9)

/* MACON2 */
#define MACON2_DEFER BIT(6)
#define MACON2_BPEN BIT(5)
#define MACON2_NOBKOFF BIT(4)
#define PMACON2_ADCFG_SHIFT (13)
#define MACON2_PADCFG_MASK (0xe000)
#define MACON2_TXCRCEN BIT(12)
#define MACON2_PHDREN BIT(11)
#define MACON2_HFRMEN BIT(9)
#define MACON2_FULDPX BIT(8)

/* MABBIPG */
#define MABBIPG_BBIPG_SHIFT (8)
#define MABBIPG_BBIPG_MASK (0x7f00)

/* MAIPG */
#define MAIPG_IPG_SHIFT (8)
#define MAIPG_IPG_MASK (0x7f00)

/* MICMD */
#define MICMD_MIISCAN BIT(9)
#define MICMD_IIRD BIT(8)

/* MIREGADR */
#define MIREGADR_PHREG_SHIFT (8)
#define MIREGADR_PHREG_MASK (0x1f00)

/* MISTAT */
#define MISTAT_NVALID BIT(10)
#define MISTAT_SCAN BIT(9)
#define MISTAT_BUSY BIT(8)

/* ECON2 */
#define ECON2_ETHEN BIT(7)
#define ECON2_STRCH BIT(6)
#define ECON2_TXMAC BIT(5)
#define ECON2_SHA1MD5 BIT(4)
#define ECON2_COCON_SHIFT (0)
#define ECON2_COCON_MASK (0x000f)
#define ECON2_AUTOFC BIT(15)
#define ECON2_TXRST BIT(14)
#define ECON2_RXRST BIT(13)
#define ECON2_ETHRST BIT(12)
#define ECON2_MODLEN_SHIFT (10)
#define ECON2_MODLEN_MASK (0x0003)
#define ECON2_AESLEN_SHIFT (8)
#define ECON2_AESLEN_MASK (0x0003)

/* ERXWM */
#define ERXWM_RXFWM_SHIFT (0)
#define ERXWM_RXFWM_MASK (0x00ff)
#define ERXWM_RXEWM_SHIFT (8)
#define ERXWM_RXEWM_MASK (0x00ff)

/* EIE */
#define EIE_INTIE BIT(7)
#define EIE_MODEXIE BIT(6)
#define EIE_HASHIE BIT(5)
#define EIE_AESIE BIT(4)
#define EIE_LINKIE BIT(3)
#define EIE_PKTIE BIT(14)
#define EIE_DMAIE BIT(13)
#define EIE_TXIE BIT(11)
#define EIE_TXABTIE BIT(10)
#define EIE_RXABTIE BIT(9)
#define EIE_PCFULIE BIT(8)

/* EIDLED */
#define EIDLED_LACFG_SHIFT 4
#define EIDLED_LACFG_MASK (0x000f)
#define EIDLED_LBCFG_SHIFT 0
#define EIDLED_LBCFG_MASK (0x000f)
#define EIDLED_DEVID_SHIFT (13)
#define EIDLED_DEVID_MASK (0x000e)
#define EIDLED_REVID_SHIFT 8
#define EIDLED_REVID_MASK 0x001f

#endif /* ENC624J600_REGISTERS_H */
