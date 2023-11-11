#include "Retro68.r"
#include "MacTypes.r"

data 'DRVR' (69, locked, ".ENET0") {
    $$read("DRVR_69.resource")
};

resource 'vers' (1) {
    0x00, 0x00;
    development, 0x00;
    0;
    "0.0.0";
    "0.0.0";
};
