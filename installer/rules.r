#include "InstallerTypes.r"
#include "identifiers.r"

/*
Detection rule for EtherTalk NB 

Check Slot Manager for board ID 8
Check if 'enet' resource 8 needs updating (version 6.0.5)
*/
#if 0
resource 'inrl' (rlEtherTalkNB) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
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
					asInstallingAppleTalk,
					asEtherTalkNB,
					asInstallENETDriver
				}
			},
			addAssertion {
				{
					asInstallNetworkControl
				}
			},
			addPackages {
				{
					pkEtherTalkNB
				}
			}
		}
	}
};
#endif

resource 'inrl' (rlInstallingNetworkControl) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallNetworkControl
				}
			}
		}
	}
};

resource 'inrl' (rlInstallingENETDriver) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkAllAssertions {
				{
					asInstallENETDriver
				}
			}
		}
	}
};

resource 'inrl' (rlNetworkControl3_2) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkFileVersion {
				fsTgtNetworkControl,
				0x3,
				0x2,
				release,
				0x0
			}
		}
	}
};

resource 'inrl' (rlEtherTalkPhase2_2_5_6) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkFileVersion {
				fsTgtEtherTalkPhase2Extension,
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
					asSystem6_0_4,
					asSystem7
				}
			},
			checkFileRsrcForkExists {
				fsTgtNetworkControl
			},
			addAssertion {
				{
					asInstallNetworkControl,
					asInstallingAppleTalk,
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
					asSystem6_0_4,
					asSystem7
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
					asSystem6_0_4,
					asSystem7
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

resource 'inrl' (rlHasEtherTalkPhase2) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkFileRsrcForkExists {
				fsTgtEtherTalkPhase2Extension
			},
			addAssertion {
				{
					asInstallENETDriver,
					9507,
					asInstallingAppleTalk
				}
			}
		}
	}
};

resource 'inrl' (rlInstallENETDriver) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkAllAssertions {
				{
					asInstallENETDriver
				}
			},
			checkUserFunction {
				'CHKD',
				0,
				0x7F20007F
			},
			addPackages {
				{
					pkENETDriver
				}
			}
		}
	}
};

resource 'inrl' (rlCHKA6_58130000) {
	format0 {
		{
			checkAllAssertions {
				{
					asSystem6_0_4
				}
			},
			checkUserFunction {
				'CHKA',
				6,
				0x58130000
			},
			addAssertion {
				{
					asInstallAppleTalkSystem6,
					asInstallingAppleTalk
				}
			}
		}
	}
};

resource 'inrl' (rlCHKD0_3A130000) {
	format0 {
		{
			checkAllAssertions {
				{
					asSystem7
				}
			},
			checkUserFunction {
				'CHKD',
				0,
				0x3A130009
			},
			addAssertion {
				{
					asInstallAppleTalkSystem7,
					asInstallingAppleTalk
				}
			}
		}
	}
};

resource 'inrl' (rlInstallingAppleTalk) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallingAppleTalk
				}
			}
		}
	}
};

resource 'inrl' (rlCCRD1_2) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkAllAssertions {
				{
					asInstallENETDriver
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

resource 'inrl' (rlCCRD1_0) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
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
					asInstallingAppleTalk,
					asInstallENETDriver
				}
			},
			addPackages {
				{
					pkENETDriverUpdate
				}
			}
		}
	}
};

resource 'inrl' (rlCCRD1_1) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkUserFunction {
				'CCRD',
				1,
				1
			},
			addAssertion {
				{
					asInstallingAppleTalk,
					9507,
					asInstallENETDriver
				}
			}
		}
	}
};

resource 'inrl' (rlInstallEtherTalk) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallENETDriver
				}
			},
			addPackages {
				{
					pkEtherTalkPhase2
				}
			}
		}
	}
};

resource 'inrl' (rlInstallAppleTalk6) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallAppleTalkSystem6
				}
			},
			addPackages {
				{
					pkAppleTalkSystem6Custom
				}
			}
		}
	}
};

resource 'inrl' (rlInstallAppleTalk7) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallAppleTalkSystem7
				}
			},
			addPackages {
				{
					pkAppleTalkSystem7Custom
				}
			}
		}
	}
};

resource 'inrl' (rlInstallNetworkControlPanel) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallNetworkControl
				}
			},
			addPackages {
				{
					pkNetworkControl
				}
			}
		}
	}
};

resource 'inrl' (rlBaseDescription) {
	format0 {
		{
			addUserDescription {
				"Click Install to place"
			}
		}
	}
};

