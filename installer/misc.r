#include "Types.r"
#include "SysTypes.r"

resource 'vers' (1, purgeable) {
	0x0,
	0x01,
	development,
	0x01,
	verUS,
	"0.0.1d1",
	"0.0.1d1, © Richard Halkyard, Apple Computer, Inc. 1984-2023"
};

resource 'vers' (2, purgeable) {
	0x0,
	0x01,
	development,
	0x01,
	verUS,
	"0.0.1d1",
	"SEthernet Installer 0.0.1d1"
};


resource 'ICON' (1) {
	$""
};

resource 'DLOG' (9000) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9000,
	"Message dialog"
};

resource 'DLOG' (9001) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9001,
	"Message dialog"
};

resource 'DLOG' (9002) {
	{68, 70, 248, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9002,
	"Message dialog"
};

resource 'DLOG' (9003) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9003,
	"Message dialog"
};

resource 'DLOG' (9004) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9004,
	"Message dialog"
};

resource 'DLOG' (9005) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9005,
	"Message dialog"
};

resource 'DLOG' (9006) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9006,
	"Message dialog"
};

resource 'DLOG' (9007) {
	{40, 70, 220, 470},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9007,
	"Message dialog"
};

resource 'DLOG' (9186) {
	{40, 70, 166, 370},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	9186,
	"Message dialog"
};

resource 'DITL' (9000) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{36, 91, 121, 382},
		StaticText {
			disabled,
			"The selected disk has no installed System.  AppleTalk cannot be installed on thi"
			"s disk.  Please click Switch Disk to choose a different disk or insert a floppy "
			"disk."
		},
		/* [4] */
		{39, 16, 103, 80},
		Icon {
			disabled,
			1000
		}
	}
};

resource 'DITL' (9001) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{20, 101, 133, 389},
		StaticText {
			disabled,
			"The selected disk has System 7 installed. The custom installation you have selec"
			"ted is only for use on disks where System 6 is installed. \nPlease click Switch D"
			"isk to choose a different disk or insert a floppy disk."
		},
		/* [4] */
		{44, 18, 108, 82},
		Icon {
			disabled,
			1000
		}
	}
};

resource 'DITL' (9002) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{26, 99, 126, 397},
		StaticText {
			disabled,
			"The selected disk has a System version of 6.0.3 or earlier.  AppleTalk can only "
			"be installed on System version 6.0.4 or later.  Please click Switch Disk to choo"
			"se a different disk or insert a floppy disk."
		},
		/* [4] */
		{37, 16, 101, 80},
		Icon {
			disabled,
			1000
		}
	}
};

resource 'DITL' (9003) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{20, 108, 127, 389},
		StaticText {
			disabled,
			"The selected disk has System 6 installed. The custom installation you have selec"
			"ted is only for use on disks where System 7 is installed.\nPlease click Switch Di"
			"sk to choose a different disk or insert a floppy disk."
		},
		/* [4] */
		{37, 18, 101, 82},
		Icon {
			disabled,
			1000
		}
	}
};

resource 'DITL' (9004) {
	{	/* array DITLarray: 5 elements */
		/* [1] */
		{137, 290, 157, 350},
		Button {
			enabled,
			"Cancel"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{137, 200, 157, 260},
		Button {
			enabled,
			"Continue"
		},
		/* [4] */
		{20, 117, 124, 390},
		StaticText {
			disabled,
			"The selected disk has a later version of AppleTalk than what you are about to in"
			"stall.  Click 'Cancel' to stop the installation, then click Switch Disk to choos"
			"e a different disk or insert a floppy disk.  Click 'Continue' to install anway."
		},
		/* [5] */
		{36, 22, 100, 86},
		Icon {
			disabled,
			1001
		}
	}
};

resource 'DITL' (9005) {
	{	/* array DITLarray: 5 elements */
		/* [1] */
		{137, 290, 157, 350},
		Button {
			enabled,
			"Cancel"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{137, 200, 157, 260},
		Button {
			enabled,
			"Continue"
		},
		/* [4] */
		{9, 115, 122, 388},
		StaticText {
			disabled,
			"The selected disk has a later version of ^0 than what you are about to install. "
			" Click 'Cancel' to stop the installation, then click Switch Disk to choose a dif"
			"ferent disk or insert a floppy disk.  Click 'Continue' to install anway."
		},
		/* [5] */
		{36, 22, 100, 86},
		Icon {
			disabled,
			1001
		}
	}
};

resource 'DITL' (9006) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"MORE"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{35, 98, 130, 358},
		StaticText {
			disabled,
			"Your machine has a non-Apple Ethernet card in addition to an Apple Ethernet card"
			".  Continuing this installation will destroy the driver for the non-Apple card."
		},
		/* [4] */
		{44, 18, 108, 82},
		Icon {
			disabled,
			1000
		}
	}
};

resource 'DITL' (9007) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{137, 250, 157, 310},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{0, 0, 0, 0},
		UserItem {
			disabled
		},
		/* [3] */
		{12, 70, 131, 345},
		StaticText {
			disabled,
			"QUIT the installer, remove any Apple Ethernet cards from your machine, and rerun"
			" the installer to update your non-Apple drivers. \nThen reinstall the Apple Ether"
			"net cards and rerun the installer to install the Apple drivers."
		}
	}
};

resource 'STR#' (0) {
	{	/* array StringArray: 17 elements */
		/* [1] */
		"the EtherTalk NB card driver",
		/* [2] */
		"the Ethernet NB card driver",
		/* [3] */
		"the Ethernet LC card driver",
		/* [4] */
		"the Quadra 900 Built-in Ethernet driver",
		/* [5] */
		"the Quadra 700 Built-in Ethernet driver",
		/* [6] */
		"the Quadra 950 Built-in Ethernet driver",
		/* [7] */
		"the TokenTalk NB Card driver",
		/* [8] */
		"the Token Ring 4/16 NB Card driver",
		/* [9] */
		"the multi-vendor TokenRing driver",
		/* [10] */
		"the multi-vendor Ethernet driver",
		/* [11] */
		"the Centris 650, Centris 610 or Quadra 800 Built-in Ethernet driver",
		/* [12] */
		"the Quadra 840AV Built-in Ethernet driver",
		/* [13] */
		"the Centris 660AV Built-in Ethernet driver",
		/* [14] */
		"the Ethernet NB Twisted-Pair card driver",
		/* [15] */
		"the Ethernet LC card driver",
		/* [16] */
		"the Ethernet Comm Slot card driver",
		/* [17] */
		"the Ethernet Comm Slot card driver"
	}
};
