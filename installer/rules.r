#include "InstallerTypes.r"
#include "identifiers.r"

#if 0
/*
Detection rule for EtherTalk NB 

Check Slot Manager for board ID 8
Check if 'enet' resource 8 needs updating (version 6.0.5)
*/
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
					asInstallAppleTalk,
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

/* Rule fires if Network control panel install has been requested */
resource 'inrl' (rlNetworkControlRequested) {
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

/* Rule fires if System is >= 6.0.4 or 7 and ethernet driver install has been requested */
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

/* Rule fires if Network control panel version at least 3.0.2 */
resource 'inrl' (rlNetworkControl3_0_2) {
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

/* Rule fires if EtherTalk Phase 2 extension verison is at least 2.5.6 */
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

/* Rule fires if System version is >= 6.0.4 or 7 and Network control panel exists */
resource 'inrl' (rlHasNetworkControl) {
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
					asInstallAppleTalk,
					asHasNetworkControl
				}
			}
		}
	}
};

/* Rule fires if System is >= 6.0.4 or 7 and EtherTalk install has been requested */
resource 'inrl' (rlInstallingEtherTalk) {
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
					asInstallEtherTalk,
				}
			}
		}
	}
};

resource 'inrl' (rlUpdateNetworkControl) {
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
					asHasNetworkControl
				}
			},
			addAssertion {
				{
					asInstallingNetworkControl
				}
			}
		}
	}
};

/* Rule fires if System is >= 6.0.4 or 7 and EtherTalk Phase 2 extension exists */
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
					asInstallEtherTalk,
					asInstallAppleTalk
				}
			}
		}
	}
};

/* Rule fires if System is >= 6.0.4 or 7, ethernet driver install has been
requested, and current .ENET driver version is < 127.0.2 */
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

/* Rule fires if System is >= 6.0.4 and AppleTalk version < 58.1.3 (System 6
only??) */
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
					asInstallAppleTalk
				}
			}
		}
	}
};

/* Rule fires if System is >= 7 and AppleTalk version is < 58.1.3 */
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
					asInstallAppleTalk
				}
			}
		}
	}
};

/* Rule fires if AppleTalk install has been requested */
resource 'inrl' (rlInstallAppleTalk) {
	format0 {
		{
			checkAllAssertions {
				{
					asInstallAppleTalk
				}
			}
		}
	}
};

/* Calls CCRD 1 with RefCon 2 if .ENET driver is being installed */
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

/* Rule installs EtherTalk, AppleTalk and .ENET driver, and triggers .ENET
driver update action if CCRD 1 with RefCon 0 returns true */
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
					asInstallEtherTalk,
					asInstallAppleTalk,
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

/* Rule triggers update of EtherTalk, AppleTalk and .ENET driver if CCRD 1 with
RefCon 1 returns true */
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
					asInstallEtherTalk,
					asInstallAppleTalk,
					asInstallENETDriver
				}
			}
		}
	}
};

/* Rule fires when .ENET driver install has been requested, triggers install of
EtherTalk Phase 2 */
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

/* Rule fires when AppleTalk install has been requested for System 6, triggers
install of AppleTalk package */
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

/* Rule fires when AppleTalk install has been requested for System 7, triggers
install of AppleTalk package */
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

/* Rule fires when Network control panel install has been requested, triggers
install of Network control panel */
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
					asInstallEtherTalk
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
					asInstallingNetworkControl
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

/* Rule fires if System file exists and has a 'vers' resource, sets assertion
asHasSystem */ 
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

/* Rule fires if System version >= 6.0.4, sets assertion asSystem6_0_4 */
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

/* Rule fires if System version >= 7.0.0, sets assertion asSystem7 */
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
					asInstallAppleTalk,
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

/* Main rule framework that drives processing of rules. Rules are evaluated in
sequence - 'pickFirst' clauses are only evaluated until a rule 'fires', 
'pickAll' clauses cause all rules within to be evaluated. */
resource 'infr' (0) {
	format0 {
		{
			pickFirst,
			{   /* Check that target volume has a valid System file, fall 
				   through to disallow install if not present */
				rlHasSystem,
				rlNoSystemError
			},
			pickFirst,
			{   /* Check that System on target volume is within our supported
				   range, also sets assertions for system versions */
				rlSystem7,		/* Check for System 7 or newer */
				rlSystem6_0_4,	/* Check for System 6.0.4 or newer */
				rlOldSystemError	/* Fall through to error if neither of the 
				                       above rules fired */
			},
			pickAll,
			{   /* Detect presence of ethernet cards and whether drivers need 
				   updating */
#if 0
				rlEtherTalkNB,	/* Detect and add packages for EtherTalk NB */
#endif
				rlSEthernet30,	/* Detect and add packages for SEthernet/30 */
				rlInstallENETDriver	/* Detect existing .ENET driver and install 
				                       update if needed */
			},
			pickFirst,
			{
				rlCCRD1_2,	/* Call CCRD 1 with RefCon=2 if .ENET driver is 
				               being installed */
				rlCCRD1_0,	/* Call CCRD 1 with RefCon=0, trigger install of 
				               EtherTalk, AppleTalk and .ENET driver and run
				               .ENET driver update action if it returns true */
				rlCCRD1_1,	/* Call CCRD 1 with RefCon=1, trigger install of
				               EtherTalk, AppleTalk and .ENET driver if it
				               returns true */
				rlInstallingENETDriver,
				rlEtherTalkPhase2_2_5_6,
				rlHasEtherTalkPhase2
			},
			pickFirst,
			{
				rlNetworkControlRequested,
				rlNetworkControl3_0_2,
				rlHasNetworkControl
			},
			pickFirst,
			{
				rlInstallingEtherTalk,
				rlUpdateNetworkControl
			},
			pickFirst,
			{	/* Install/update AppleTalk if necessary. The logic of this
			       seems a bit odd to me, but this is how Apple did it... */
				rlCHKA6_58130000,	/* Check AppleTalk version on System 6,
				                       trigger update if necessary */
				rlCHKD0_3A130000,	/* Check AppleTalk version on System 7,
				                       trigger update if necessary */
				rlInstallAppleTalk,	/* AppleTalk install was already
				                       triggered by another rule */
				rlLaterAppleTalkError	/* Otherwise there is already a newer
				                           AppleTalk installed */
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
