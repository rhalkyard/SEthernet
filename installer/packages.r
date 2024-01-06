#include "InstallerTypes.r"
#include "identifiers.r"

resource 'inpk' (pkAppleTalkSystem6) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		96868,
		"",
		{
			'inaa', aaCheckSystem6,
			'infa', faDeleteADSP,
			'inra', raDeleteSystem_DITL_4030,
			'inra', raDeleteSystem_DITL_4031,
			'inra', raDeleteSystem_DITL_4032,
			'inra', raDeleteSystem_ALRT_4030,
			'inra', raDeleteSystem_ALRT_4031,
			'inra', raDeleteSystem_ALRT_4032,
			'inra', raDeleteSystem_STR__4032,
			'inra', raDeleteSystem_DRVR40_XPP,
			'infa', faAppleTalk,
			'inra', raSystem_INIT18,
			'inra', raSystem_ltlk0,
			'inra', raSystem_ltlk1,
			'inra', raSystem_ltlk2,
			'inra', raSystem_ltlk3,
			'inra', raSystem_ltlk4,
			'inra', raSystem_ltlk5,
			'inra', raSystem_atlk1,
			'inra', raSystem_atlk3,
			'inra', raSystem_iopc128,
			'inra', raSystem_iopc127,
			'inaa', aaFROV6
		}
	}
};

resource 'inpk' (pkAppleTalkSystem7) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		97486,
		"",
		{
			'inaa', aaCheckSystem7,
			'infa', faDeleteADSP,
			'infa', faDeleteADSPExtension,
			'infa', faDeleteAppleTalkExtension,
			'infa', faDeleteAppleTalk,
			'inra', raDeleteSystem_AINI20,
			'inra', raSystem_DRVR9_MPP,
			'inra', raSystem_DRVR10_ATP,
			'inra', raSystem_DRVR40_XPP,
			'inra', raSystem_DRVR126_DSP,
			'inra', raSystem_drvr9,
			'inra', raSystem_lmgr0,
			'inra', raSystem_AINI30,
			'inra', raSystem_AINI30000,
			'inra', raSystem_AINI32000,
			'inra', raSystem_ltlk0,
			'inra', raSystem_ltlk1,
			'inra', raSystem_ltlk2,
			'inra', raSystem_ltlk3,
			'inra', raSystem_ltlk4,
			'inra', raSystem_ltlk5,
			'inra', raSystem_atlk1,
			'inra', raSystem_atlk3,
			'inra', raSystem_iopc128,
			'inra', raSystem_iopc127,
			'inaa', aaFROV7,
			'inaa', aaFFMP7
		}
	}
};

resource 'inpk' (pkNetworkControl) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		dontForceRestart,
		0,
		43008,
		"",
		{
			'infa', faNetworkControl
		}
	}
};

resource 'inpk' (pkAppleTalkSystem6Custom) {
	format0 {
		showsOnCustom,
		notRemovable,
		forceRestart,
		cmAppleTalkSystem6,
		147556,
		"AppleTalk v58.1.3 for System 6",
		{
			'inpk', pkAppleTalkSystem6,
			'inpk', pkNetworkControl,
			'infa', faResponder
		}
	}
};

resource 'inpk' (pkAppleTalkSystem7Custom) {
	format0 {
		showsOnCustom,
		notRemovable,
		forceRestart,
		cmAppleTalkSystem7,
		141704,
		"AppleTalk v58.1.3 for System 7",
		{
			'inpk', pkAppleTalkSystem7,
			'inpk', pkEnabler201Patch,
			'inpk', pkNetworkControl,
			'inra', raSystem_STR__16408,
			'inra', raSystem_STR__16503,
			'inra', raSystem_STR__16504
		}
	}
};

resource 'inpk' (pkEnabler201Patch) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		69,
		"",
		{
			'inra', raEnabler201_lefT0,
			'inaa', aaSGBL7
		}
	}
};

resource 'inpk' (pkDivider) {
	format0 {
		showsOnCustom,
		notRemovable,
		dontForceRestart,
		0,
		0,
		"-",
		{
			'    ', 0
		}
	}
};

resource 'inpk' (pkENETDriver) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		2380,
		"",
		{
			'inaa', aaTestENETDRVR,
			'inra', raSystem_DRVR127_ENET
		}
	}
};

resource 'inpk' (pkEtherTalkPhase2) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		15360,
		"",
		{
			'infa', faDeleteEtherTalk,
			'infa', faDeleteEtherTalk20,
			'infa', faDeleteEtherTalk21,
			'infa', faDeleteEtherTalkExtension,
			'infa', faDeleteEtherTalk20Extension,
			'infa', faDeleteEtherTalk21Extension,
			'infa', faEtherTalkPhase2Extension
		}
	}
};

#if 0
/* EtherTalk NB driver package */
resource 'inpk' (pkEtherTalkNB) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		4420,
		"",
		{
			'inaa', aaTestEnetNB,
			'inra', raSystem_enet8
		}
	}
};
#endif

resource 'inpk' (pkENETDriverUpdate) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		0,
		"",
		{
			'inaa', aaUPDE0
		}
	}
};

#if 0
/* EtherTalk NB Custom Install entry */
resource 'inpk' (pkEtherTalkNBCustom) {
	format0 {
		showsOnCustom,
		removable,
		forceRestart,
		cmEtherTalkNB,
		65168,
		"EtherTalk for EtherTalk NB Card",
		{
			'inpk', pkEtherTalkNB,
			'inpk', pkEtherTalkPhase2,
			'inpk', pkNetworkControl,
			'inpk', pkENETDriver
		}
	}
};
#endif

/* Package selectable for Custom Install - installs both EtherTalk bits and driver */
resource 'inpk' (pkSEthernet30Custom) {
	format0 {
		showsOnCustom,
		removable,
		forceRestart,
		cmSEthernet30,
		0,
		"EtherTalk for SEthernet/30 Card",
		{
			'inpk', pkSEthernet30,
			'inpk', pkEtherTalkPhase2,
			'inpk', pkNetworkControl,
			'inpk', pkENETDriver
		}
	}
};

/* Package selectable for Easy Install - driver only */
resource 'inpk' (pkSEthernet30) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		0,
		"",
		{
			'infa', faSEthernet30,
			'infa', faDeleteOldSEthernet30
		}
	}
};
