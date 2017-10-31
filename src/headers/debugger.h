#ifndef KSP_WS1718_DEBUGGER_H

#define KSP_WS1718_DEBUGGER_H

#define DEBUGGER "[Debugger]:"

#define DEBUG_BREAKPOINT "[Debugger/Breakpoint]:"
#define DEBUG_LIST "[Debugger/List]:"
#define DEBUG_INSPECT "[Debugger/Inspect]:"
#define DEBUG_EDIT "[Debugger/Editor]:"
#define DEBUG_DUMP "[Debugger/MemoryDump]:"

#define ERROR "[Debugger]: An error has occured:\n[Debugger]:"

void debug(FILE* code);

#endif