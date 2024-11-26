# Programmable Logic Device Sources

The sources in this dirctory are in CUPL format, and can be built using the
Windows-based
[WinCUPL](https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources)
software. Unfortunately, using WinCUPL is a retrocomputing exercise in its own
right - the GUI does not work on anything newer than Windows XP.

However, it is possible to run WinCUPL under Wine, and the CMake monstrosity in
this directory uses Wine and WinCUPL to build CUPL sources without having to
mess with Windows XP. It looks for WinCUPL in `~/.wine/drive_c/Wincupl`, which
is the default installation path. If your Wine data is in a different place, or
you installed WinCUPL elsewhere, the `WINCUPL_PATH` cache variable will need to
be set to point to the correct location. If Wine and/or Wincupl are not
available, then the PLD build target is skipped.

The typical WinCUPL workflow is to then use the ATMISP software to either drive
an Atmel/Microchip programmer directly, or generate an SVF file that can be used
by a generic JTAG programmer. This workflow, frankly, stinks, and we instead use
the `fuseconv` utility from [prjbureau](https://github.com/whitequark/prjbureau)
to generate an SVF. Setup of prjbureau is automatic, but Python 3 and the
`virtualenv` module are required.
