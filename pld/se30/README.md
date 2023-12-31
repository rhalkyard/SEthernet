# PLD Equations for 68000 PDS Interface

U3 and U4 on the SEthernet/30 board are ATF16V8/GAL16V8 programmable logic
devices that provides address decoding and glue logic.

The 68030 bus in the SE/30 requires a bit more glue logic than the SE, so
functions are spread out over two chips (three, counting the Bodge). U3 handles
address decoding and driving of the interrupt lines, while U4 handles bus
control signals. After the Revision 0 boards were finalised, a timing bug was
found that could not be addressed using the available gates in U3 and U4. To
address this, a third GAL16V8 ("The Bodge") adds a wait-state generator.

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

Additionally, U4 generates the `/DSACKx` signals used as part of the 68030's
dynamic bus sizing scheme, and turns the CPU's `R/W` signal and the ROM
chip-select from U3, into separate read-enable and write-enable signals for the
onboard flash ROM.

## The Bodge

Due to an oversight in timing analysis, the Bus Control logic does not generate
wait states. Pin 4 of the Bus Control IC, U4, has been repurposed as a Wait
State input, fed by a third GAL acting as a simple counter clocked by the CPU
clock.
