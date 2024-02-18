/*
Board-level defintions for SEthernet/30.

Copyright (C) 2023-2024 Richard Halkyard

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef SETHERNET30_BOARD_DEFS_H
#define SETHERNET30_BOARD_DEFS_H

/* 
These constants would originally have been assigned to hardware developers by
Apple Developer Technical Support, but these days I guess we can just pick
numbers that we like and hope they don't collide with anything.

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
#define SETHERNET30_ROM_DRSW (SETHERNET30_DRSW)

/* Driver hardware ID. This identifier allows software to tell apart different
hardware that implements the same software interface. */
#define SETHERNET30_DRHW (1)
#define SETHERNET30_ROM_DRHW (SETHERNET30_DRHW)

#endif /* SETHERNET30_BOARD_DEFS_H */
