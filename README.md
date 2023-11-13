# SEthernet and SEthernet/30

Modern, low-cost 10/100 Ethernet for the Macintosh SE and SE/30

## Introduction

It's an unfortunate reality of retrocomputing that, as time goes on, original
hardware only ever becomes more scarce, and usually more expensive.

While PDS ethernet cards are certainly not _scarce_ yet, the collector appeal of
Compact Macs means that cards are in high demand, with consequent high prices.
As of this writing (October 2023), the going eBay rate for them seems to be of
the order of $US 150-200, which is a bit steep for those of us who remember
finding them in electronics-recycler dollar bins.

While other projects have aimed to clone these cards, such an approach comes
with a downside - the ethernet controller chips used in them have been out of
production for many years, and both the controllers and ethernet magnetics
appropriate for them, are difficult to find.

While cloned cards trade off parts sourcing difficutly (and cost) for the
significant advantage of being able to use existing drivers, this project takes
the opposite approach: design an all-new card using a modern, readily-available
ethernet controller, and write a new driver for it. How hard can it be?

## Current project status

Very early days yet!

Rev0 boards have been ordered for the SE and SE/30, and the driver and glue
logic are theoretically complete.

The plan is, once the boards arrive, to bring up the SE board first, given that
its glue logic is simpler. Once that's functional, I'll move on to the SE/30.

A subsequent revision will likely eliminate the awful through-hole PLCC sockets
for directly-soldered chips. This should make for much better routing and
potentially free up board real estate for a PDS pass through slot in the SE/30
card.

## Project files:

Schematics: [SEthernet](boards/se/se.pdf) -
[SEthernet/30](boards/se30/se30.pdf) - [Breakout Board](boards/breakout/breakout.pdf)

Glue Logic: [SEthernet](pld/se) - [SEthernet/30](pld/se30)

[SEthernet30 Declaration ROM](rom/se30)

[Driver](software/driver)
