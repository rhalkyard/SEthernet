execute_process(COMMAND git describe --dirty=+ --always
                OUTPUT_VARIABLE GIT_REV
                ERROR_QUIET)
string(STRIP ${GIT_REV} GIT_REV)

if ("${GIT_REV}" STREQUAL "")
    set(GIT_REV "N/A")
endif()

set(VERSION "#define GIT_REV \"${GIT_REV}\"
")

if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/include/version.h)
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/include/version.h VERSION_)
else()
    set(VERSION_ "")
endif()

if (NOT "${VERSION}" STREQUAL "${VERSION_}")
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/include/version.h "${VERSION}")
endif()

add_library(version INTERFACE)
target_include_directories(version INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include/)
