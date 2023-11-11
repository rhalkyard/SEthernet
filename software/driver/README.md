# Driver

The source this directory can build a Slot Manager `.ENET` driver for an SE/30
card, or a non-Slot Manager `.ENET0` driver for an SE card.

While the code for the two drivers is identical save for some differences in
device initialization and interrupt handling, the way Mac OS ethernet drivers
work means that they need to be separate driver resources.

Slot Manager drivers use `.ENET` as the driver name in their resource header,
and are installed as `enet` resources with a Resource ID corresponding to the
Board ID that they operate with. These drivers can either be installed into the
System File, or as Extensions.

Non-Slot Manager drivers must be installed as traditional drivers (i.e. a `DRVR`
resource) called `.ENET0`, with a resource ID.

Idea: a single Extension that acts as both a container for a Slot Manager `enet`
resource, and an `INIT` that installs the non-Slot Manager `.ENET0` `DRVR`.
