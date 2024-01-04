#include "InstallerTypes.r"

resource 'infs' (9000) {
	'rsrc',
	'RSED',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Network Resources"
};

resource 'infs' (9001) {
	'zsys',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrNeedNotMatch,
	"special-macs:System"
};

resource 'infs' (9010) {
	'gbly',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:System Enabler 201"
};

resource 'infs' (9008) {
	'ZSYS',
	'MACS',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:AppleTalk"
};

resource 'infs' (9009) {
	'INIT',
	'wma.',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Responder"
};

resource 'infs' (9002) {
	'ZSYS',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:AppleTalk"
};

resource 'infs' (9003) {
	'INIT',
	'wma.',
	0x0,
	noSearchForFile,
	TypeCrNeedNotMatch,
	"special-macs:Responder"
};

resource 'infs' (9004) {
	'INIT',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:ADSP"
};

resource 'infs' (9005) {
	'INIT',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:ADSP"
};

resource 'infs' (9006) {
	'ZSYS',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:AppleTalk"
};

resource 'infs' (9101) {
	'cdev',
	'atdv',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Network"
};

resource 'infs' (9102) {
	'cdev',
	'atdv',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-ctrl:Network"
};

resource 'infs' (9113) {
	'adev',
	'et20',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:EtherTalk Phase 2"
};

resource 'infs' (9114) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk Phase 2"
};

resource 'infs' (9115) {
	'adev',
	'etlk',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk"
};

resource 'infs' (9116) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk2.0"
};

resource 'infs' (9117) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk2.1"
};

resource 'infs' (9118) {
	'adev',
	'etlk',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk"
};

resource 'infs' (9119) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk2.0"
};

resource 'infs' (9120) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk2.1"
};

#if 0
resource 'infs' (13000) {
	'rsrc',
	'RSED',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:SEthernet Files:SEthernet Resources"
};
#endif

resource 'infs' (13002) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:SEthernet Files:SEthernet/30"
};

resource 'infs' (13003) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:SEthernet/30"
};

resource 'infs' (13004) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:SEthernet30"
};
