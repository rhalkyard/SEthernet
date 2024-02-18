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

#include <ENET.h>

#include "driver.h"

protocolHandlerEntry* findPH(const driverGlobalsPtr theGlobals,
                             const unsigned short theProtocol);
OSStatus doEAttachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
OSStatus doEDetachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb);
void InitPHTable(driverGlobalsPtr theGlobals);
