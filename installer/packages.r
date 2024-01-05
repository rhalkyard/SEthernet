#include "InstallerTypes.r"

resource 'inpk' (9002) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		96868,
		"",
		{
			'inaa', 9001,
			'infa', 9004,
			'inra', 9019,
			'inra', 9020,
			'inra', 9021,
			'inra', 9022,
			'inra', 9023,
			'inra', 9024,
			'inra', 9025,
			'inra', 9018,
			'infa', 9002,
			'inra', 9000,
			'inra', 9003,
			'inra', 9004,
			'inra', 9005,
			'inra', 9006,
			'inra', 9031,
			'inra', 9032,
			'inra', 9007,
			'inra', 9008,
			'inra', 9001,
			'inra', 9002,
			'inaa', 9002
		}
	}
};

resource 'inpk' (9003) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		97486,
		"",
		{
			'inaa', 9000,
			'infa', 9004,
			'infa', 9005,
			'infa', 9006,
			'infa', 9007,
			'inra', 9026,
			'inra', 9009,
			'inra', 9010,
			'inra', 9011,
			'inra', 9012,
			'inra', 9013,
			'inra', 9017,
			'inra', 9014,
			'inra', 9015,
			'inra', 9016,
			'inra', 9003,
			'inra', 9004,
			'inra', 9005,
			'inra', 9006,
			'inra', 9031,
			'inra', 9032,
			'inra', 9007,
			'inra', 9008,
			'inra', 9001,
			'inra', 9002,
			'inaa', 9003,
			'inaa', 9004
		}
	}
};

resource 'inpk' (9100) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		dontForceRestart,
		0,
		43008,
		"",
		{
			'infa', 9102
		}
	}
};

resource 'inpk' (14016) {
	format0 {
		showsOnCustom,
		notRemovable,
		forceRestart,
		14016,
		147556,
		"AppleTalk v58.1.3 for System 6",
		{
			'inpk', 9002,
			'inpk', 9100,
			'infa', 9003
		}
	}
};

resource 'inpk' (14017) {
	format0 {
		showsOnCustom,
		notRemovable,
		forceRestart,
		14017,
		141704,
		"AppleTalk v58.1.3 for System 7",
		{
			'inpk', 9003,
			'inpk', 9004,
			'inpk', 9100,
			'inra', 9027,
			'inra', 9029,
			'inra', 9028
		}
	}
};

resource 'inpk' (9004) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		69,
		"",
		{
			'inra', 9030,
			'inaa', 9005
		}
	}
};

resource 'inpk' (9500) {
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

resource 'inpk' (9111) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		2380,
		"",
		{
			'inaa', 9112,
			'inra', 9112
		}
	}
};

resource 'inpk' (9110) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		15360,
		"",
		{
			'infa', 9115,
			'infa', 9116,
			'infa', 9117,
			'infa', 9118,
			'infa', 9119,
			'infa', 9120,
			'infa', 9114
		}
	}
};

/* EtherTalk NB driver package */
#if 0
resource 'inpk' (9202) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		4420,
		"",
		{
			'inaa', 9202,
			'inra', 9202
		}
	}
};
#endif

resource 'inpk' (9519) {
	format0 {
		doesntShowOnCustom,
		notRemovable,
		forceRestart,
		0,
		0,
		"",
		{
			'inaa', 9540
		}
	}
};

/* EtherTalk NB Custom Install entry */
#if 0
resource 'inpk' (14000) {
	format0 {
		showsOnCustom,
		removable,
		forceRestart,
		14000,
		65168,
		"EtherTalk for EtherTalk NB Card",
		{
			'inpk', 9202,
			'inpk', 9110,
			'inpk', 9100,
			'inpk', 9111
		}
	}
};
#endif

/* Package selectable for Custom Install - installs both EtherTalk bits and driver */
resource 'inpk' (13000) {
	format0 {
		showsOnCustom,
		removable,
		forceRestart,
		13000,
		0,
		"EtherTalk for SEthernet/30 Card",
		{
			'inpk', 13001,
			'inpk', 9110,
			'inpk', 9100,
			'inpk', 9111
		}
	}
};

/* Package selectable for Easy Install - driver only */
resource 'inpk' (13001) {
	format0 {
		doesntShowOnCustom,
		removable,
		forceRestart,
		0,
		0,
		"",
		{
			'infa', 13002,
			'infa', 13004
		}
	}
};
