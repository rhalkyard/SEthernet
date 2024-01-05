#!/usr/bin/env bash

set -euo pipefail

# hfsutils' text-conversion mode mangles special characters, even on files that
# are already in MacRoman encoding. Work around this by converting line endings
# and encoding externally (see text2mac.py) and then copying the file in 'raw'
# binary mode. Python's encoding conversion is clever enough that it can
# translate Unicode characters like •, ©, ƒ into their MacRoman equivalents.
#
# Usage: hcopy_text <source_file> <destination_file>
function hcopy_text() {
    local source="$1"
    local dest="$2"
    python3 text2mac.py "$source" - | hcopy -r - "$dest"
    # Have to manually set file type to 'TEXT' since we're not using
    # text-conversion mode. MPW won't touch source files that aren't of type
    # 'TEXT'.
    hattrib -t 'TEXT' "$dest"
}

function usage() {
    echo "Usage: $(basename $0) <build-directory> <output-image>" 1>&2
}

if [[ $# -ne 2 ]] ; then
    usage
    exit 1
fi

BUILDDIR="$1"
OUTPUTIMAGE="$2"

if [ ! -d "$BUILDDIR" ] ; then
    usage
    exit 1
fi

# Base image for build environment
# Assumptions:
#   - System 6.0.8 installed to ':System Folder'
#   - MPW 3.1 installed to ':MPW 3.1'
#   - InstallerTypes.r from Installer 3.4.3 SDK copied to ':MPW 3.1:Interfaces:RIncludes'
#   - ScriptCheck tool from Installer 3.4.3 SDK copied to ':MPW 3.1:Tools'
#   - MPW Shell set as startup application
#   - AutoQuit application at ':AutoQuit'
SYSTEM_IMAGE="images/buildenv.dsk.gz"

# 'Template' image for install disk
# Must contain:
#   - Installer version 3.4 application
#   - Network Software Installer 1.4.4 files under 'AppleTalk Files'
TEMPLATE_IMAGE="images/template.dsk.gz"

gunzip -c "${SYSTEM_IMAGE}" > buildenv.dsk
gunzip -c "${TEMPLATE_IMAGE}" > "${OUTPUTIMAGE}"

# Sources to copy into the build environment
SOURCE_FILES=(
    "atoms.r" 
    "code.r" 
    "comments.r" 
    "filespecs.r" 
    "identifiers.r"
    "misc.r" 
    "packages.r" 
    "rules.r" 
    "Build.mpw")

# Retro68's build system won't let us create files with spaces in their names,
# let alone special characters. Instead of just a list of files to copy, use an
# associative array mapping source MacBinary files to the filename we want it to
# have. Mapping a key to a blank name causes it to be copied as-is without any
# renaming.
declare -A BINARY_FILES=(
    ["$BUILDDIR/software/driver/SEthernet.bin"]=':SEthernet Files:SEthernet Resources'
    ["$BUILDDIR/software/driver/SEthernet30.bin"]=':SEthernet Files:SEthernet/30')

hmount buildenv.dsk >/dev/null

# Replace the Finder with Mini vMac's AutoQuit tool, which will shut down and
# quit Mini vMac when MPW exits
hdel ':System Folder:Finder'
hrename ':AutoQuit' ':System Folder:Finder'

# Delete the MPW worksheet to clear all the introductory stuff out it; we use
# the worksheet to grab our script output
hdel ':MPW 3.1:Worksheet'

# Delete the existing MPW UserStartup and replace it with our own
hdel ':MPW 3.1:UserStartup'
hcopy_text UserStartup.mpw ':MPW 3.1:UserStartup'

# Copy sources into the :Sources directory in the build environment
hmkdir ':Sources'
for f in ${SOURCE_FILES[@]}; do
    hcopy_text "$f" ":Sources:$(basename $f)"
done

humount buildenv.dsk

# Copy our built artifacts into the installer disk
hmount "${OUTPUTIMAGE}" >/dev/null
hmkdir 'SEthernet Files'
for f in ${!BINARY_FILES[@]}; do
    hcopy -m "$f" "${BINARY_FILES[$f]}"
done
humount "${OUTPUTIMAGE}"

# Run the build!
echo "Launching Mini vMac. Note that Mini vMac suspends itself if it is not the"
echo "foreground window! Use Control-S-A to speed it up a bit."
minivmac buildenv.dsk "${OUTPUTIMAGE}"

echo "Script output:"
hmount buildenv.dsk >/dev/null
hcopy -t ':MPW 3.1:Worksheet' -
humount buildenv.dsk

hmount "${OUTPUTIMAGE}" >/dev/null
echo
echo ""${OUTPUTIMAGE}" info:"
hvol
hls -lR
humount "${OUTPUTIMAGE}"

rm buildenv.dsk
