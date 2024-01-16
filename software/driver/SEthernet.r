#include "Retro68.r"
#include "Types.r"
#include "version.h"

data 'DRVR' (69, locked, sysheap, ".ENET0") {
    $$read("SE_driver.resource")
};

resource 'vers' (1, purgeable) {
    VERSION_MAJOR, VERSION_MINOR;
    VERSION_DEVSTAGE, VERSION_INTERNAL_ID;
    0;
    VERSION_SHORT;
    VERSION_LONG;
};
