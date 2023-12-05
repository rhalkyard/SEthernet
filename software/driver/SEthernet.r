#include "Retro68.r"
#include "Types.r"

data 'DRVR' (69, locked, ".ENET0") {
    $$read("SE_driver.resource")
};

resource 'vers' (1) {
    0x00, 0x00;
    development, 0x00;
    0;
    "0.0.0";
    "0.0.0";
};
