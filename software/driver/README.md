# Driver

The source this directory can build a Slot Manager `.ENET` driver for an SE/30
card, or a non-Slot Manager `.ENET0` driver for an SE card.

While the code for the two drivers is identical save for some differences in
device initialization and interrupt handling, the way Mac OS ethernet drivers
work means that they need to be separate driver resources.

## SEthernet/30

Slot Manager drivers such as the SEthernet/30 driver use `.ENET` as the driver
name in their resource header, and are installed as `enet` resources with a
Resource ID corresponding to the Board ID that they operate with. These drivers
can either be installed directly into the System File, or (with Network Software
Installer 1.5 or later) as Extensions with the type `comd`.

When an ethernet device is opened with `OpenSlot()`, the system `.ENET` 'driver
shell' searches `enet` resources for a driver whose resource ID matches the
Board ID of the slot, and loads that driver instead.

## SEthernet

Non-Slot Manager drivers must be installed as traditional drivers (i.e. a `DRVR`
resource) called `.ENET0`. This can either be done by manually installing the
resource into the System file, or loading the driver into the driver table at
run-time, for example, using an `INIT`.

Software that uses ethernet devices must try to load a `.ENET0` driver if no
Slot Manager devices are available. See Listing 1-11 in [IM:
Networking](https://www.vintageapple.org/inside_r/pdf/Networking_1994.pdf) for
details (and "Installing a Device Driver" in [IM:
Devices](https://www.vintageapple.org/inside_r/pdf/Devices_1994.pdf) for the
absurd song-and-dance routine that is installing and opening a device driver).
