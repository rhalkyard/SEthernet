/*
SEthernet and SEthernet/30 Driver

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

#include "Retro68.r"
#include "Types.r"
#include "sethernet30_board_defs.h"
#include "version.h"

data 'enet' (SETHERNET30_BOARDID, locked, sysheap, "SEthernet/30") {
    $$read("SE30_driver.resource")
};

resource 'vers' (1, purgeable) {
    VERSION_MAJOR, VERSION_MINOR;
    VERSION_DEVSTAGE, VERSION_INTERNAL_ID;
    0;
    VERSION_SHORT;
    VERSION_LONG;
};
