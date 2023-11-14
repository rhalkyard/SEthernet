add_compile_options(-ffunction-sections -fno-exceptions -Wall -Wextra -save-temps=obj)
add_link_options(-Wl,--gc-sections)
include_directories(include/)

add_subdirectory(driver)
add_subdirectory(tools)
