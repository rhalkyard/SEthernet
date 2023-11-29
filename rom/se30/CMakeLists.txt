# Have to fake out an entrypoint otherwise we optimize to nothing!
add_compile_options(-nodefaultlibs -nostartfiles -e directory)

# Compile to an object file only, no linking
add_library(declrom OBJECT declrom.S)

# Use sethernet30_board_defs.h from shared library to keep hardware IDs in sync
# with software
target_link_libraries(declrom board_defs)

# Use objcopy to flatten the object file and patch in the CRC field with our
# script
add_custom_command(
    OUTPUT se30-u2.rom
    COMMAND ${CMAKE_SYSTEM_PREFIX_PATH}/bin/objcopy --output-target=binary $<TARGET_OBJECTS:declrom> se30-u2.rom
    COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/gencrc.py se30-u2.rom --output se30-u2.rom --pad 65536
    DEPENDS $<TARGET_OBJECTS:declrom>
)

add_custom_target(declrom_image ALL DEPENDS se30-u2.rom)
