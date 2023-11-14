#include "protocolhandler.h"

#include "driver.h"

/* Find a protocol-handler table entry matching protocol number 'theProtocol'.
Returns a pointer to the entry. */
protocolHandlerEntry* findPH(driverGlobalsPtr theGlobals, unsigned short theProtocol) {
    for (int i = 0; i < numberOfPhs; i++) {
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
    return lapProtErr;
  }
  if (findPH(theGlobals, theProtocol) != nil) {
    /* Protocol handler already installed*/
    return lapProtErr;
  }
  if (pb->u.EParms1.ePointer == nil) {
    /* TODO: support ERead */
    return lapProtErr;
  }

  /* Find an empty slot in the protocol handler table */
  thePHSlot = findPH(theGlobals, phProtocolFree);

  if (thePHSlot == nil) {
    return lapProtErr;
  } else {
  /* install the handler */
    thePHSlot->ethertype = theProtocol;
    thePHSlot->handler = (void *)pb->u.EParms1.ePointer;
    // thePHSlot->readPB = -1; /* not used */

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
    thePHSlot->ethertype = 1;
    // if (thePHSlot->readPB != -1){
    //     /* Cancel pending ERead calls */
    // }
    return noErr;
  } else
    return lapProtErr;
}

/*
Initialize the protocol handler table, called during initial Open routine.
*/
void InitPHTable(driverGlobalsPtr theGlobals) {
    for (int i = 0; i < numberOfPhs; i++) {
        theGlobals->protocolHandlers[i].ethertype = phProtocolFree;
        theGlobals->protocolHandlers[i].handler = nil;
        // theGlobals->protocolHandlers[i].readPB = -1; /* not used */
    }
}
