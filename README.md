# SEthernet and SEthernet/30

Modern, low-cost 10/100 Ethernet for the Macintosh SE and SE/30.

## Introduction

It's an unfortunate reality of retrocomputing that, as time goes on, original
hardware only ever becomes more scarce, and usually more expensive.

While PDS ethernet cards are certainly not _scarce_ yet, the collector appeal of
Compact Macs means that cards are in high demand, with consequent high prices.
As of this writing (October 2023), the going eBay rate for them seems to be of
the order of $US 150-200, which is a bit steep for those of us who remember
finding them in electronics-recycler dollar bins.

While other projects have aimed to clone these original cards, such an approach
comes with a downside - the ethernet controller chips used in them have been out
of production for many years, and the controllers and (even more so) their
supporting components, are difficult to find.

While cloned cards trade off parts sourcing difficutly (and cost) for the
significant advantage of being able to use existing drivers, this project takes
the opposite approach: design an all-new card using a modern, readily-available
ethernet controller, and write a new driver for it. How hard can it be?
[^howhard]

## Hardware Overview

Both the SEthernet and SEthernet/30 use the Microchip
[ENC624J600](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/DataSheets/39935c.pdf)
all-in-one embedded ethernet controller. It's cheap, readily available, has a
straightforward software interface without too many glaring misfeatures (I'm
looking at you, RTL8019AS), and amongst its multitude of configurable host-bus
modes, it has one that matches the 68k processor bus nicely.

Since the Macintosh SE lacks any real infrastructure for expansion beyond
"here's a connector with the CPU bus on it," the SEthernet board is a very dumb
device. It simply maps the ENC624J600 into a vacant chunk of memory at `0x80
0000`-`0x80 ffff` and connects it to an interrupt line. Hardware detection,
interrupt vector interception, and device configuration are all left to the
driver to implement.

The Macintosh SE/30 is a more civilised machine, and the SEthernet/30 provides a
[declaration ROM](rom/se30) and multiple addressing options (configurable by
jumper) to take full advantage of the Slot Manager and coexist with multiple PDS
cards. Potentially, the driver could even be built into the declaration ROM,
allowing for a truly plug-and-play solution. To facilitate driver updates, the
declaration ROM is a flash chip, with logic to allow for in-system programming.

## Current project status

### Hardware

Hardware Revision 1 is largely 'done', and corrects the numerous issues of my
initial "Revision 0" boards. A few mechanical tweaks remain to get mounting
holes in exactly the right spot, and relocate connectors for easier access.

### Software

The core driver is functional and stable enough for everyday use. Real-world
performance is marginally better than a comparable vintage card, but there is
likely room to improve - especially in the rather convoluted receive routine.

Support for promiscuous mode, and the `ERead` call are not yet implemented.

The installer has some rough edges (no hardware detection or driver version
detection on the SE), but functions as a way to get drivers onto a system.

The SE/30 board's Declaration ROM must be programmed before the card can be
recognized. This can be done in-system using the
[programROM](software/tools/programROM/) application provided on the installer
disk, but right now this is a very ugly and user-unfriendly console application,
and really should be turned into a proper GUI app.

Testing has been done on my unmodified SE and SE/30 under Systems 6.0.8, 7.1,
and 7.5.5.

A driver for A/UX 2 and 3 can be found at
https://github.com/rhalkyard/SEthernet-AUX. 

## Project files

Schematics: [SEthernet](boards/se/se.pdf) -
[SEthernet/30](boards/se30/se30.pdf) - [Breakout Board](boards/breakout/breakout.pdf)

Glue Logic: [SEthernet](pld/se) - [SEthernet/30](pld/se30)

[SEthernet30 Declaration ROM](rom/se30)

[Driver](software/driver)

## Required tools

### Schematics, board layout and BOM

[KiCad 7](https://www.kicad.org/)

### Programmable Logic

[WinCUPL and ATMISP](https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources)
(see [`pld/README.md`](pld/README.md) for notes on WinCUPL)

### Declaration ROM, driver and software

- [Retro68](https://github.com/autc04/Retro68) built with [Apple Universal
  Interfaces](https://github.com/autc04/Retro68#apple-universal-interfaces-vs-multiversal-interfaces)
  (at the time of writing, the default free-software Multiversal Interfaces do
  not include some necessary headers)

- [CMake](https://cmake.org/)

- [Python 3](https://www.python.org)

### Installer

- [hfsutils](https://www.mars.org/home/rob/proj/hfs/)

- [Python 3](https://www.python.org)

- [Mini vMac](https://www.gryphel.com/c/minivmac/index.html)

## License

The hardware components of this project ([board designs](boards/) and
[programmable logic](pld/)) are licensed under the [Strongly-Reciprocal CERN
Open Hardware License, version 2](CERN-OHL-S-2.0).

The [software components](software/) of this project are licensed under the [GNU
General Public License v3.0](COPYING).

While my choice to make this project open-source is very much a deliberate one,
I have a few further requests, on the basis of "I can't and won't enforce these,
but I'd appreciate if you respected them." It's unfortunate that I have to
mention this, but given how a few recent projects in the retro-hardware
community have splintered, I feel that it's necessary to say:

- Please don't sell cards commercially/for profit without checking with me
  first. I have plans for a sales and manufacturing partnership that will sell
  boards affordably, with full support. I don't mind if you order a batch of
  boards for yourself and sell the extras on a break-even basis, but please make
  it clear that these are not 'official' SEthernet products.

- Please contribute back, rather than simply forking the project. I strongly
  encourage people to modify the design, adapt it to other systems, integrate it
  into other devices. But unless what you're working on is a radical departure
  from the basic SEthernet design, I'd much rather see a unified, collaborative
  effort that is supported by a single software stack, rather than having it be
  fragmented.

If you have any questions, feel free to reach out to me, I don't bite!

## Useful reference material

- [ENC624J600 datasheet](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/DataSheets/39935c.pdf)

- [Designing Cards and Drivers for the Macintosh Family (3rd
  Edition)](https://www.vintageapple.org/inside_o/pdf/Designing_Cards_and_Drivers_for_the_Macintosh_Family_3rd_Edition_1992.pdf)

- [Inside Macintosh (1994): Networking](https://www.vintageapple.org/inside_r/pdf/Networking_1994.pdf)

- [Inside Macintosh (1994): Devices](https://www.vintageapple.org/inside_r/pdf/Devices_1994.pdf)

- [Glenn Anderson's ethernet driver page](https://www.mactcp.net/ethernet.html) -
  contains C source for a DP8390-based card.

- [Mac Driver Museum: Network
  Drivers](https://vintageapple.org/macdrivers/network.shtml) - good material
  for reverse-engineering. In particular, the Dayna ethernet drivers contain
  debug symbols, which are quite handy for our purposes.

- [Rob Braun's declaration ROM page](http://www.synack.net/~bbraun/declrom.html)
  has useful information about declaration ROMs and how they work.

[^howhard]: [Arrested Development narrator voice]: It was, in fact, quite hard
