#ifndef KSP_WS1718_HEAP_H

#define KSP_WS1718_HEAP_H

extern unsigned long heapSize;

void initHeap(void);
unsigned char* allocate(unsigned int nBytes);

#endif
