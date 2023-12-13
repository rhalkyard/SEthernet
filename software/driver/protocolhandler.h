#pragma once

#include <ENET.h>

#include "driver.h"

protocolHandlerEntry* findPH(const driverGlobalsPtr theGlobals,
                             const unsigned short theProtocol);
OSStatus doEAttachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
OSStatus doEDetachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
void InitPHTable(driverGlobalsPtr theGlobals);