add_compile_options(-nodefaultlibs -nostartfiles -ffreestanding)

# Compile to an object file only, no linking
add_library(declrom OBJECT declrom.S)

# Use sethernet30_board_defs.h from shared library to keep hardware IDs in sync
# with software
target_link_libraries(declrom board_defs version)

# Build the ROM image
add_custom_command(
    OUTPUT se30-u2.rom
    # Use objcopy to flatten the object file into a binary image
    COMMAND ${CMAKE_SYSTEM_PREFIX_PATH}/bin/objcopy 
        --output-target=binary 
        $<TARGET_OBJECTS:declrom>
        se30-u2.rom
    # Pad ROM to mapped size (64K), sanity-check header, and generate CRC field
    COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/gencrc.py 
        --output se30-u2.rom
        --pad 65536
        se30-u2.rom 
    # We use the bottom 64K of a 128K ROM, with the top address bit tied to
    # ground; append zero-padding so that the image size matches the full size
    # of the ROM.
    COMMAND truncate
        -s 128K 
        se30-u2.rom
    DEPENDS $<TARGET_OBJECTS:declrom>
)

add_custom_target(declrom_image ALL DEPENDS se30-u2.rom)
