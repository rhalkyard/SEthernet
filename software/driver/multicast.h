#pragma once

#include <ENET.h>

#include "driver.h"

multicastEntry* findMulticastEntry(const driverGlobalsPtr theGlobals,
                                   const hwAddr *address);
OSStatus doEAddMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
OSStatus doEDelMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
