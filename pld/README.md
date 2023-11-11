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

Yeah, unfortunately it's Windows-only :(. The equations could be ported to
[galASM](https://github.com/daveho/GALasm) or
[Galette](https://github.com/simon-frankau/galette), but the one redeeming
feature of CUPL is that its `[bitfield]:value` syntax is a LOT nicer than having
loads of `!A23 & A22 & A21 & !A20` etc. etc. in the equations.
