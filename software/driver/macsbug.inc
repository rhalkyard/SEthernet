/* 
Define a MacsBug symbol. Place immediately after the function to be labeled, but 
before any constant data accompanying the function.

Arguments:
    Name:           Symbol name that will appear in MacsBug (1-255 chars). Does
                    not necessarily have to match the label (although it
                    probably should.)
    ConstantLength: Number of bytes of constant data to follow. (optional)

Example:
    SomeFunction:
        ...
        RTS
        MacsbugSymbol SomeFunction, 0

    FunctionWithConstants:
        ...
        RTS
        MacsbugSymbol FunctionWithConstants, 3
    FunctionWithConstants_constant1:
        .word 420
    FunctionWithConstants_constant2:
        .byte 69
        .align 2

    AnotherFunction:
        ...
        RTS
        MacsbugSymbol AnotherFunction

See Macsbug Reference and Debugging Guide, Appendix D for more details.
*/

.macro MacsbugSymbol Name, ConstantLength=0
    .byte 0x80 /* 'long' variable-length name (1-255 chars) follows */
    .byte _macsbugSymbol\@ - (. + 1) /* Length of name */
    .ascii "\Name"
_macsbugSymbol\@:
    .align 2
    .word \ConstantLength
.endm

.macro _Debugger
    .word 0xa9ff
.endm

.macro _DebugStr
    .word 0xabff
.endm
