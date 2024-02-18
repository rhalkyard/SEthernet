/*
SEthernet and SEthernet/30 Driver

Copyright (C) 2023-2024 Richard Halkyard

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