resource 'inrl' (rlNoSystemError) {
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

resource 'inrl' (rlLaterAppleTalkError) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem7,
					asSystem6_0_4
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

resource 'inrl' (rlOldSystemError) {
	format0 {
		{
			checkAllAssertions {
				{
					asHasSystem
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

resource 'inrl' (rlEtherTalkUpdateDescription) {
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

resource 'inrl' (rlNetworkControlPanelDescription) {
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

resource 'inrl' (rlAppleTalkDescription) {
	format0 {
		{
			checkAnyAssertion {
				{
					asInstallAppleTalkSystem6,
					asInstallAppleTalkSystem7
				}
			},
			addUserDescription {
				"\n• AppleTalk version 58.1.3"
			}
		}
	}
};

#if 0
resource 'inrl' (rlEtherTalkNBDescription) {
	format0 {
		{
			checkAllAssertions {
				{
					asEtherTalkNB
				}
			},
			addUserDescription {
				"\n• EtherTalk for Ethertalk NB Card"
			}
		}
	}
};
#endif

/* Set assertion asHasSystem if System file exists and has a 'vers' resource */ 
resource 'inrl' (rlHasSystem) {
	format0 {
		{
			checkFileVersion {
				fsTgtSystem,
				0x0,
				0x0,
				0x0,
				0x0
			},
			addAssertion {
				{
					asHasSystem
				}
			}
		}
	}
};

/* Set assertion asSystem6 if System version >= 6.0.4 */
resource 'inrl' (rlSystem6_0_4) {
	format0 {
		{
			checkFileVersion {
				fsTgtSystem,
				0x6,
				0x4,
				release,
				0x0
			},
			addAssertion {
				{
					asSystem6_0_4
				}
			}
		}
	}
};

/* Set assertion asSystem7 if System version >= 7.0.0 */
resource 'inrl' (rlSystem7) {
	format0 {
		{
			checkFileVersion {
				fsTgtSystem,
				0x7,
				0x0,
				release,
				0x0
			},
			addAssertion {
				{
					asSystem7
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
				// A/UX rule 9177,
				rlHasSystem,		/* does the target volume have a valid System file? */
				rlNoSystemError
			},
			pickFirst,
			{	/* If System older than 6.0.4, block installlation */
				// A/UX rule 9177,
				rlSystem7,			/* Does the target volume have System 7 or newer? */
				rlSystem6_0_4,		/* Does the target volume have System 6.0.4 or newer */
				rlOldSystemError
			},
			pickAll,
			{
				// A/UX rule 9176,
#if 0
				rlEtherTalkNB,	/* Detect and add packages for EtherTalk NB */
#endif
				rlSEthernet30,	/* Detect and add packages for SEthernet/30 */
				rlInstallENETDriver	/* Detect existing .ENET driver and install update if needed */
			},
			pickFirst,
			{
				// A/UX rule 9177,
				rlCCRD1_2,
				rlCCRD1_0,
				rlCCRD1_1,
				rlInstallingENETDriver,
				rlEtherTalkPhase2_2_5_6,
				rlHasEtherTalkPhase2
			},
			pickFirst,
			{
				// A/UX rule 9177,
				rlInstallingNetworkControl,
				rlNetworkControl3_2,
				9535
			},
			pickFirst,
			{
				9536,
				9537
			},
			pickFirst,
			{
				// A/UX rule 9177,
				rlCHKA6_58130000,
				rlCHKD0_3A130000,
				rlInstallingAppleTalk,
				rlLaterAppleTalkError
			},
			pickAll,
			{	/* Build install description */
				rlBaseDescription,
				rlAppleTalkDescription,
#if 0
				rlEtherTalkNBDescription,
#endif
				rlEtherTalkUpdateDescription,
				rlNetworkControlPanelDescription,
				rlSEthernet30Description
			},
			pickAll,
			{	/* Install requested support packages */
				rlInstallEtherTalk,
				rlInstallAppleTalk6,
				rlInstallAppleTalk7,
				rlInstallNetworkControlPanel
			}
		}
	}
};

/* Detection rule for SEthernet/30 */
resource 'inrl' (rlSEthernet30) {
	format0 {
		{
			checkAnyAssertion {
				{
					asSystem6_0_4,
					asSystem7
				}
			},
			checkUserFunction {
				'CCRD',
				0,
				9635
			},
			addAssertion {
				{
					asInstallingAppleTalk,
					asSEthernet30,
					asInstallENETDriver
				}
			},
			addAssertion {
				{
					asInstallNetworkControl
				}
			},
			addPackages {
				{
					pkSEthernet30
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
					asSEthernet30
				}
			},
			addUserDescription {
				"\n• EtherTalk for SEthernet/30 Card"
			}
		}
	}
};