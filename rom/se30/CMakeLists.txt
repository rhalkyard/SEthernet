add_compile_options(-nodefaultlibs -nostartfiles -ffreestanding)

# Compile to an object file only, no linking
add_library(declrom OBJECT declrom.S)

# Use sethernet30_board_defs.h from shared library to keep hardware IDs in sync
# with software
target_link_libraries(declrom board_defs version)

# Generate a 'library' containing the ROM data formatted as a C header, for use
# by firmware update tools.
add_library(declrom_header INTERFACE)
# The header is generated, so we have to tell CMake to find it in our build
# tree, not the source
target_include_directories(declrom_header INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include/)


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
    DEPENDS $<TARGET_OBJECTS:declrom>
)

# Build a header-ified version of the ROM image
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/se30-u2.h
    COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/include
    COMMAND xxd -i se30-u2.rom ${CMAKE_CURRENT_BINARY_DIR}/include/se30-u2.h
    DEPENDS se30-u2.rom
)

add_custom_target(declrom_image ALL 
    DEPENDS se30-u2.rom
        ${CMAKE_CURRENT_BINARY_DIR}/include/se30-u2.h)
