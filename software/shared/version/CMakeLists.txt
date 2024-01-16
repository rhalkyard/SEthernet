execute_process(COMMAND git describe --dirty=+ --always
                OUTPUT_VARIABLE GIT_REV
                ERROR_QUIET)
string(STRIP ${GIT_REV} GIT_REV)

if ("${GIT_REV}" STREQUAL "")
    set(GIT_REV "N/A")
endif()

# Version information set here should be compatible with 'vers' resource type:
#
# VERSION_MAJOR: major version number in BCD format
# VERSION_MINOR: minor version number components in BCD format
# VERSION_DEVSTAGE: development stage (see VERSION_DEVSTAGE_* for valid values)
# VERSION_INTERNAL_ID: build ID for non-final development stages, should be 0
#                      for final builds
# VERSION_SHORT: short version string of form
#                   <MAJOR>.<MINOR1>.<MINOR2><DEVSTAGE><INTERNAL_ID>
#                where <DEVSTAGE> is 'd', 'a', 'b', or empty for final builds
#
# For example:
#   VERSION_MAJOR 0x05
#   VERSION_MINOR 0x42
#   VERSION_DEVSTAGE VERSION_DEVSTAGE_BETA
#   VERSION_INTERNAL_ID 0x4
#   should have a VERSION_SHORT of 5.4.2b4
set(VERSION "
#define GIT_REV \"${GIT_REV}\"
#define VERSION_SHORT \"0.0.1d0\"
#define VERSION_LONG VERSION_SHORT \" git:\" GIT_REV
#define VERSION_MAJOR 0x00
#define VERSION_MINOR 0x01
#define VERSION_DEVSTAGE VERSION_DEVSTAGE_DEVELOPMENT
#define VERSION_INTERNAL_ID 0x00

#define VERSION_DEVSTAGE_DEVELOPMENT 0x20
#define VERSION_DEVSTAGE_ALPHA 0x40
#define VERSION_DEVSTAGE_BETA 0x60
#define VERSION_DEVSTAGE_FINAL 0x80
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
