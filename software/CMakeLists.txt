# Try to keep code size down
add_compile_options(-ffunction-sections -fno-exceptions)
add_link_options(-Wl,--gc-sections)

# Set up compiler warnings
add_compile_options(-Wall -Wextra -Wpedantic)

# Save asm output and add verbose annotations to aid debugging
add_compile_options(-save-temps=obj -fverbose-asm)

# Define DEBUG for debug builds
add_compile_definitions("$<$<CONFIG:DEBUG>:DEBUG>")

add_subdirectory(driver)
add_subdirectory(tools)
add_subdirectory(shared)
