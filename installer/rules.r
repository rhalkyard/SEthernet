#include "InstallerTypes.r"

/* Detection rule for EtherTalk NB */
#if 0
resource 'inrl' (9550) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkUserFunction {
				'CCRD',
				0,
				8
			},
			checkUserFunction {
				'CHKE',
				0,
				0x06050008
			},
			addAssertion {
				{
					9503,
					9550,
					9514
				}
			},
			addAssertion {
				{
					9520
				}
			},
			addPackages {
				{
					9202
				}
			}
		}
	}
};
#endif

resource 'inrl' (9531) {
	format0 {
		{
			checkAllAssertions {
				{
					9520
				}
			}
		}
	}
};

resource 'inrl' (9528) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAllAssertions {
				{
					9514
				}
			}
		}
	}
};

resource 'inrl' (9529) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAllAssertions {
				{
					9515
				}
			}
		}
	}
};

resource 'inrl' (9527) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
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
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
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
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkFileRsrcForkExists {
				9102
			},
			addAssertion {
				{
					9520,
					9503,
					9535
				}
			}
		}
	}
};

resource 'inrl' (9536) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAnyAssertion {
				{
					9508,
					9507,
					9509
				}
			}
		}
	}
};

resource 'inrl' (9537) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAllAssertions {
				{
					9535
				}
			},
			addAssertion {
				{
					9510
				}
			}
		}
	}
};

resource 'inrl' (9532) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkFileRsrcForkExists {
				9114
			},
			addAssertion {
				{
					9514,
					9507,
					9503
				}
			}
		}
	}
};

resource 'inrl' (9504) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAllAssertions {
				{
					9514
				}
			},
			checkUserFunction {
				'CHKD',
				0,
				0x7F20007F
			},
			addPackages {
				{
					9111
				}
			}
		}
	}
};

resource 'inrl' (9511) {
	format0 {
		{
			checkAllAssertions {
				{
					9542
				}
			},
			checkUserFunction {
				'CHKA',
				6,
				0x58130000
			},
			addAssertion {
				{
					9511,
					9503
				}
			}
		}
	}
};

resource 'inrl' (9512) {
	format0 {
		{
			checkAllAssertions {
				{
					9543
				}
			},
			checkUserFunction {
				'CHKD',
				0,
				0x3A130009
			},
			addAssertion {
				{
					9512,
					9503
				}
			}
		}
	}
};

resource 'inrl' (9503) {
	format0 {
		{
			checkAllAssertions {
				{
					9503
				}
			}
		}
	}
};

resource 'inrl' (9521) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkAllAssertions {
				{
					9514
				}
			},
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
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkUserFunction {
				'CCRD',
				1,
				0
			},
			addAssertion {
				{
					9507,
					9503,
					9514
				}
			},
			addPackages {
				{
					9519
				}
			}
		}
	}
};

resource 'inrl' (9523) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkUserFunction {
				'CCRD',
				1,
				1
			},
			addAssertion {
				{
					9503,
					9507,
					9514
				}
			}
		}
	}
};

resource 'inrl' (12000) {
	format0 {
		{
			checkAllAssertions {
				{
					9514
				}
			},
			addPackages {
				{
					9110
				}
			}
		}
	}
};

resource 'inrl' (12003) {
	format0 {
		{
			checkAllAssertions {
				{
					9511
				}
			},
			addPackages {
				{
					14016
				}
			}
		}
	}
};

resource 'inrl' (12004) {
	format0 {
		{
			checkAllAssertions {
				{
					9512
				}
			},
			addPackages {
				{
					14017
				}
			}
		}
	}
};

resource 'inrl' (12008) {
	format0 {
		{
			checkAllAssertions {
				{
					9520
				}
			},
			addPackages {
				{
					9100
				}
			}
		}
	}
};

resource 'inrl' (11000) {
	format0 {
		{
			addUserDescription {
				"Click Install to place"
			}
		}
	}
};

