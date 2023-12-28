#include "util.h"

#include <MacTypes.h>
#include <OSUtils.h>
#include <Timer.h>
#include <Traps.h>

#include "driver.h"

#if defined(DEBUG)
char strbuf[255];
#endif

/* Check whether a given trap is available. Adapted from IM: Devices listing
   8-1 */
Boolean trapAvailable(const unsigned short trap) {
  TrapType type;
  /* First determine whether it is an OS or Toolbox routine */
  if (trap & 0x800) {
    type = OSTrap;
  } else {
    type = ToolTrap;
  }

  /* filter cases where older systems mask with 0x1ff rather than 0x3ff */
  if (type == ToolTrap && (trap & 0x3ff) >= 0x200 &&
      GetToolboxTrapAddress(0xa86e) == GetToolboxTrapAddress(0xaa6e)) {
    return false;
  } else {
    return NGetTrapAddress(trap, type) != GetToolboxTrapAddress(_Unimplemented);
  }
}

#if defined(DEBUG)
void debug_log(driverGlobals *theGlobals, unsigned short eventType,
               unsigned short eventData) {
  eventLog *log = &theGlobals->log;

  /* Disable interrupts so that log operations are atomic */
  unsigned short srSave;
  asm("MOVE.W  %%sr, %[srSave] \n\t"
      "ORI.W   %[srMaskInterrupts], %%sr  \n\t"
      : [srSave] "=dm"(srSave)
      : [srMaskInterrupts] "i"(0x700));

  log->entries[log->head].ticks = TickCount();
  log->entries[log->head].eventType = eventType;
  log->entries[log->head].eventData = eventData;

  log->head = (log->head + 1) % LOG_LEN;
  /* Make head of log buffer look distinctive so that we can spot it in a dump */
  log->entries[log->head].ticks = 0xffffffff;
  log->entries[log->head].eventType = 0xffff;
  log->entries[log->head].eventData = 0xffff;

  /* Restore processor state */
  asm volatile("MOVE.W  %[srSave], %%sr \n\t" : : [srSave] "dm"(srSave));
}
#endif
