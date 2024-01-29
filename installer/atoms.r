#include "InstallerTypes.r"
#include "identifiers.r"

resource 'infa' (faAppleTalk) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtAppleTalk,
		fsAppleTalk,
		0,
		""
	}
};

resource 'infa' (faResponder) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtResponder,
		fsResponder,
		7680,
		"Responder"
	}
};

resource 'infa' (faDeleteADSP) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtADSP,
		0,
		0,
		""
	}
};

resource 'infa' (faDeleteADSPExtension) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtADSPExtension,
		0,
		0,
		""
	}
};

resource 'infa' (faDeleteAppleTalkExtension) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtAppleTalkExtension,
		0,
		0,
		""
	}
};

resource 'infa' (faDeleteAppleTalk) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtAppleTalk,
		0,
		0,
		""
	}
};

resource 'infa' (faNetworkControl) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtNetworkControl,
		fsNetwork,
		43008,
		""
	}
};

resource 'infa' (faEtherTalkPhase2Extension) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalkPhase2Extension,
		fsEtherTalkPhase2,
		15360,
		""
	}
};

resource 'infa' (faDeleteEtherTalk) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalk,
		0,
		0,
		""
	}
};

resource 'infa' (faDeleteEtherTalk20) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalk20,
		0,
		0,
		"EtherTalk2.0 File"
	}
};

resource 'infa' (faDeleteEtherTalk21) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalk21,
		0,
		0,
		"EtherTalk2.1 File"
	}
};

resource 'infa' (faDeleteEtherTalkExtension) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalkExtension,
		0,
		0,
		""
	}
};

resource 'infa' (faDeleteEtherTalk20Extension) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalk20Extension,
		0,
		0,
		"EtherTalk2.0 File"
	}
};

resource 'infa' (faDeleteEtherTalk21Extension) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtEtherTalk21Extension,
		0,
		0,
		"EtherTalk2.1 File"
	}
};

resource 'inaa' (aaCheckSystem6) {
	format0 {
		actBefore,
		actOnRemove,
		actOnInstall,
		'SYST',
		6,
		0x58130000,
		"Preparing to install…"
	}
};

resource 'inaa' (aaCheckSystem7) {
	format0 {
		actBefore,
		dontActOnRemove,
		actOnInstall,
		'SYST',
		7,
		0x3A130009,
		"Preparing to install…"
	}
};

resource 'inaa' (aaFROV6) {
	format0 {
		actAfter,
		dontActOnRemove,
		actOnInstall,
		'FROV',
		6,
		0,
		"Finishing installation…"
	}
};

resource 'inaa' (aaFROV7) {
	format0 {
		actAfter,
		dontActOnRemove,
		actOnInstall,
		'FROV',
		7,
		0,
		"Finishing installation…"
	}
};

resource 'inaa' (aaFFMP7) {
	format0 {
		actAfter,
		dontActOnRemove,
		actOnInstall,
		'FFMP',
		7,
		0,
		"Finishing installation…"
	}
};

resource 'inaa' (aaSGBL7) {
	format0 {
		actAfter,
		dontActOnRemove,
		actOnInstall,
		'SGBL',
		7,
		0,
		"Finishing installation…"
	}
};

resource 'inaa' (aaTestENETDRVR) {
	format0 {
		actBefore,
		dontActOnRemove,
		actOnInstall,
		'TSTD',
		0,
		0x7F20007F,
		"Preparing to install…"
	}
};

#if 0
/* EtherTalk NB driver - check for existing 'enet' resource */
resource 'inaa' (aaTestEnetNB) {
	format0 {
		actBefore,
		dontActOnRemove,
		actOnInstall,
		'TSTE',
		0,
		0x06050008,
		"Preparing to install…"
	}
};
#endif

resource 'inaa' (aaUPDE0) {
	format0 {
		actBefore,
		dontActOnRemove,
		actOnInstall,
		'UPDE',
		0,
		0,
		"Checking configuration"
	}
};

resource 'inra' (raSystem_INIT18) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'INIT',
		18,
		18,
		416,
		"",
		""
	}
};

resource 'inra' (raSystem_iopc128) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'iopc',
		128,
		128,
		3138,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk2) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		2,
		2,
		5112,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk3) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		3,
		3,
		3000,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk4) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		4,
		4,
		5300,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk5) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		5,
		5,
		5300,
		"",
		""
	}
};

resource 'inra' (raSystem_atlk3) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'atlk',
		3,
		3,
		888,
		"",
		""
	}
};

resource 'inra' (raSystem_iopc127) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'iopc',
		127,
		127,
		3138,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk0) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		0,
		0,
		5236,
		"",
		""
	}
};

resource 'inra' (raSystem_ltlk1) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'ltlk',
		1,
		1,
		3016,
		"",
		""
	}
};

resource 'inra' (raSystem_atlk1) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'atlk',
		1,
		1,
		884,
		"",
		""
	}
};

