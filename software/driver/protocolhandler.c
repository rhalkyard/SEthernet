#include "protocolhandler.h"

#include "driver.h"

#include "enc624j600.h"

#if defined(DEBUG)
#include <Debugging.h>
#include <stdio.h>
extern char strbuf[255];
extern void ReadPacket();
extern void * header_start;
#endif

/* Find a protocol-handler table entry matching protocol number 'theProtocol'.
Returns a pointer to the entry. */
protocolHandlerEntry* findPH(driverGlobalsPtr theGlobals, unsigned short theProtocol) {
    for (unsigned short i = 0; i < numberOfPhs; i++) {
        if (theGlobals->protocolHandlers[i].ethertype == theProtocol) {
            return &theGlobals->protocolHandlers[i];
        }
    }
    return nil;
}

/*
EAttachPH call (a.k.a. Control with csCode=ENetAttachPH)

Attach a protocol handler to our driver.

Note that software MUST provide a protocol-handler routine for us to call here.
It is legal for software to pass in a nil pointer for this routine, indicating
that they will use ERead to read packets instead. However this feature seems to
be little-used, and this driver does not implement ERead.
*/
OSStatus doEAttachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  unsigned short theProtocol;
  protocolHandlerEntry *thePHSlot;

  theProtocol = pb->u.EParms1.eProtType;
  if (theProtocol > 0 && theProtocol <= 1500) {
    /* Not a valid ethertype */
  #if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. Invalid.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    return lapProtErr;
  }
  if (findPH(theGlobals, theProtocol) != nil) {
    /* Protocol handler already installed*/
#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. Protocol in use.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    return lapProtErr;
  }
  if (pb->u.EParms1.ePointer == nil) {
    /* TODO: support ERead */

#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install ENetRead handler for protocol %04x. Not implemented.", theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    return lapProtErr;
  }

  /* Find an empty slot in the protocol handler table */
  thePHSlot = findPH(theGlobals, phProtocolFree);

  if (thePHSlot == nil) {
#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Failed to install handler for protocol %04x. No free slots.", 
                        theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif
    return lapProtErr;
  } else {
  /* install the handler */
    thePHSlot->ethertype = theProtocol;
    thePHSlot->handler = (void *)pb->u.EParms1.ePointer;
    // thePHSlot->readPB = -1; /* not used */

#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Installing handler %08x for protocol %04x", 
                        (unsigned int) thePHSlot->handler, theProtocol);
    DebugStr((unsigned char *)strbuf);
#endif

    if (theGlobals->phCount == 0) {
      enc624j600_start(&theGlobals->chip);
    }
    theGlobals->phCount++;

    return noErr;
  }
}

/*
EDetachPH call (a.k.a. Control with csCode=ENetDetachPH)

Detach a protocol handler from our driver.

Once again, if we supported ERead we would need to do some cleanup of pending
calls, but we don't, so we don't.
*/
OSStatus doEDetachPH(driverGlobalsPtr theGlobals, const EParamBlkPtr pb) {
  protocolHandlerEntry * thePHSlot;

  thePHSlot = findPH(theGlobals, pb->u.EParms1.eProtType);
  if (thePHSlot != nil) {
    thePHSlot->ethertype = phProtocolFree;
    thePHSlot->handler = nil;
    // if (thePHSlot->readPB != -1){
    //     /* Cancel pending ERead calls */
    // }
    theGlobals->phCount--;
    if (theGlobals->phCount == 0) {
      enc624j600_suspend(&theGlobals->chip);
    }

#if defined(DEBUG)
    strbuf[0] = sprintf(strbuf+1, "Uninstalling handler for protocol %04x", 
                        pb->u.EParms1.eProtType);
    DebugStr((unsigned char *)strbuf);
#endif

    return noErr;
  } else
    return lapProtErr;
}

/*
Initialize the protocol handler table, called during initial Open routine.
*/
void InitPHTable(driverGlobalsPtr theGlobals) {
    for (unsigned short i = 0; i < numberOfPhs; i++) {
        theGlobals->protocolHandlers[i].ethertype = phProtocolFree;
        theGlobals->protocolHandlers[i].handler = nil;
        // theGlobals->protocolHandlers[i].readPB = -1; /* not used */
    }
}
