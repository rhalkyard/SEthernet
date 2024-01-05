#include "InstallerTypes.r"
#include "identifiers.r"

resource 'infs' (fsNetworkResources) {
	'rsrc',
	'RSED',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Network Resources"
};

resource 'infs' (fsTgtSystem) {
	'zsys',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrNeedNotMatch,
	"special-macs:System"
};

resource 'infs' (fsTgtEnabler201) {
	'gbly',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:System Enabler 201"
};

resource 'infs' (fsAppleTalk) {
	'ZSYS',
	'MACS',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:AppleTalk"
};

resource 'infs' (fsResponder) {
	'INIT',
	'wma.',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Responder"
};

resource 'infs' (fsTgtAppleTalk) {
	'ZSYS',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:AppleTalk"
};

resource 'infs' (fsTgtResponder) {
	'INIT',
	'wma.',
	0x0,
	noSearchForFile,
	TypeCrNeedNotMatch,
	"special-macs:Responder"
};

resource 'infs' (fsTgtADSP) {
	'INIT',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:ADSP"
};

resource 'infs' (fsTgtADSPExtension) {
	'INIT',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:ADSP"
};

resource 'infs' (fsTgtAppleTalkExtension) {
	'ZSYS',
	'MACS',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:AppleTalk"
};

resource 'infs' (fsNetwork) {
	'cdev',
	'atdv',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:Network"
};

resource 'infs' (fsTgtNetworkControl) {
	'cdev',
	'atdv',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-ctrl:Network"
};

resource 'infs' (fsEtherTalkPhase2) {
	'adev',
	'et20',
	0xA9B73140,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:AppleTalk Files:EtherTalk Phase 2"
};

resource 'infs' (fsTgtEtherTalkPhase2Extension) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk Phase 2"
};

resource 'infs' (fsTgtEtherTalk) {
	'adev',
	'etlk',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk"
};

resource 'infs' (fsTgtEtherTalk20) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk2.0"
};

resource 'infs' (fsTgtEtherTalk21) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-macs:EtherTalk2.1"
};

resource 'infs' (fsTgtEtherTalkExtension) {
	'adev',
	'etlk',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk"
};

resource 'infs' (fsTgtEtherTalk20Extension) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk2.0"
};

resource 'infs' (fsTgtEtherTalk21Extension) {
	'adev',
	'et20',
	0x0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:EtherTalk2.1"
};

#if 0
resource 'infs' (fsSEthernetResources) {
	'rsrc',
	'RSED',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:SEthernet Files:SEthernet Resources"
};
#endif

resource 'infs' (fsSEthernet30) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"SEthernet Installer:SEthernet Files:SEthernet/30"
};

resource 'infs' (fsTgtSEthernet30) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:SEthernet/30"
};

resource 'infs' (fsTgtSEthernet30Old) {
	'comd',
	'Enet',
	0,
	noSearchForFile,
	TypeCrMustMatch,
	"special-extn:SEthernet30"
};
