#include "ROMDefs.inc"
#include "declrom_macros.inc"
#include "sethernet30_board_defs.h"
#include "version.h"

/* Declaration ROM starts here. The sResource directory should be at the lowest
address */
directory:
    OSLstEntry 1, board_sResource
    OSLstEntry 128, eth_functional_sResource
    OSLstEntry 129, rom_functional_sResource
    EndLstEntry

board_sResource:
    OSLstEntry sRsrcType, board_sResource_rsrctype
    OSLstEntry sRsrcName, board_name
    DatLstEntry boardId, SETHERNET30_BOARDID
    OSLstEntry vendorInfo, vendor_info
    EndLstEntry

board_sResource_rsrctype:
    RsrcType catBoard, typeBoard, drSwBoard, drHwBoard

board_name:
    .ascii "SEthernet/30"
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
    .ascii " "
    .ascii "git:" 
    .ascii GIT_REV
    .byte 0

vendor_partnum:
    .ascii "SEthernet/30"
    .byte 0

vendor_date:
    .ascii __DATE__
    .ascii " "
    .ascii __TIME__
    .byte 0

eth_functional_sResource:
    OSLstEntry sRsrcType, eth_functional_sResource_rsrctype
    OSLstEntry sRsrcName, eth_functional_sResource_rsrcname
    OSLstEntry minorBaseOS, eth_functional_sResource_baseoffset
    EndLstEntry

eth_functional_sResource_rsrctype:
    RsrcType catNetwork, typeEtherNet, SETHERNET30_DRSW, SETHERNET30_DRHW

eth_functional_sResource_rsrcname:
    .ascii "Network SEthernet/30"
    .byte 0

eth_functional_sResource_baseoffset:
    .long 0x00000000

rom_functional_sResource:
    OSLstEntry sRsrcType, rom_functional_sResource_rsrctype
    OSLstEntry sRsrcName, rom_functional_sResource_rsrcname
    OSLstEntry minorBaseOS, rom_functional_sResource_baseoffset
    EndLstEntry

rom_functional_sResource_rsrctype:
    RsrcType catTest, typeEtherNet, SETHERNET30_ROM_DRSW, SETHERNET30_ROM_DRHW

rom_functional_sResource_rsrcname:
    .ascii "SEthernet/30 ROM"
    .byte 0

rom_functional_sResource_baseoffset:
    .long 0x000F0000

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
