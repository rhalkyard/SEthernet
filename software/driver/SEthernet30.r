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
