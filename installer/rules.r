#include "InstallerTypes.r"

/* Detection rule for EtherTalk NB */
#if 0
resource 'inrl' (9550) {
	format0 {
		{	/* array Rules: 6 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkUserFunction {
				'CCRD',
				0,
				8
			},
			/* [3] */
			checkUserFunction {
				'CHKE',
				0,
				0x06050008
			},
			/* [4] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9503,
					/* [2] */
					9550,
					/* [3] */
					9514
				}
			},
			/* [5] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9520
				}
			},
			/* [6] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9202
				}
			}
		}
	}
};
#endif

resource 'inrl' (9531) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9520
				}
			}
		}
	}
};

resource 'inrl' (9528) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9514
				}
			}
		}
	}
};

resource 'inrl' (9529) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9515
				}
			}
		}
	}
};

resource 'inrl' (9527) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkFileVersion {
				9102,
				0x3,
				0x2,
				release,
				0x0
			}
		}
	}
};

resource 'inrl' (9524) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkFileVersion {
				9114,
				0x2,
				0x56,
				release,
				0x0
			}
		}
	}
};

resource 'inrl' (9535) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkFileRsrcForkExists {
				9102
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9520,
					/* [2] */
					9503,
					/* [3] */
					9535
				}
			}
		}
	}
};

resource 'inrl' (9536) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAnyAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9508,
					/* [2] */
					9507,
					/* [3] */
					9509
				}
			}
		}
	}
};

resource 'inrl' (9537) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9535
				}
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9510
				}
			}
		}
	}
};

resource 'inrl' (9532) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkFileRsrcForkExists {
				9114
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9514,
					/* [2] */
					9507,
					/* [3] */
					9503
				}
			}
		}
	}
};

resource 'inrl' (9504) {
	format0 {
		{	/* array Rules: 4 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9514
				}
			},
			/* [3] */
			checkUserFunction {
				'CHKD',
				0,
				0x7F20007F
			},
			/* [4] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9111
				}
			}
		}
	}
};

resource 'inrl' (9511) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9542
				}
			},
			/* [2] */
			checkUserFunction {
				'CHKA',
				6,
				0x58130000
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9511,
					/* [2] */
					9503
				}
			}
		}
	}
};

resource 'inrl' (9512) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9543
				}
			},
			/* [2] */
			checkUserFunction {
				'CHKD',
				0,
				0x3A130009
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9512,
					/* [2] */
					9503
				}
			}
		}
	}
};

resource 'inrl' (9503) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9503
				}
			}
		}
	}
};

resource 'inrl' (9521) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9514
				}
			},
			/* [3] */
			checkUserFunction {
				'CCRD',
				1,
				2
			}
		}
	}
};

resource 'inrl' (9522) {
	format0 {
		{	/* array Rules: 4 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkUserFunction {
				'CCRD',
				1,
				0
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9507,
					/* [2] */
					9503,
					/* [3] */
					9514
				}
			},
			/* [4] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9519
				}
			}
		}
	}
};

resource 'inrl' (9523) {
	format0 {
		{	/* array Rules: 3 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkUserFunction {
				'CCRD',
				1,
				1
			},
			/* [3] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9503,
					/* [2] */
					9507,
					/* [3] */
					9514
				}
			}
		}
	}
};

resource 'inrl' (12000) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9514
				}
			},
			/* [2] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9110
				}
			}
		}
	}
};

resource 'inrl' (12003) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9511
				}
			},
			/* [2] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					14016
				}
			}
		}
	}
};

resource 'inrl' (12004) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9512
				}
			},
			/* [2] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					14017
				}
			}
		}
	}
};

resource 'inrl' (12008) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9520
				}
			},
			/* [2] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9100
				}
			}
		}
	}
};

resource 'inrl' (11000) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			addUserDescription {
				"Click Install to place"
			}
		}
	}
};

resource 'inrl' (11001) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			reportVolError {
				"The selected disk named '^0' has no installed System.  AppleTalk cannot be insta"
				"lled on this disk.  Please click Switch Disk to choose a different disk or inser"
				"t a floppy disk."
			}
		}
	}
};

resource 'inrl' (11002) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9543,
					/* [2] */
					9542
				}
			},
			/* [2] */
			reportVolError {
				"The selected disk named '^0' has a later version of AppleTalk installed.  AppleT"
				"alk cannot be installed on this disk.  Please click Switch Disk to choose a diff"
				"erent disk or insert a floppy disk."
			}
		}
	}
};

