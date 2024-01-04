#include "InstallerTypes.r"

resource 'infa' (9002) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9002,
		9008,
		61440,
		""
	}
};

resource 'infa' (9003) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9003,
		9009,
		7680,
		"Responder"
	}
};

resource 'infa' (9004) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9004,
		0,
		0,
		""
	}
};

resource 'infa' (9005) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9005,
		0,
		0,
		""
	}
};

resource 'infa' (9006) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9006,
		0,
		0,
		""
	}
};

resource 'infa' (9007) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9002,
		0,
		0,
		""
	}
};

resource 'infa' (9102) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9102,
		9101,
		43008,
		""
	}
};

resource 'infa' (9114) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9114,
		9113,
		15360,
		""
	}
};

resource 'infa' (9115) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9115,
		0,
		0,
		""
	}
};

resource 'infa' (9116) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9116,
		0,
		0,
		"EtherTalk2.0 File"
	}
};

resource 'infa' (9117) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9117,
		0,
		0,
		"EtherTalk2.1 File"
	}
};

resource 'infa' (9118) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9118,
		0,
		0,
		""
	}
};

resource 'infa' (9119) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9119,
		0,
		0,
		"EtherTalk2.0 File"
	}
};

resource 'infa' (9120) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		9120,
		0,
		0,
		"EtherTalk2.1 File"
	}
};

resource 'inaa' (9001) {
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

resource 'inaa' (9000) {
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

resource 'inaa' (9002) {
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

resource 'inaa' (9003) {
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

resource 'inaa' (9004) {
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

resource 'inaa' (9005) {
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

resource 'inaa' (9112) {
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

/* EtherTalk NB driver - check for exiting 'enet' resource */
#if 0
resource 'inaa' (9202) {
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

resource 'inaa' (9540) {
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

resource 'inra' (9000) {
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
		9001,
		9000,
		'INIT',
		18,
		18,
		416,
		"",
		""
	}
};

resource 'inra' (9001) {
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
		9001,
		9000,
		'iopc',
		128,
		128,
		3138,
		"",
		""
	}
};

resource 'inra' (9005) {
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
		9001,
		9000,
		'ltlk',
		2,
		2,
		5112,
		"",
		""
	}
};

resource 'inra' (9006) {
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
		9001,
		9000,
		'ltlk',
		3,
		3,
		3000,
		"",
		""
	}
};

resource 'inra' (9031) {
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
		9001,
		9000,
		'ltlk',
		4,
		4,
		5300,
		"",
		""
	}
};

resource 'inra' (9032) {
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
		9001,
		9000,
		'ltlk',
		5,
		5,
		5300,
		"",
		""
	}
};

resource 'inra' (9008) {
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
		9001,
		9000,
		'atlk',
		3,
		3,
		888,
		"",
		""
	}
};

resource 'inra' (9002) {
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
		9001,
		9000,
		'iopc',
		127,
		127,
		3138,
		"",
		""
	}
};

resource 'inra' (9003) {
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
		9001,
		9000,
		'ltlk',
		0,
		0,
		5236,
		"",
		""
	}
};

resource 'inra' (9004) {
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
		9001,
		9000,
		'ltlk',
		1,
		1,
		3016,
		"",
		""
	}
};

resource 'inra' (9007) {
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
		9001,
		9000,
		'atlk',
		1,
		1,
		884,
		"",
		""
	}
};

resource 'inra' (9009) {
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
		9001,
		9008,
		'DRVR',
		9,
		9,
		5209,
		"",
		".MPP"
	}
};

resource 'inra' (9010) {
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
		9001,
		9008,
		'DRVR',
		10,
		10,
		4627,
		"",
		".ATP"
	}
};

resource 'inra' (9011) {
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
		9001,
		9008,
		'DRVR',
		40,
		40,
		3567,
		"",
		".XPP"
	}
};

resource 'inra' (9017) {
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
		9001,
		9008,
		'lmgr',
		0,
		0,
		8636,
		"",
		""
	}
};

resource 'inra' (9012) {
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
		9001,
		9008,
		'DRVR',
		126,
		126,
		17115,
		"",
		".DSP"
	}
};

resource 'inra' (9013) {
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
		9001,
		9008,
		'drvr',
		9,
		9,
		15740,
		"",
		""
	}
};

resource 'inra' (9014) {
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
		9001,
		9008,
		'AINI',
		30,
		30,
		312,
		"",
		""
	}
};

resource 'inra' (9015) {
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
		9001,
		9000,
		'AINI',
		30000,
		30000,
		2318,
		"",
		""
	}
};

resource 'inra' (9016) {
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
		9001,
		9000,
		'AINI',
		32000,
		32000,
		4950,
		"",
		""
	}
};

resource 'inra' (9026) {
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
		9001,
		0,
		'AINI',
		20,
		20,
		0,
		"",
		""
	}
};

resource 'inra' (9018) {
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
		9001,
		0,
		'DRVR',
		40,
		40,
		0,
		"",
		".XPP"
	}
};

resource 'inra' (9019) {
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
		9001,
		0,
		'DITL',
		-4030,
		-4030,
		0,
		"",
		""
	}
};

resource 'inra' (9020) {
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
		9001,
		0,
		'DITL',
		-4031,
		-4031,
		0,
		"",
		""
	}
};

resource 'inra' (9021) {
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
		9001,
		0,
		'DITL',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (9022) {
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
		9001,
		0,
		'ALRT',
		-4030,
		-4030,
		0,
		"",
		""
	}
};

resource 'inra' (9023) {
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
		9001,
		0,
		'ALRT',
		-4031,
		-4031,
		0,
		"",
		""
	}
};

resource 'inra' (9024) {
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
		9001,
		0,
		'ALRT',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (9025) {
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
		9001,
		0,
		'STR#',
		-4032,
		-4032,
		0,
		"",
		""
	}
};

resource 'inra' (9027) {
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
		9001,
		9000,
		'STR#',
		-16408,
		-16408,
		864,
		"",
		""
	}
};

resource 'inra' (9028) {
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
		9001,
		9000,
		'STR#',
		-16504,
		-16504,
		226,
		"",
		""
	}
};

resource 'inra' (9029) {
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
		9001,
		9000,
		'STR#',
		-16503,
		-16503,
		51,
		"",
		""
	}
};

resource 'inra' (9030) {
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
		9010,
		9000,
		'lefT',
		0,
		0,
		69,
		"",
		""
	}
};

resource 'inra' (9112) {
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
		9001,
		9000,
		'DRVR',
		127,
		127,
		2380,
		"",
		""
	}
};

/* EtherTalk NB driver - install 'enet' resource */
#if 0
resource 'inra' (9202) {
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
		9001,
		9000,
		'enet',
		8,
		8,
		4420,
		"",
		""
	}
};
#endif

/* Check for existing SEthernet/30 'enet' resource in System file */
#if 0
resource 'inaa' (13001) {
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
#endif

/* Install SEthernet/30 driver as 'enet' resource in System file */
#if 0
resource 'inra' (13001) {
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
		9001,
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
resource 'infa' (13002) {
	format0 {
		deleteWhenRemoving,
		deleteWhenInstalling,
		copy,
		leaveAloneIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		13003,
		13002,
		0,
		""
	}
};

/* Install SEthernet/30 driver as extension */
resource 'infa' (13004) {
	format0 {
		dontDeleteWhenRemoving,
		deleteWhenInstalling,
		dontCopy,
		updateEvenIfNewer,
		updateExisting,
		copyIfNewOrUpdate,
		rsrcFork,
		dataFork,
		13004,
		0,
		0,
		""
	}
};
