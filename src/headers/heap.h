#ifndef KSP_WS1718_DEBUGGER_H

#define KSP_WS1718_DEBUGGER_H

extern unsigned int heapSize;

void initHeap(void);
unsigned char* allocate(unsigned int nBytes);

#endif
