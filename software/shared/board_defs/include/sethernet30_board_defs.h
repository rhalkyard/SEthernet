/* 
Slot Manager board identifier constants for SEthernet/30.

These would originally have been assigned to hardware developers by Apple
Developer Technical Support, but these days I guess we can just pick numbers
that we like and hope they don't collide with anything.

The license plate on my first car (rust in peace, 1976 Triumph 2500TC, you
served me well) was ID9635, so I've chosen an ID of decimal 9635 :)

This file is also used to populate the definitions in the declaration ROM, any
changes here will require new builds of both ROM and software.
*/

/* Board identifier */
#define SETHERNET30_BOARDID (9635) 

/* Driver software interface ID. All hardware that
implements the same software interface should use this identifier. */
#define SETHERNET30_DRSW (9635)

/* Driver hardware ID. This identifier allows software to tell apart different
hardware that implements the same software interface. */
#define SETHERNET30_DRHW (1)
