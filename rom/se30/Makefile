RETRO68_HOME=$(HOME)/Retro68-build
RETRO68_BIN=$(RETRO68_HOME)/toolchain/bin
CC=$(RETRO68_BIN)/m68k-apple-macos-gcc
AS=$(CC) # use gcc for assembly in order to use the preprocessor
OBJCOPY=$(RETRO68_BIN)/m68k-apple-macos-objcopy
PYTHON3=/usr/bin/python3

ASFLAGS=-c -x assembler-with-cpp -nodefaultlibs -nostartfiles -e directory

all: sethernet30.rom

clean:
	rm -f *.o *.o.gdb sethernet30.rom

.PHONY: all clean

.DELETE_ON_ERROR:

sethernet30.rom: declrom.o
	$(OBJCOPY) $< $@ --output-target=binary
	python3 gencrc.py $@ --output $@ --pad 65536 --verbose
