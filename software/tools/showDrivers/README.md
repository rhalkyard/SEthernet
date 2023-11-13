# showDrivers

A quick and dirty tool to list the entries in the system's driver table.

## Table columns

**Unit**: Driver unit number

**RefNum**: Driver reference number used for Device Manager calls (1's complement
of unit number)

**Flags**: Driver flags (explained below)

**DRVRAddr**: Address of driver's `DRVR` resource in memory

**Name**: Driver name

## Driver flags

Lowercase letter means flag is not set, uppercase letter means flag is set.

**L**: Driver is locked in memory

**T**: Driver performs periodic tasks

**G**: Driver needs to be called before application heap initialization

**S**: Driver responds to `Status` call

**C**: Driver responds to `Control` call

**W**: Driver responds to `Write` call

**R**: Driver responds to `Read` call

**A**: Driver is currently executing a request

**H**: Driver is referenced through a Handle, rather than a Pointer

**O**: Driver is open

**V**: Driver has marked itself as virtual-memory safe
