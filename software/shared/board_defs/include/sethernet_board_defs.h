/*
Board-level defintions for SEthernet.

These values must be kept in sync with the glue logic in pld/se/se-u2.pld!
*/

/*
Base address of SEthernet board. Anything between 0x600000 and 0x8fffff is fair
game, the example board in Designing Cards And Devices uses 0x800000, so we
might as well follow its example.
*/
#define SETHERNET_BASEADDR (0x800000)

/*
Interrupt priority level used by SEthernet board. Level 1 is shared with the
VIA.
*/
#define SETHERNET_INTERRUPT (1)
