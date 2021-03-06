#ifndef KSP_WS1718_DEBUGGER_H

#define KSP_WS1718_DEBUGGER_H

#define DEBUGGER "[Debugger]:"

#define DEBUG_BREAKPOINT "[Debugger/Breakpoint]:"
#define DEBUG_INSPECT "[Debugger/Inspect]:"
#define DEBUG_DUMP "[Debugger/MemoryDump]:"
#define DEBUG_EXEC "[Debugger/Execute]:"

#define ERROR "[Debugger]: An error has occurred:\n[Debugger]:"

void debug(void);
void memoryDump(char* path);

#endif