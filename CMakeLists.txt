cmake_minimum_required(VERSION 3.25)
project("SEthernet" C CXX ASM)

if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Retro68")
    message(FATAL_ERROR "SEthernet must be built using Retro68!")
endif()

add_subdirectory(pld)
add_subdirectory(rom)
add_subdirectory(software)
