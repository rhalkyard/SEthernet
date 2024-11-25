INCLUDE(CheckIncludeFile)
CHECK_INCLUDE_FILE("ENET.h" HAVE_ENET_H)
IF(NOT HAVE_ENET_H)
    message(FATAL_ERROR "ENET.h not found. Are you sure you built Retro68 with Apple Universal Interfaces?")
ENDIF()

# Build drivers as code resources; PC-relative (no relocation necessary) flat
# binaries with no startup code
add_link_options(-Wl,--mac-flat -nostartfiles -e header_start)

set(DRIVER_SOURCES 
    driver.c
    header.S
    isr.c
    isrwrapper.S
    multicast.c
    protocolhandler.c
    readpacket.S
    util.c
    )

add_library(driver_control INTERFACE)
target_include_directories(driver_control INTERFACE include/)

# With the SE, the ethernet driver needs to be a 'DRVR' code resource. In theory
# we could create an INIT to load this into the driver table at startup, but for
# now we can just yeet it into the System file with ResEdit.
set(SE_RESOURCE SE_driver.resource)
add_executable(${SE_RESOURCE} ${DRIVER_SOURCES})
# Tune SE driver optimizations for 68000 specifically
target_compile_options(${SE_RESOURCE} PRIVATE -m68000 -mtune=68000)
# Workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105523 causing a
# spurious warning (introduced in GCC 12, fixed in GCC 14)
if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 12 AND
   CMAKE_C_COMPILER_VERSION VERSION_LESS 14)
   target_compile_options(${SE_RESOURCE} PRIVATE --param=min-pagesize=0)
endif()
target_compile_definitions(${SE_RESOURCE} PRIVATE TARGET_SE)
target_link_libraries(${SE_RESOURCE} enc624j600 driver_control board_defs version)
add_custom_command(
    OUTPUT SEthernet.bin
    COMMAND ${REZ} -I ${REZ_INCLUDE_PATH}
                    -I "$<TARGET_PROPERTY:version,INTERFACE_INCLUDE_DIRECTORIES>"
                    ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet.r
                    -o SEthernet.bin
                    -t rsrc
                    -c RSED
                    
    DEPENDS ${SE_RESOURCE} ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet.r)
add_custom_target(SEthernet ALL DEPENDS SEthernet.bin)
    
# SE30 driver is a lot more civilised. We create a code resource of type 'enet'
# with an ID matching our Board ID, and the Slot Manager and .ENET driver will
# take care of the rest. If we put the resource in a file of type 'comd', we can
# just drop it in the Extensions folder and (so long as we have run Network
# Software Installer 1.5 to update our .ENET driver) it'll get loaded.
set(SE30_RESOURCE SE30_driver.resource)
add_executable(${SE30_RESOURCE} ${DRIVER_SOURCES})
# Tune SE/30 driver optimizations for 68030 specifically
target_compile_options(${SE30_RESOURCE} PRIVATE -m68030 -mtune=68030)
# Workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105523 causing a
# spurious warning (introduced in GCC 12, fixed in GCC 14)
if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 12 AND
   CMAKE_C_COMPILER_VERSION VERSION_LESS 14)
   target_compile_options(${SE30_RESOURCE} PRIVATE --param=min-pagesize=0)
endif()
target_compile_definitions(${SE30_RESOURCE} PRIVATE TARGET_SE30)
# Link SE/30 driver against 68030-optimized version of enc624j600 library
target_link_libraries(${SE30_RESOURCE} enc624j600_030 driver_control board_defs version)
add_custom_command(
        OUTPUT SEthernet30.bin
        COMMAND ${REZ} -I ${REZ_INCLUDE_PATH}
                        -I "$<TARGET_PROPERTY:version,INTERFACE_INCLUDE_DIRECTORIES>"
                        -I "$<TARGET_PROPERTY:board_defs,INTERFACE_INCLUDE_DIRECTORIES>"
                        ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet30.r
                        -o SEthernet30.bin
                        -t comd
                        -c Enet
                        
        DEPENDS ${SE30_RESOURCE} ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet30.r)
add_custom_target(SEthernet30 ALL DEPENDS SEthernet30.bin)
