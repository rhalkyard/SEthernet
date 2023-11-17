SET WINCUPL_DIR=C:\WinCUPL

REM This env var must be set for the compiler to work
SET LIBCUPL=%WINCUPL_DIR%\Shared\Atmel.dl

REM CUPL insists on its flags being mashed into a single string
REM     m2  Quine-McCluskey minimization
REM     l   Create listing
REM     x   Output expanded product terms in documentation file
REM     f   Output fuse plot in documentation file
REM     j   JEDEC output format
REM     n   Name output files based on input filename
REM     a   Create absolute file
REM     b   Berkely PLA output format
REM     e   Create expanded macro output file
REM     s   Simulate
SET FLAGS=-m2lxfjnabes

%WINCUPL_DIR%\Shared\cupl.exe %FLAGS% se30-u3.pld
%WINCUPL_DIR%\Shared\cupl.exe %FLAGS% se30-u4.pld
%WINCUPL_DIR%\Shared\cupl.exe %FLAGS% se30-bodge.pld
