#include "Retro68.r"
#include "Types.r"

/* 'enet' resource ID must match board ID in declaration ROM */
data 'enet' (9635, locked, sysheap, "SEthernet/30") {
    $$read("SE30_driver.resource")
};

resource 'vers' (1, purgeable) {
    0x00, 0x00;
    development, 0x00;
    0;
    "0.0.0";
    "0.0.0";
};
