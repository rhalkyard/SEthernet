#pragma once

#include "driver.h"

#include <Devices.h>
#include <ENET.h>
#include <MacErrors.h>
#include <MacTypes.h>

OSErr doENCReadReg(const driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCWriteReg(const driverGlobalsPtr theGlobals, const CntrlParamPtr pb);
OSErr doENCReadPhy(const driverGlobalsPtr theGlobals, CntrlParamPtr pb);
OSErr doENCWritePhy(const driverGlobalsPtr theGlobals, const CntrlParamPtr pb);
OSErr doENCEnableLoopback(const driverGlobalsPtr theGlobals);
OSErr doENCDisableLoopback(const driverGlobalsPtr theGlobals);
