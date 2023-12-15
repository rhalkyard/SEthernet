# Try to keep code size down. This is especially important as the driver header
# uses 16 bit signed offsets - i.e. our driver entrypoints must be within 32kb
# of the header. Compiling with -ffunction-sections and linking with
# --gc-sections means that unused functions can be identified and removed at
# link-time.
add_compile_options(-ffunction-sections -fno-exceptions)
add_link_options(-Wl,--gc-sections)

# Set up compiler warnings
add_compile_options(-Wall -Wextra -Wpedantic)

# Save asm output and add verbose annotations to aid debugging
add_compile_options(-save-temps=obj -fverbose-asm)

# Define DEBUG for debug builds
add_compile_definitions("$<$<CONFIG:Debug>:DEBUG>")

add_compile_options(# Add 'debug-safe' optimisations for debug builds - the
                    # unoptimized output is enormous and extremely stupid. Since
                    # we're doing all our debugging in machine code, disable a
                    # few more optimizations below to generate more readable
                    # code.
                    "$<$<CONFIG:Debug>:-Og>" 
                    # Emit LINK/UNLK even when a frame pointer is not used, to
                    # make Macsbug's SC6 command more useful.
                    "$<$<CONFIG:Debug>:-fno-omit-frame-pointer>"
                    # Always remove function call args from the stack
                    # immediately after the call, so that the stack is easier to
                    # follow.
                    "$<$<CONFIG:Debug>:-fno-defer-pop>"
                    # Keep all function-prologue stuff at the beginning of the
                    # function, rather than deferring it to time-of-use.
                    "$<$<CONFIG:Debug>:-fno-shrink-wrap>")



add_subdirectory(driver)
add_subdirectory(tools)
add_subdirectory(shared)