resource 'inrl' (11001) {
	format0 {
		{
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
		{
			checkAnyAssertion {
				{
					9543,
					9542
				}
			},
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
		{
			checkAllAssertions {
				{
					9541
				}
			},
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
		{
			checkAllAssertions {
				{
					9507
				}
			},
			addUserDescription {
				"\n• EtherTalk Software Update"
			}
		}
	}
};

resource 'inrl' (11006) {
	format0 {
		{
			checkAllAssertions {
				{
					9510
				}
			},
			addUserDescription {
				"\n• Network Control Panel Software Update"
			}
		}
	}
};

resource 'inrl' (11007) {
	format0 {
		{
			checkAnyAssertion {
				{
					9511,
					9512
				}
			},
			addUserDescription {
				"\n• AppleTalk version 58.1.3"
			}
		}
	}
};

#if 0
resource 'inrl' (11008) {
	format0 {
		{
			checkAllAssertions {
				{
					9550
				}
			},
			addUserDescription {
				"\n• EtherTalk for Ethertalk NB Card"
			}
		}
	}
};
#endif

resource 'inrl' (9169) {
	format0 {
		{
			addAssertion {
				{
					9189
				}
			}
		}
	}
};

resource 'inrl' (9177) {
	format0 {
		{
			checkAllAssertions {
				{
					9179
				}
			}
		}
	}
};

resource 'inrl' (9170) {
	format0 {
		{
			addAssertion {
				{
					9191
				}
			}
		}
	}
};

resource 'inrl' (9171) {
	format0 {
		{
			addAssertion {
				{
					9192
				}
			}
		}
	}
};

resource 'inrl' (9176) {
	format0 {
		{
			checkAllAssertions {
				{
					9180,
					9181,
					9182
				}
			},
			addAssertion {
				{
					9183
				}
			}
		}
	}
};

resource 'inrl' (9541) {
	format0 {
		{
			checkFileVersion {
				9001,
				0x0,
				0x0,
				0x0,
				0x0
			},
			addAssertion {
				{
					9541
				}
			}
		}
	}
};

resource 'inrl' (9542) {
	format0 {
		{
			checkFileVersion {
				9001,
				0x6,
				0x4,
				release,
				0x0
			},
			addAssertion {
				{
					9542
				}
			}
		}
	}
};

resource 'inrl' (9543) {
	format0 {
		{
			checkFileVersion {
				9001,
				0x7,
				0x0,
				release,
				0x0
			},
			addAssertion {
				{
					9543
				}
			}
		}
	}
};

resource 'infr' (0) {
	format0 {
		{
			pickFirst,
			{
				9169
			},
			pickFirst,
			{
				9177,
				9541,
				11001
			},
			pickFirst,
			{
				9177,
				9543,
				9542,
				11003
			},
			pickFirst,
			{
				9170
			},
			pickFirst,
			{
				9171
			},
			pickAll,
			{
				9176,
#if 0
				9550,
#endif
				9504,
				13001
			},
			pickFirst,
			{
				9177,
				9529
			},
			pickFirst,
			{
				9177,
				9521,
				9522,
				9523,
				9528,
				9524,
				9532
			},
			pickFirst,
			{
				9177,
				9531,
				9527,
				9535
			},
			pickFirst,
			{
				9536,
				9537
			},
			pickFirst,
			{
				9177,
				9511,
				9512,
				9503,
				11002
			},
			pickAll,
			{
				11000,
				11007,
#if 0
				11008,
#endif
				11004,
				11006,
				13002
			},
			pickAll,
			{
				12000,
				12003,
				12004,
				12008
			}
		}
	}
};

/* Detection rule for SEthernet/30 */
resource 'inrl' (13001) {
	format0 {
		{
			checkAnyAssertion {
				{
					9542,
					9543
				}
			},
			checkUserFunction {
				'CCRD',
				0,
				9635
			},
			addAssertion {
				{
					9503,
					13001,
					9514
				}
			},
			addAssertion {
				{
					9520
				}
			},
			addPackages {
				{
					13001
				}
			}
		}
	}
};

resource 'inrl' (13002) {
	format0 {
		{
			checkAllAssertions {
				{
					13001
				}
			},
			addUserDescription {
				"\n• EtherTalk for SEthernet/30 Card"
			}
		}
	}
};