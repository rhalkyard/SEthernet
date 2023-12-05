#include "Retro68.r"
#include "Types.r"

/* 'enet' resource ID must match board ID in declaration ROM */
data 'enet' (9635, locked, sysheap, "SEthernet/30") {
    $$read("SE30_driver.resource")
};

resource 'vers' (1) {
    0x00, 0x00;
    development, 0x00;
    0;
    "0.0.0";
    "0.0.0";
};

resource 'FREF' (128) {
    'comd',
    0,
    ""
};

resource 'BNDL' (128) {
    'sEth',
    0,
    {
        'FREF', {0, 128},
        'ICN#', {0, 128}
    }
};

type 'sEth' as 'STR ';
resource 'sEth' (0, purgeable) { "SEthernet/30 Driver" };
