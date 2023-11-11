# PLD Equations for 68000 PDS Interface

U3 and U4 on the SEthernet/30 board are ATF16V8/GAL16V8 programmable logic devices that
provides address decoding and glue logic.

The 68030 bus in the SE/30 requires a bit more glue logic than the SE, so
functions are spread out over two chips. U3 handles address decoding and driving
of the interrupt lines, while U4 handles bus control signals.

## Address Decoding

The SEthernet/30 board uses a Nubus 'pseudo-slot' design, occupying an address
corresponding to a NuBus slot, and appearing to the Slot Manager just like a
NuBus card would on a workstation Mac. To allow for multiple expansion cards,
jumpers JP1 and JP2 can be used to configure the card to act as though it is
installed in slots 9, A, B, or E.

Each slot has an interrupt line dedicated to it on the PDS connector, U3 routes
the ENC624J600's interrupt to the appropriate line based on the selection made
on JP1 and JP2.

Within the card's address space, minimal decoding is performed on address line
A16, so that the card's declaration ROM shows up at the top of the address space
(as expected by the Slot Manager), with the ENC624J600's address space
immediately below it.

## Bus Control

While the ENC624J600 in PSP Mode 4 maps neatly onto the 68000's control lines,
glue logic is required to interface with the 68030. Page 7-26 of the [M68030
User's Manual](https://www.nxp.com/docs/en/reference-manual/MC68030UM-P1.pdf)
describes logic to interface the 68030 to peripherals using 68000-style
byte-select lines, a 16-bit subset of which is implemented in U4.

Additionally, U4 generates the `/DSACKx` signals used as part of the 68030's
dynamic bus sizing scheme, and turns the CPU's `R/W` signal and the ROM
chip-select from U3, into separate read-enable and write-enable signals for the
onboard flash ROM.
