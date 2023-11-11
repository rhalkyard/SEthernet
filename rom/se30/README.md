# Declaration ROM

To make use of the Slot Manager for hardware probing, interrupts, etc. we need
to do two things:

- Map our device into a memory region corresponding to a NuBus slot (on the
  SE/30, valid 'pseudoslots' are `9`, `A`, or `B`).

- Have a declaration ROM header at the very end of the slot's address space,
  pointing to a valid sResource directory.

This directory contains a suitable declaration ROM laid out in GNU Assembler
format, with a Python script to perform some basic validity checks and
post-processing.

## Files

`declrom.s`: Source for declaration ROM.

`ROMDefs.inc`: Assorted constants and macros for declaration ROMs, converted to
GNU Assembler format from Universal Interfaces file `AIncludes/ROMDefs.a`.

`declrom_macros.inc`: Additional macros for declaration ROMs.

`gencrc.py`: Quick 'n dirty Python script to sanity-check a declaration ROM
header, calculate and write the CRC field, and pad it to a suitable length to
program into an EPROM.
