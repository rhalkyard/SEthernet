/* Some of my own macros to augment the Apple ones provided in ROMDefs.inc */

/* Terminator for sResource lists */
.macro EndLstEntry
    DatLstEntry 0xff, 0 
.endm

/* sRsrcType data */
.macro RsrcType category, type, swInterface, hwDevice
    .word \category
    .word \type
    .word \swInterface
    .word \hwDevice
.endm

/* Generate a valid ByteLanes byte given a 4-bit bitfield indicating the lanes
in use */
.macro ByteLanes lanes
    .byte (\lanes & 0xf) + ((~\lanes & 0xf) << 4)
.endm
