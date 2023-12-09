add_compile_options(-ffunction-sections -fno-exceptions -fverbose-asm -Wall -Wextra -save-temps=obj)
add_compile_definitions("$<$<CONFIG:DEBUG>:DEBUG>")
add_link_options(-Wl,--gc-sections)

add_subdirectory(driver)
add_subdirectory(tools)
add_subdirectory(shared)