resource 'inra' (raSystem_DRVR9_MPP) {
	format0 {
		dontDeleteWhenRemoving,
		dontDeleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameMustMatch,
		fsTgtSystem,
		fsAppleTalk,
		'DRVR',
		9,
		9,
		5209,
		"",
		".MPP"
	}
};

resource 'inra' (raSystem_DRVR10_ATP) {
	format0 {
		dontDeleteWhenRemoving,
		dontDeleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameMustMatch,
		fsTgtSystem,
		fsAppleTalk,
		'DRVR',
		10,
		10,
		4627,
		"",
		".ATP"
	}
};

resource 'inra' (raSystem_DRVR40_XPP) {
	format0 {
		dontDeleteWhenRemoving,
		dontDeleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameMustMatch,
		fsTgtSystem,
		fsAppleTalk,
		'DRVR',
		40,
		40,
		3567,
		"",
		".XPP"
	}
};

resource 'inra' (raSystem_lmgr0) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsAppleTalk,
		'lmgr',
		0,
		0,
		8636,
		"",
		""
	}
};

resource 'inra' (raSystem_DRVR126_DSP) {
	format0 {
		dontDeleteWhenRemoving,
		dontDeleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameMustMatch,
		fsTgtSystem,
		fsAppleTalk,
		'DRVR',
		126,
		126,
		17115,
		"",
		".DSP"
	}
};

resource 'inra' (raSystem_drvr9) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsAppleTalk,
		'drvr',
		9,
		9,
		15740,
		"",
		""
	}
};

resource 'inra' (raSystem_AINI30) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsAppleTalk,
		'AINI',
		30,
		30,
		312,
		"",
		""
	}
};

resource 'inra' (raSystem_AINI30000) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'AINI',
		30000,
		30000,
		2318,
		"",
		""
	}
};

resource 'inra' (raSystem_AINI32000) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'AINI',
		32000,
		32000,
		4950,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_AINI20) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'AINI',
		20,
		20,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_DRVR40_XPP) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'DRVR',
		40,
		40,
		0,
		"",
		".XPP"
	}
};

resource 'inra' (raDeleteSystem_DITL_4030) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'DITL',
		-4030,
		-4030,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_DITL_4031) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'DITL',
		-4031,
		-4031,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_DITL_4032) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'DITL',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_ALRT_4030) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'ALRT',
		-4030,
		-4030,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_ALRT_4031) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'ALRT',
		-4031,
		-4031,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_ALRT_4032) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'ALRT',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (raDeleteSystem_STR__4032) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		ignoreProtection,
		srcNeedNotExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		0,
		'STR#',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (raSystem_STR__16408) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'STR#',
		-16408,
		-16408,
		864,
		"",
		""
	}
};

resource 'inra' (raSystem_STR__16504) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'STR#',
		-16504,
		-16504,
		226,
		"",
		""
	}
};

resource 'inra' (raSystem_STR__16503) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'STR#',
		-16503,
		-16503,
		51,
		"",
		""
	}
};

resource 'inra' (raEnabler201_lefT0) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		noTgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtEnabler201,
		fsNetworkResources,
		'lefT',
		0,
		0,
		69,
		"",
		""
	}
};

resource 'inra' (raSystem_DRVR127_ENET) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'DRVR',
		127,
		127,
		2380,
		"",
		""
	}
};

#if 0
/* EtherTalk NB driver - install 'enet' resource */
resource 'inra' (raSystem_enet8) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		fsNetworkResources,
		'enet',
		8,
		8,
		4420,
		"",
		""
	}
};
#endif

#if 0 /* Disabled since we are using the extension instead */
/* Check for existing SEthernet/30 'enet' resource in System file */
resource 'inaa' (aaTestSEthernet30) {
	format0 {
		actBefore,
		dontActOnRemove,
		actOnInstall,
		'TSTE',
		0,
		0x000125a3,
		"Preparing to install…"
	}
};

/* Install SEthernet/30 driver as 'enet' resource in System file */
resource 'inra' (raSystem_enet9635) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byID,
		nameNeedNotMatch,
		fsTgtSystem,
		13000,
		'enet',
		9635,
		9635,
		0,
		"",
		""
	}
};
#endif

/* Install SEthernet/30 driver as extension */
resource 'infa' (faSEthernet30) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtSEthernet30,
		fsSEthernet30,
		0,
		""
	}
};

resource 'infa' (faDeleteOldSEthernet30) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtSEthernet30Old,
		0,
		0,
		""
	}
};

resource 'inra' (raSystem_DRVR69_ENET0) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		tgtRequired,
		updateExisting,
		copyIfNewOrUpdate,
		dontIgnoreProtection,
		srcNeedExist,
		byName,
		nameMustMatch,
		fsTgtSystem,
		fsSEthernetResources,
		'DRVR',
		69,
		0,
		0,
		"",
		".ENET0"
	}
};

resource 'infa' (faMacTCP) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		fsTgtMacTCP,
		fsMacTCP,
		0,
		""
	}
};
