# PLD Equations for 68030 PDS Interface

U3 on the SEthernet/30 board is an ATF1502 Complex Programmable Logic
Devices that provides address decoding and glue logic.

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

Note that the Slot E configuration is not compatible with the SE/30 or IIsi.
This option exists to allow the card to be used in the PDS slot of a Macintosh
IIfx. This configuration has been tested and works, but the IIfx case does not
provide a place to mount the breakout board.

## Bus Control

While the ENC624J600 in PSP Mode 4 maps neatly onto the 68000's control lines,
glue logic is required to interface with the 68030. Page 7-26 of the [M68030
User's Manual](https://www.nxp.com/docs/en/reference-manual/MC68030UM-P1.pdf)
describes logic to interface the 68030 to peripherals using 68000-style
byte-select lines, a 16-bit subset of which is implemented in U4.

Additionally, U4 generates the `/DSACKx` signals for the 68030 bus handshaking
scheme. To accommodate the timing characteristics of the ENC624J600 (75 ns from
selection to data valid on read), a counter is used to delay assertion of
`/DSACKx` for 1 or 2 clock cycles after the chip is selected.
