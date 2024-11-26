include(ExternalProject)

find_package(Git REQUIRED)
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

    # Compile CUPL to netlist
    add_custom_command(
        OUTPUT ${stem}.tt2
        BYPRODUCTS ${stem}.lst ${stem}.pla ${pldfile}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${pldfile}

        # CUPL tends to crash if the source is not in the working directory
        COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/${pldfile} ./
        COMMAND ${WINE} ${CUPL_EXE} -l -b -m4 -u ${CUPL_DL} ${pldfile}
    )

    # Run the fitter on the netlist
    add_custom_command(
        OUTPUT ${stem}.jed
        BYPRODUCTS ${stem}.fit ${stem}.io ${stem}.pin ${stem}.tt3
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${stem}.tt2
        COMMAND ${WINE} ${FIT1502_EXE} ${stem}.tt2 -CUPL -device ${device}
    )

    # Use prjbureau to generate a JTAG SVF file without having to mess with ATMISP
    add_custom_command(
        OUTPUT ${stem}.svf
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${stem}.jed prjbureau
        COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${PRJBUREAU_DIR} 
            ${PRJBUREAU_DIR}/venv/bin/python3 -m util.fuseconv ${stem}.jed ${stem}.svf
    )

    add_custom_target(pld_${stem} DEPENDS ${stem}.svf)
    add_dependencies(pld pld_${stem})
endfunction()

if(${WINE} STREQUAL "WINE-NOTFOUND")
    message(NOTICE "Wine not found, skipping PLD targets")
else()
    message(STATUS "Found Wine: ${WINE}")
    if(${CUPL_EXE} STREQUAL "CUPL_EXE-NOTFOUND")
        message(NOTICE "WinCUPL not found, skipping PLD targets")
    else()
        message(STATUS "Found CUPL: ${CUPL_EXE}")
        add_custom_target(pld ALL)

        # prjbureau is 'experimental' and deliberately not packaged. Clone the
        # repo and set up a virtualenv to run it in
        set(PRJBUREAU_DIR ${CMAKE_CURRENT_BINARY_DIR}/prjbureau)
        ExternalProject_Add(
            prjbureau
            SOURCE_DIR ${PRJBUREAU_DIR}
            GIT_REPOSITORY https://github.com/whitequark/prjbureau.git
            GIT_TAG 82b94c6776144ceb315e0879a0222b7bea24a067
            CONFIGURE_COMMAND ""
            BUILD_COMMAND 
                python3 -m virtualenv ${PRJBUREAU_DIR}/venv && 
                ${PRJBUREAU_DIR}/venv/bin/pip install bitarray
            INSTALL_COMMAND ""
        )
    endif()
endif()

add_subdirectory(se)
add_subdirectory(se30)