resource 'inrl' (11003) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9541
				}
			},
			/* [2] */
			reportVolError {
				"The selected disk named '^0' has System 6.0.3 or earlier installed.  AppleTalk c"
				"annot be installed on this disk.  Please click Switch Disk to choose a different"
				" disk or insert a floppy disk."
			}
		}
	}
};

resource 'inrl' (11004) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9507
				}
			},
			/* [2] */
			addUserDescription {
				"\n• EtherTalk Software Update"
			}
		}
	}
};

resource 'inrl' (11006) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9510
				}
			},
			/* [2] */
			addUserDescription {
				"\n• Network Control Panel Software Update"
			}
		}
	}
};

resource 'inrl' (11007) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9511,
					/* [2] */
					9512
				}
			},
			/* [2] */
			addUserDescription {
				"\n• AppleTalk version 58.1.3"
			}
		}
	}
};

#if 0
resource 'inrl' (11008) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9550
				}
			},
			/* [2] */
			addUserDescription {
				"\n• EtherTalk for Ethertalk NB Card"
			}
		}
	}
};
#endif

resource 'inrl' (9169) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9189
				}
			}
		}
	}
};

resource 'inrl' (9177) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9179
				}
			}
		}
	}
};

resource 'inrl' (9170) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9191
				}
			}
		}
	}
};

