#include "Retro68.r"
#include "MacTypes.r"

data 'enet' (9635, locked, sysheap, "SEthernet/30") {
    $$read("enet_9635.resource")
};

resource 'vers' (1) {
    0x00, 0x00;
    development, 0x00;
    0;
    "0.0.0";
    "0.0.0";
};

type 'Enet' as 'STR ';
resource 'Enet' (0, purgeable) { "" };
