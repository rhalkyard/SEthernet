SET WINCUPL_DIR=C:\WinCUPL

@REM This env var must be set for the compiler to work
SET LIBCUPL=%WINCUPL_DIR%\Shared\Atmel.dl

SET CUPLFLAGS=-j -a -l -e -x -f -b -m2 f1502isptqfp44

@REM PLCC device = p1502c44
@REM TQFP device = p1502t44
SET FITFLAGS=-CUPL -device p1502t44

%WINCUPL_DIR%\Shared\cupl.exe %CUPLFLAGS% se30-u3.pld
%WINCUPL_DIR%\WinCUPL\fitters\fit1502.exe -i se30-u3.tt2 %FITFLAGS%
