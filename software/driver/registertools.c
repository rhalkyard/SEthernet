#include "enc624j600.h"
#include "enc624j600_registers.h"
#include "registertools.h"

#include <Devices.h>
#include <ENET.h>
#include <MacErrors.h>
#include <MacTypes.h>

OSErr doENCReadReg(driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    ENCRegister * r = (ENCRegister *) pb->csParam;
    r->value = ENC624J600_READ_REG(&theGlobals->chip, r->reg);
    r->value = SWAPBYTES(r->value);

    return noErr;
}

OSErr doENCWriteReg(driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    ENCRegister * r = (ENCRegister *) pb->csParam;
    ENC624J600_WRITE_REG(&theGlobals->chip, r->reg, SWAPBYTES(r->value));

    return noErr;
}

OSErr doENCReadPhy(driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    ENCRegister * r = (ENCRegister *) pb->csParam;
    r->value = enc624j600_read_phy_reg(&theGlobals->chip, r->reg);
    r->value = SWAPBYTES(r->value);

    return noErr;
}

OSErr doENCWritePhy(driverGlobalsPtr theGlobals, CntrlParamPtr pb) {
    ENCRegister * r = (ENCRegister *) pb->csParam;
    ENC624J600_WRITE_REG(&theGlobals->chip, r->reg, SWAPBYTES(r->value));
    enc624j600_write_phy_reg(&theGlobals->chip, r->reg, SWAPBYTES(r->value));

    return noErr;
}

OSErr doENCEnableLoopback(driverGlobalsPtr theGlobals) {
    enc624j600_enable_phy_loopback(&theGlobals->chip);
    return noErr;
}

OSErr doENCDisableLoopback(driverGlobalsPtr theGlobals) {
    enc624j600_disable_phy_loopback(&theGlobals->chip);
    return noErr;
}
