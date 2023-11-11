.include "ROMDefs.inc"
.include "declrom_macros.inc"

/* 
Identifier constants

These would originally have been assigned by Apple to hardware developers, but
these days I guess we just pick numbers that we like and hope they don't collide
with anything.
*/
my_boardId = 9635 /* Board identifier */
my_drSw = 9635 /* Functional sResource driver software interface ID */
my_drHw = 1 /* Functional sResourc driver hardware ID */

/* Declaration ROM starts here. The sResource directory should be at the lowest
address */
directory:
    OSLstEntry 1, board_sResource
    OSLstEntry 128, functional_sResource
    EndLstEntry

board_sResource:
    OSLstEntry sRsrcType, board_sResource_rsrctype
    OSLstEntry sRsrcName, board_name
    /* boardId values were assigned by Apple to hardware developers. I guess
    these days we just pick a number we like and hope we don't collide with
    anything. */
    DatLstEntry boardId, 9635
    OSLstEntry vendorInfo, vendor_info
    EndLstEntry

board_sResource_rsrctype:
    RsrcType catBoard, typeBoard, drSwBoard, drHwBoard

board_name:
    .ascii "SEthernet/30 Card"
    .byte 0

vendor_info:
    OSLstEntry vendorId, vendor_name
    OSLstEntry revLevel, vendor_rev
    OSLstEntry partNum, vendor_partnum
    OSLstEntry date, vendor_date
    EndLstEntry

vendor_name:
    .ascii "https://github.com/rhalkyard"
    .byte 0

vendor_rev:
    .ascii "Revision 0"
    .byte 0

vendor_partnum:
    .ascii "SEthernet/30"
    .byte 0

vendor_date:
    .ascii __DATE__ /* C Preprocessor macro, need to make sure this gets preprocessed */
    .byte 0

functional_sResource:
    OSLstEntry sRsrcType, functional_sResource_rsrctype
    OSLstEntry sRsrcName, functional_sResource_rsrcname
    OSLstEntry minorBaseOS, functional_sResource_baseoffset
    EndLstEntry

functional_sResource_rsrctype:
    RsrcType catNetwork, typeEtherNet, my_drSw, my_drHw

functional_sResource_rsrcname:
    .ascii "SEthernet/30 Ethernet"
    .byte 0

functional_sResource_baseoffset:
    .long 0x000E0000

/* Decalration ROM header */
    OSLstEntry 0 directory /* Offset to sResource directory */
    .long declRomEnd - directory /* Length from sResource directory to end of ROM */
    .space 4    /* CRC - this will get patched in later */
    .byte 1     /* ROM revision (values 1-9 are valid) */
    .byte 1     /* Declaration ROM format (must be 1 for Apple) */
    .long 0x5a932bc7    /* Magic number */
    .byte 0     /* Reserved zero byte */
    ByteLanes 0b1111    /* Byte lanes used by ROM */
/* ROM ends here, header must be at the highest address in ROM*/
declRomEnd:
