# Have to fake out an entrypoint otherwise we optimize to nothing!
add_compile_options(-nodefaultlibs -nostartfiles -e directory)

# Compile to an object file only, no linking
add_library(declrom OBJECT declrom.S)

# Use objcopy to flatten the object file and patch in the CRC field with our
# script
add_custom_command(
    OUTPUT declrom.bin
    COMMAND ${CMAKE_SYSTEM_PREFIX_PATH}/bin/objcopy --output-target=binary $<TARGET_OBJECTS:declrom> declrom.bin
    COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/gencrc.py declrom.bin --output declrom.bin --pad 65536
    DEPENDS $<TARGET_OBJECTS:declrom>
)

add_custom_target(declrom_image ALL DEPENDS declrom.bin)
