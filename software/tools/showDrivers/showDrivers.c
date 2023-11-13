/* Quick 'n dirty tool to show the contents of the driver table */

#include <Devices.h>
#include <LowMem.h>
#include <Resources.h>
#include <stdio.h>
#include <string.h>

/* Convert a length-prefixed Pascal string at pstr into a null-terminated C
string at cstr */
unsigned char pToCStr(Str255 pstr, char *cstr) {
    const unsigned char len = pstr[0];
    memmove (cstr, pstr+1, len);
    cstr[len] = '\0';
    return len;
}

int main(int argc, char ** argv) {
    short tableSize = LMGetUnitTableEntryCount();
    Ptr tableBase = LMGetUTableBase();
    DCtlHandle dCtlH;
    short numDrivers = 0;
    char strbuf[256];

    printf("Driver table at 0x%08x, length %d entries\n", (unsigned int) tableBase, tableSize);
    printf("Unit RefNum Flags       DRVRAddr   Name\n");
    for (short unitNum = 0; unitNum < tableSize; unitNum++) {
        short refNum = ~unitNum;
        char flagStr[] = "ltgscwrahov";
        dCtlH = GetDCtlEntry(refNum);
        if (dCtlH != nil) {
            short flags = (*dCtlH)->dCtlFlags;
            Ptr driver; 
            numDrivers++;

            if (flags & dNeedLockMask) {
                flagStr[0] = 'L';
            }
            if (flags & dNeedTimeMask) {
                flagStr[1] = 'T';
            }
            if (flags & dNeedGoodByeMask) {
                flagStr[2] = 'G';
            }
            if (flags & dStatEnableMask) {
                flagStr[3] = 'S';
            }
            if (flags & dCtlEnableMask) {
                flagStr[4] = 'C';
            }
            if (flags & dWritEnableMask) {
                flagStr[5] = 'W';
            }
            if (flags & dReadEnableMask) {
                flagStr[6] = 'R';
            }
            if (flags & drvrActiveMask) {
                flagStr[7] = 'A';
            }
            if (flags & dRAMBasedMask) {
                /* Does not actually indicate whether driver is in RAM or not!!!
                Indicates if the driver is referenced by a pointer (0) or a
                handle (1) */
                flagStr[8] = 'H';                
                driver = * (Handle) ((*dCtlH)->dCtlDriver);
                LoadResource( (Handle) driver);
            } else {
                driver = (*dCtlH)->dCtlDriver;
            }
            if (flags & dOpenedMask) {
                flagStr[9] = 'O';
            }
            if (flags & dVMImmuneMask) {
                flagStr[10] = 'V';
            }

            /* Driver name is 18 bytes from the start of the driver */
            pToCStr((unsigned char *) driver + 18, strbuf);
            printf("%4d   %4d %s 0x%08x %s\n", unitNum, refNum, flagStr, (unsigned int) driver, strbuf);

            if (numDrivers > 0 && numDrivers % 20 == 0) {
                printf("Press RETURN for more...\n");
                getchar();
            }
        }
    }

    printf("\n%d total drivers\n", numDrivers);
    printf("Press RETURN to exit...\n");
    getchar();

    return 0;
}