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

#include "enc624j600.h"
#include "enc624j600_registers.h"
#include "registertools.h"

#include <Devices.h>
#include <ENET.h>
#include <MacErrors.h>
#include <MacTypes.h>

OSErr doENCReadReg(const driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    encRegister * r = (encRegister *) pb->csParam;
    r->value = ENC624J600_READ_REG(&theGlobals->chip, r->reg);
    r->value = SWAPBYTES(r->value);

    return noErr;
}

OSErr doENCWriteReg(const driverGlobalsPtr theGlobals, const CntrlParamPtr pb) {
    encRegister * r = (encRegister *) pb->csParam;
    ENC624J600_WRITE_REG(&theGlobals->chip, r->reg, SWAPBYTES(r->value));

    return noErr;
}

OSErr doENCReadPhy(const driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    encRegister * r = (encRegister *) pb->csParam;
    r->value = enc624j600_read_phy_reg(&theGlobals->chip, r->reg);
    r->value = SWAPBYTES(r->value);

    return noErr;
}

OSErr doENCWritePhy(const driverGlobalsPtr theGlobals, const CntrlParamPtr pb) {
    encRegister * r = (encRegister *) pb->csParam;
    ENC624J600_WRITE_REG(&theGlobals->chip, r->reg, SWAPBYTES(r->value));
    enc624j600_write_phy_reg(&theGlobals->chip, r->reg, SWAPBYTES(r->value));

    return noErr;
}

OSErr doENCEnableLoopback(const driverGlobalsPtr theGlobals) {
    enc624j600_enable_phy_loopback(&theGlobals->chip);
    return noErr;
}

OSErr doENCDisableLoopback(const driverGlobalsPtr theGlobals) {
    enc624j600_disable_phy_loopback(&theGlobals->chip);
    return noErr;
}
