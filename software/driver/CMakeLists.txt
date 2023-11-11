# Build drivers as code resources; PC-relative (no relocation necessary) flat
# binaries with no startup code
add_compile_options(-mpcrel -ffreestanding)
add_link_options(-Wl,--mac-flat -nodefaultlibs -nostartfiles -e header_start)

set(DRIVER_SOURCES header.S driver.c enc624j600.c isr.c multicast.c protocolhandler.c registertools.c util.c)

# With the SE, the ethernet driver needs to be a 'DRVR' code resource. In theory
# we could create an INIT to load this into the driver table at startup, but for
# now we can just yeet it into the System file with ResEdit.
set(SE_RESOURCE DRVR_69.resource)
add_executable(${SE_RESOURCE} ${DRIVER_SOURCES})
target_compile_options(${SE_RESOURCE} PRIVATE -m68000)
target_compile_definitions(${SE_RESOURCE} PRIVATE TARGET_SE)
add_custom_command(
    OUTPUT SEthernet.bin
    COMMAND ${REZ} -I ${REZ_INCLUDE_PATH}
                    ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet.r
                    -o SEthernet.bin
                    -t rsrc
                    -c RSED
                    
    DEPENDS ${SE_RESOURCE} ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet.r)
add_custom_target(SEthernet ALL DEPENDS SEthernet.bin)
    
# SE30 driver is a lot more civilised. We create a code resource of type 'enet'
# with an ID matching our Board ID, and the Slot Manager and .ENET driver will
# take care of the rest. If we put the resource in a file of type 'comd', we can
# just drop it in the Extensions folder and it'll get loaded.
set(SE30_RESOURCE enet_9635.resource)
add_executable(${SE30_RESOURCE} ${DRIVER_SOURCES})
target_compile_options(${SE30_RESOURCE} PRIVATE -m68030)
target_compile_definitions(${SE30_RESOURCE} PRIVATE TARGET_SE30)
add_custom_command(
        OUTPUT SEthernet30.bin
        COMMAND ${REZ} -I ${REZ_INCLUDE_PATH}
                        ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet30.r
                        -o SEthernet30.bin
                        -t comd
                        -c Enet
                        
        DEPENDS ${SE_RESOURCE} ${CMAKE_CURRENT_SOURCE_DIR}/SEthernet.r)
add_custom_target(SEthernet30 ALL DEPENDS SEthernet30.bin)

