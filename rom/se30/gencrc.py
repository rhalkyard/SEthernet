#!/usr/bin/env python3

import argparse
import itertools
import struct
import sys

SRESOURCE_HEADER_MAGIC = 0x5a932bc7

def checksum(data):
    sum = 0
    for byte in data:
        sum = ((sum << 1) & 0xffffffff) | (sum >> (31)) # 32-bit Rotate Left
        sum = (sum + byte) & 0xffffffff # Ensure 32-bit add with overflow

    return sum

def main():
    parser = argparse.ArgumentParser(description='Tool for sanity-checking declaration ROM headers and writing the CRC field.')
    parser.add_argument('rom_image', help='Declaration ROM image')
    parser.add_argument('--output', '-o', type=str, help='Output ROM image')
    parser.add_argument('--pad', '-p', type=int, metavar='SIZE', help='Prepend zeros to pad image out to SIZE bytes')
    parser.add_argument('--verbose', '-v', action='store_true', help='Show ROM information.')
    args = parser.parse_args()

    if args.pad is not None and not args.output:
        parser.error('Cannot add padding (--pad/-p) without an output file (--output/-o) to write to!')

    with open(args.rom_image, 'rb') as f:
        rom = f.read()
        header = struct.unpack('>LLLBBLBB', rom[-20:]) # Unpack as big-endian
        file_end = len(rom)

        # directory_offset is a 24 bit signed value; do some bit twiddling to sign-extend it
        directory_offset = header[0] if not (header[0] & 0x800000) else header[0] - 0x1000000
        crc_length = header[1]
        crc = header[2]
        romRevision = header[3]
        romFormat = header[4]
        magic = header[5]
        reservedZero = header[6]
        byteLanes = header[7]
        
        if magic != SRESOURCE_HEADER_MAGIC:
            print("Magic number is wrong (0x{:08x}, should be 0x{:08x})".format(magic, SRESOURCE_HEADER_MAGIC), file=sys.stderr)
            sys.exit(1)

        if reservedZero != 0:
            print("Reserved zero value before ByteLanes is nonzero.", file=sys.stderr)
            sys.exit(1)

        if (byteLanes & 0x0f) != ((~byteLanes >> 4) & 0x0f):
            print("Invalid ByteLanes value 0x{:02x}.".format(byteLanes), file=sys.stderr)
            print("Low and high nybbles must be the inverse of each other", file=sys.stderr)
            sys.exit(1)

        # directory_offset value is relative to its location in the header (20 bytes from the end)
        directory_location = (file_end - 20) + directory_offset

        if directory_location < 0 or directory_location > file_end:
            print("Bad directory offset {} points to address outside of ROM image.".format(directory_offset), file=sys.stderr)
            sys.exit(1)

        if (directory_location + crc_length) != file_end:
            print("CRC length value {} does not match directory location and size of ROM image ({}).".format(crc_length, file_end), file=sys.stderr)
            sys.exit(1)

        if args.verbose or not args.output:
            print("Directory at address 0x{:x} (offset {})".format(directory_location, directory_offset))
            print("CRC length: {} bytes".format(crc_length))
            print("CRC: 0x{:08x}".format(crc))
            print("ROM revision: {}".format(romRevision))
            print("ROM format: {}".format(romFormat))
            print("Byte lanes: 0x{:02x}".format(byteLanes))

        crcdata = rom[file_end - crc_length:]
        # CRC calculation treats checksum field as zero bytes
        calc_crc = checksum(itertools.chain(crcdata[0:-12], [0]*4, crcdata[-8:]))

        if crc != calc_crc and not args.output:
            print("CRC field 0x{:08x} does not match calculated CRC 0x{:08x}".format(crc, calc_crc), file=sys.stderr)
            print("Use --output argument to write new CRC value", file=sys.stderr)
            sys.exit(1)

        if args.output and args.verbose and crc != calc_crc:
            print("CRC field updated to 0x{:08x}".format(calc_crc))

    if args.pad is not None and args.pad < len(rom):
        print('Cannot pad a ROM image to smaller than its actual size!', file=sys.stderr)
        sys.exit(1)

    if args.pad is not None and args.verbose:
        print('Adding {} bytes of padding to {} bytes of data'.format(args.pad - len(rom), len(rom)))

    if args.output:
        with open(args.output, 'wb') as f:
            if args.pad is not None:
                # Prepend with zero padding to reach desired size
                f.seek(args.pad - len(rom))

            f.write(rom[0:-12])
            f.write(struct.pack('>L', calc_crc))
            f.write(rom[-8:])

if __name__ == '__main__':
    main()
