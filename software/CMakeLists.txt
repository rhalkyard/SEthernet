cmake_minimum_required(VERSION 3.25)
project("SEthernet" C CXX ASM)

add_compile_options(-ffunction-sections -Wall -Wextra -Og -g -save-temps=obj)
add_link_options(-Wl,--gc-sections)
include_directories(include/)

add_subdirectory(driver)
