/* Define a function as a MacsBug symbol. Place AFTER the function to be labeled */

.macro MacsbugSymbol Name
    .byte 0x7F + _macsbugSymbol\@ - .
    .ascii "\Name"
_macsbugSymbol\@:
    .align 2
    .word 0 /* length of constants */
.endm
