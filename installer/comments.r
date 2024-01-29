#include "InstallerTypes.r"
#include "Types.r"
#include "identifiers.r"
#include "version.h"

resource 'icmt' (cmAppleTalkSystem6) {
	0xA9B68880,
	5183,
	9000,
	"This installation will update System 6 (version 6.0.4 and higher) to AppleTalk P"
	"hase 2 version 58.1.3. "
};

resource 'icmt' (cmAppleTalkSystem7) {
	0xA9B68880,
	5813,
	9000,
	"This installation will update System 7 to AppleTalk Phase 2 version 58.1.3."
};

#if 0
resource 'icmt' (cmEtherTalkNB) {
	0xA9B68880,
	605,
	9110,
	"This installs EtherTalk Phase 2 (version 2.5.6) and the Ethernet driver for the "
	"EtherTalk NB Card.  If you are doing a custom install, be sure to install AppleT"
	"alk version 58.1.3 as well."
};
#endif

resource 'icmt' (cmSEthernet30) {
	currentDate,
	VERSION_MAJOR * 100 + ((VERSION_MINOR & 0xf0) >> 4) * 10 + (VERSION_MINOR & 0x0f),
	9110,
	"This installs EtherTalk Phase 2 (version 2.5.6) and the Ethernet driver for the "
	"SEthernet/30 Card.  If you are doing a custom install, be sure to install AppleT"
	"alk version 58.1.3 as well."
};

resource 'icmt' (cmSEthernet) {
	currentDate,
	VERSION_MAJOR * 100 + ((VERSION_MINOR & 0xf0) >> 4) * 10 + (VERSION_MINOR & 0x0f),
	9110,
	"This installs EtherTalk Phase 2 (version 2.5.6) and the Ethernet driver for the "
	"SEthernet Card.  If you are doing a custom install, be sure to install AppleTalk"
	" version 58.1.3 as well."
};

resource 'icmt' (cmMacTCP) {
	2977967700,
	210,
	13000,
	"This installs MacTCP (version 2.1)."
};

resource 'ICON' (9000) {
	$"0000 0000 07FF FFE0 0800 0010 0800 0010 08FF FF10 0900 0090 0955 5090 0900 0090"
	$"0955 0090 0900 0090 0950 0090 0900 0090 0950 0090 0900 0090 0954 0090 0900 0090"
	$"0900 0090 08FF FF10 0800 0010 0800 0010 0800 0010 0800 0010 0800 FF10 0800 0010"
	$"0800 0010 0800 0010 0800 0010 07FF FFE0 0400 0020 0400 0020 0400 0020 07FF FFE0"
};

resource 'ICON' (9110) {
	$"0000 0000 0000 0000 0000 2200 0000 5500 0000 8880 0000 4440 0000 2220 37BF F110"
	$"0000 0088 0DE0 0044 0000 0088 037B F110 0000 2220 0000 4440 0000 8880 0044 5500"
	$"00AA 2200 0111 0000 0222 0000 0444 0000 088F FDEC 1100 0000 2200 07B0 1100 0000"
	$"088F DEC0 0444 0000 0222 0000 0111 0000 00AA 0000 0044"
};

/*
resource 'ICON' (9130) {
	$"0000 0000 0000 0000 0000 0000 1E07 F000 1238 0E00 1240 0100 1280 0000 1301 C040"
	$"120E 3120 1010 0490 1020 0240 107E 0108 1002 0020 1002 0080 1FFE 0000 0000 0000"
	$"0000 0000 0000 7FF8 0100 4008 0400 4008 1080 7E08 0240 0408 0920 0808 048C 7048"
	$"0203 80C8 0000 0148 0080 0248 0070 1C48 000F E078"
};

resource 'ICON' (9463) {
	$"FFFF FFFF 8008 0001 8014 0001 8022 0001 8041 0001 8080 8001 81E3 C001 8222 0001"
	$"8622 0001 8A22 0001 93E3 C001 A022 3001 C022 0801 A022 0801 93E3 8441 8A22 4461"
	$"8622 4451 8221 C7C9 8010 4405 8010 4403 800C 4405 8003 C7C9 8000 4451 8000 4461"
	$"8000 4441 8003 C781 8001 0101 8000 8201 8000 4401 8000 2801 8000 1001 FFFF FFFF"
};
*/

resource 'ICON' (13000) {
	$"00F8 4000 0306 6000 06FF D000 0D80 0800 0AFF D000 1541 6000 1288 C000 1105 4000"
	$"120A C000 3545 4000 5FFA 8000 800D 8360 5FF9 0490 3346 0248 10DB FF24 0040 0012"
	$"0056 E009 0050 0012 0051 BF24 0050 0248 0050 0490 0051 B360 0052 4800 0054 9000"
	$"00E9 3FF6 0092 0000 00A4 01D8 00D2 0000 00A9 3F60 BF24 9000 0052 4800 BF8D B0",
};
