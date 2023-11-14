#!/usr/bin/env bash
set -e

if [ -z "${RETRO68_HOME+x}" ]; then
    if [ -d "${HOME}/Retro68-build" ]; then
        RETRO68_HOME="${HOME}/Retro68-build"
    else
        echo "Could not find Retro68! Please set RETRO68_HOME to your Retro68 install location" >&2
        exit 1
    fi
fi

mkdir -p build
cmake -S . -B build/ -DCMAKE_TOOLCHAIN_FILE="${RETRO68_HOME}/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake"
cmake --build build/
