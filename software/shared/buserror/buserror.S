.global buserror_probe

busErrVector = 0x00000008       /* 68000 vector table entry for Bus Error */

.text
/*
Probe a given address for validity by temporarily hijacking the Bus Error
vector and then trying to read from the address.

int probeAddress(void * addr);

Returns the byte at addr if successful, or a negative value if reading from addr
caused a Bus Error.

On entry:
    Stack: address to probe

On exit:
    A0: destroyed
    D0: <0 if we took a Bus Error while reading from the address
        >=0 (the byte at the given address) if reading was successful
*/
buserror_probe:
    LINK    %a6, #-6
	MOVE.W  %sr,-6(%a6) /* Save processor state */
    ORI.W   #0x700, %sr /* Disable interrupts while we're messing with system 
                           vectors */

    MOVE.L  busErrVector, -4(%a6)   /* Save old Bus Error vector */
    LEA     busErrReturn(%pc), %a0
    MOVE.L  %a0, busErrVector       /* Jump to BusErrReturn on Bus Error */

    MOVEQ   #-1,%d0     /* Initialize D0.L to -1 */
    MOVE.L  8(%a6), %a0 /* Get address argument */
    MOVE.B  (%a0), %d0  /* Try reading a byte from the address */ 

    /* If the address in A0 is not valid, the MOVE.B above will cause a Bus
    Error and jump directly to busErrReturn, skipping the AND below */

    AND.L   #0xff, %d0  /* If we get here, we didn't take a Bus Error. Mask off
                           everything but the byte we read, so we return a
                           positive value */

busErrReturn:
    MOVE.L  -4(%a6), busErrVector   /* Restore original bus error vector */
    MOVE.W  -6(%a6), %sr            /* Restore processor state */
    UNLK    %a6 /* If we took a Bus Error, there will be an exception frame
                   left on the stack, but this will conveniently get rid of it
                   for us */
    RTS
