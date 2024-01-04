#!/usr/bin/env python3

"""
Quick n' dirty tool to convert a UTF-8 text file with Unix (LF) or Windows
(CRLF) line endings into MacRoman with old-Mac (CR) line-endings.
"""

import argparse
import os
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input')
    parser.add_argument('output')
    args = parser.parse_args()

    if args.input == '-':
        infile = sys.stdin
    else:
        # Assume system default input encoding
        infile = open(args.input, 'r')

    if args.output == '-':
        outfile = os.fdopen(sys.stdout.fileno(), 'wb')
    else:
        outfile = open(args.output, 'wb')

    data = infile.read()
    infile.close()

    if '\r\n' in data:
        data = data.replace('\r\n', '\r')
    else:
        data = data.replace('\n', '\r')

    # Encode output data as macroman
    outfile.write(data.encode('macroman'))

    outfile.close()

if __name__ == '__main__':
    main()
