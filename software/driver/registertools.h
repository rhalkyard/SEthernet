#pragma once

#include "driver.h"

#include <Devices.h>
#include <ENET.h>
#include <MacErrors.h>
#include <MacTypes.h>

OSErr doENCReadReg(driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCWriteReg(driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCReadPhy(driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCWritePhy(driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCEnableLoopback(driverGlobalsPtr theGlobals);
OSErr doENCDisableLoopback(driverGlobalsPtr theGlobals);
