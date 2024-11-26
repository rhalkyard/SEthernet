find_program(WINE wine)
set(WINCUPL_PATH ~/.wine/drive_c/Wincupl CACHE PATH "WinCUPL installation path")

find_file(CUPL_EXE cupl.exe ${WINCUPL_PATH}/Shared/)
find_file(CUPL_DL cupl.dl ${WINCUPL_PATH}/Shared/)
find_file(FIT1502_EXE fit1502.exe ${WINCUPL_PATH}/WinCupl/Fitters/)

# Drive WinCUPL through WINE to compile CPLD equations. Yeah. Really.
# Arguments:
#   pldfile:    CUPL source file
#   device:     -device argument given to FIT1502.exe
function(add_cpld pldfile device)
    cmake_path(GET pldfile STEM stem)

    # Compile CUPL to Berkeley PLA netlist
    add_custom_command(
        OUTPUT ${stem}.tt2
        BYPRODUCTS ${stem}.lst ${stem}.pla ${pldfile}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${pldfile}

        # CUPL tends to crash if the source is not in the working directory
        COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/${pldfile} ./
        COMMAND ${WINE} ${CUPL_EXE} -l -b -m4 -u ${CUPL_DL} ${pldfile}
    )

    # Run the fitter
    add_custom_command(
        OUTPUT ${stem}.jed
        BYPRODUCTS ${stem}.fit ${stem}.io ${stem}.pin ${stem}.tt3
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${stem}.tt2
        COMMAND ${WINE} ${FIT1502_EXE} ${stem}.tt2 -CUPL -device ${device}
    )

    add_custom_target(pld_${stem} DEPENDS ${stem}.jed)
    add_dependencies(pld pld_${stem})
endfunction()

if(${WINE} STREQUAL "WINE-NOTFOUND")
    message(NOTICE "Wine not found, skipping PLD targets")
else()
    if(${CUPL_EXE} STREQUAL "CUPL_EXE-NOTFOUND")
        message(NOTICE "Wine was found but WinCUPL is not installed, skipping PLD targets")
    else()
        add_custom_target(pld ALL)
    endif()
endif()

add_subdirectory(se)
add_subdirectory(se30)