resource 'inrl' (9171) {
	format0 {
		{	/* array Rules: 1 elements */
			/* [1] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9192
				}
			}
		}
	}
};

resource 'inrl' (9176) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9180,
					/* [2] */
					9181,
					/* [3] */
					9182
				}
			},
			/* [2] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9183
				}
			}
		}
	}
};

resource 'inrl' (9541) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkFileVersion {
				9001,
				0x0,
				0x0,
				0x0,
				0x0
			},
			/* [2] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9541
				}
			}
		}
	}
};

resource 'inrl' (9542) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkFileVersion {
				9001,
				0x6,
				0x4,
				release,
				0x0
			},
			/* [2] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9542
				}
			}
		}
	}
};

resource 'inrl' (9543) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkFileVersion {
				9001,
				0x7,
				0x0,
				release,
				0x0
			},
			/* [2] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9543
				}
			}
		}
	}
};

resource 'infr' (0) {
	format0 {
		{	/* array RuleArray: 16 elements */
			/* [1] */
			pickFirst,
			{	/* array IntegerArray: 3 elements */
				/* [1] */
//				9163,
				/* [2] */
//				9162,
				/* [3] */
				9169
			},
			/* [2] */
			pickFirst,
			{	/* array IntegerArray: 3 elements */
				/* [1] */
				9177,
				/* [2] */
				9541,
				/* [3] */
				11001
			},
			/* [3] */
			pickFirst,
			{	/* array IntegerArray: 4 elements */
				/* [1] */
				9177,
				/* [2] */
				9543,
				/* [3] */
				9542,
				/* [4] */
				11003
			},
			/* [4] */
			pickFirst,
			{	/* array IntegerArray: 2 elements */
				/* [1] */
//				9164,
				/* [2] */
				9170
			},
			/* [5] */
			pickFirst,
			{	/* array IntegerArray: 2 elements */
				/* [1] */
//				9165,
				/* [2] */
				9171
			},
			/* [6] */
			pickFirst,
			{	/* array IntegerArray: 2 elements */
				/* [1] */
//				9163,
				/* [2] */
//				11016
			},
			/* [7] */
			pickAll,
			{	/* array IntegerArray: 18 elements */
				/* [1] */
				9176,
				/* [2] */
//				9580,
				/* [3] */
//				9585,
				/* [4] */
#if 0
				9550,
#endif
				/* [5] */
//				9555,
				/* [6] */
//				9560,
				/* [7] */
//				9565,
				/* [8] */
//				9570,
				/* [9] */
//				9575,
				/* [10] */
//				9590,
				/* [11] */
//				9616,
				/* [12] */
//				9617,
				/* [13] */
//				9615,
				/* [14] */
//				9600,
				/* [15] */
//				9605,
				/* [16] */
//				9595,
				/* [17] */
				9504,
				/* [18] */
//				9505,
				13001
			},
			/* [8] */
			pickFirst,
			{	/* array IntegerArray: 4 elements */
				/* [1] */
				9177,
				/* [2] */
				9529,
				/* [3] */
//				9525,
				/* [4] */
//				9533
			},
			/* [9] */
			pickFirst,
			{	/* array IntegerArray: 7 elements */
				/* [1] */
				9177,
				/* [2] */
				9521,
				/* [3] */
				9522,
				/* [4] */
				9523,
				/* [5] */
				9528,
				/* [6] */
				9524,
				/* [7] */
				9532
			},
			/* [10] */
			pickFirst,
			{	/* array IntegerArray: 4 elements */
				/* [1] */
				9177,
				/* [2] */
				9531,
				/* [3] */
				9527,
				/* [4] */
				9535
			},
			/* [11] */
			pickFirst,
			{	/* array IntegerArray: 2 elements */
				/* [1] */
				9536,
				/* [2] */
				9537
			},
			/* [12] */
			pickFirst,
			{	/* array IntegerArray: 5 elements */
				/* [1] */
				9177,
				/* [2] */
				9511,
				/* [3] */
				9512,
				/* [4] */
				9503,
				/* [5] */
				11002
			},
			/* [13] */
			pickFirst,
			{	/* array IntegerArray: 2 elements */
				/* [1] */
//				9168,
				/* [2] */
//				9174
			},
			/* [14] */
			pickAll,
			{	/* array IntegerArray: 3 elements */
				/* [1] */
//				9172,
				/* [2] */
//				9166,
				/* [3] */
//				9167
			},
			/* [15] */
			pickAll,
			{	/* array IntegerArray: 19 elements */
				/* [1] */
				11000,
				/* [2] */
				11007,
				/* [3] */
#if 0
				11008,
#endif
				/* [4] */
//				11009,
				/* [5] */
//				11010,
				/* [6] */
//				11011,
				/* [7] */
//				11012,
				/* [8] */
//				11013,
				/* [9] */
//				11017,
				/* [10] */
//				11019,
				/* [11] */
//				11024,
				/* [12] */
//				11023,
				/* [13] */
//				11020,
				/* [14] */
//				11014,
				/* [15] */
//				11015,
				/* [16] */
				11004,
				/* [17] */
//				11005,
				/* [18] */
				11006,
				/* [19] */
//				9185,
				13002
			},
			/* [16] */
			pickAll,
			{	/* array IntegerArray: 7 elements */
				/* [1] */
				12000,
				/* [2] */
//				12001,
				/* [3] */
				12003,
				/* [4] */
				12004,
				/* [5] */
//				12006,
				/* [6] */
//				12005,
				/* [7] */
				12008
			}
		}
	}
};

/* Detection rule for SEthernet/30 */
resource 'inrl' (13001) {
	format0 {
		{	/* array Rules: 6 elements */
			/* [1] */
			checkAnyAssertion {
				{	/* array IntegerArray: 2 elements */
					/* [1] */
					9542,
					/* [2] */
					9543
				}
			},
			/* [2] */
			checkUserFunction {
				'CCRD',
				0,
				9635
			},
			/* [4] */
			addAssertion {
				{	/* array IntegerArray: 3 elements */
					/* [1] */
					9503,
					/* [2] */
					13001,
					/* [3] */
					9514
				}
			},
			/* [5] */
			addAssertion {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					9520
				}
			},
			/* [6] */
			addPackages {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					13001
				}
			}
		}
	}
};

resource 'inrl' (13002) {
	format0 {
		{	/* array Rules: 2 elements */
			/* [1] */
			checkAllAssertions {
				{	/* array IntegerArray: 1 elements */
					/* [1] */
					13001
				}
			},
			/* [2] */
			addUserDescription {
				"\n• EtherTalk for SEthernet/30 Card"
			}
		}
	}
};