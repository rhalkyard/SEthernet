# Installer

## Building an installer

You will need:

- [hfsutils](https://www.mars.org/home/rob/proj/hfs/)

- [Python 3](https://www.python.org)

- [Mini vMac](https://www.gryphel.com/c/minivmac/index.html)

- A relatively modern (4.0 or newer) version of the Bash shell

Build the SEthernet source tree as per usual, and then run `build.sh`, giving it
the location of the build tree, and the name of the disk image to produce, e.g.
`./build.sh ../build install.dsk`. The build script will launch MPW within Mini
vMac, build an installer disk image, and (hopefully) quit without any
intervention. If something goes wrong, Mini vMac will remain open, and the MPW
Worksheet will show the diagnostic output from the build. Good luck figuring it
out!

## Files

### Installer resources
- `atoms.r`: Specifications for installer 'atoms' - an atom can add or remove a
  file (`infa`) or a resource (`inra`), or run custom-code 'actions' at install
  time (`inaa`)

- `code.r`: Code resources run by action atoms and install rules

- `comments.r`: Installer 'comments' providing information about install
  packages

- `filespecs.r`: Specifications of source and destination files, referenced by
  file and resource atoms

- `misc.r`: Miscellaneous resources not directly referenced by the Installer

- `packages.r`: Packages are collections of atoms that can be selected either
  automatically by rules, or manually through the Custom Install interface

- `rules.r`: Rules processed at startup that select a default set of packages

### Build System

- `Build.mpw`: MPW shell script that compiles the Installer script resources and
  post-processes them with ScriptCheck

- `UserStartup.mpw`: MPW UserStartup script used to trigger autommated builds

- `build.sh`: Bash script that automates the installer build process using Mini
  vMac

- `text2mac.py`: Helper script to convert line endings and encodings of text
  files

- `images/buildenv.dsk.gz`: Build environment - System 6.0.8, MPW 3.1, Installer
  SDK 3.4

- `images/template.dsk.gz`: Installer disk template - contains AppleTalk support
  components from Network Software Installer 1.4.4, and Installer application.

### Output files

- `installer.dsk.gz`: SEthernet install disk
