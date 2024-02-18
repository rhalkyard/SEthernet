/*
Board-level defintions for SEthernet.

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

#ifndef SETHERNET_BOARD_DEFS_H
#define SETHERNET_BOARD_DEFS_H

/* These values must be kept in sync with the glue logic in pld/se/se-u2.pld */

/* Base address of SEthernet board. Anything between 0x600000 and 0x8fffff is
fair game, the example board in Designing Cards And Devices uses 0x800000, so we
might as well follow its example. */
#define SETHERNET_BASEADDR (0x800000)

/* Interrupt priority level used by SEthernet board. Level 1 is shared with the
VIA. */
#define SETHERNET_INTERRUPT (1)

#endif /* SETHERNET_BOARD_DEFS_H */
