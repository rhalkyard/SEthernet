# Programmable Logic Device Sources

The sources in this dirctory are in CUPL format, and can be built using the
Windows-based
[WinCUPL](https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources)
software. Unfortunately, using WinCUPL is a retrocomputing exercise in its own
right - the GUI does not work on anything newer than Windows XP.

However, it provides a (rather cryptic) command-line CUPL compiler that works
fine on modern Windows. The `clean.bat` and `build.bat` scripts in each
directory contain the right incantations to compile the equations to a JEDEC
`.JED` file that most programming software understands.

The `.JED` file must then be opened in the ATMISP software (also found at the
link above), and the programming chain set up as follows:

1. File->New
2. When prompted for the number of devices, enter '1'
3. Select 'ATF1502AS' for Device Name, 'Program/Verify' for JTAG Instruction,
   and the `.JED` file built by CUPL as JEDEC File

If you have a Microchip/Atmel ATDH1150-series programming cable, ATMISP can be
used directly to program the CPLDs. Otherwise, check the 'Write SVF File' box
(and specify an output file) to generate programming data in `.SVF` format that
can be replayed on a generic JTAG adapter, using, e.g. OpenOCD.

Note that ATMISP appears to read the programming data in at step 3 and does not
re-read it! If you have built a new `.JED` file, you must create a new
programming chain and repeat the steps above for your changes to be reflected in
the `.SVF` output!!!


## Room for improvement

This whole awkward workflow could be replaced by
[Yosys](https://github.com/YosysHQ/yosys) and
[prjbureau](https://github.com/whitequark/prjbureau), and the logic rewritten in
a more modern language such as Verilog or Amaranth. The fitter (`fit1502.exe`)
and associated files from ProChip Designer would still be required, however.

Alternatively, the `util.fuseconv` tool from `prjbureau` could be used on its
own to convert `.JED` to `.SVF` without having to deal with ATMISP.
