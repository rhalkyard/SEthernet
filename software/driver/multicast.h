#pragma once

#include <ENET.h>

#include "driver.h"

multicastEntry* findMulticastEntry(const driverGlobalsPtr theGlobals,
                                   const Byte address[6]);
OSStatus doEAddMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
OSStatus doEDelMulti(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
