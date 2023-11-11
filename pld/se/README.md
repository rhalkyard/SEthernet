# PLD Equations for 68000 PDS Interface

U2 on the SEthernet board is an ATF16V8/GAL16V8 programmable logic device that
provides address decoding and miscellaneous glue logic.

Address decoding is straightforward - when `/AS` is asserted and address lines
`A24..A16` indicate an address in the range `0x60 0000`-`0x60 FFFF`, we assert
the ENC624J600's chip-select pin.

Glue logic is also minimal - the `B0SEL` and `B1SEL` byte-select lines on the
ENC624J600 are just active-high equivalents to the active-low `/UDS` and `/LDS`
lines on the 68000 bus. The BBU chip on the SE logic board automatically asserts
`/DTACK` for us on a schedule that we can live with, so there is no need to
generate it ourselves (if we needed additional wait states, we could assert
`/EXT.DTK` to suppress the BBU's `/DTACK` signal until we were ready).

Finally, the push-pull interrupt output of the ENC624J600 is buffered and turned
into an open-drain output, allowing it to interface with the wired-OR interrupt
logic of the SE.
