#ifndef KSP_WS1718_HEAP_H

#define KSP_WS1718_HEAP_H

#define BROKEN_HEART(x) ( ((x)->size & (1 << (8 * sizeof(unsigned int) - 2))) != 0)
#define FORWARD_POINTER(x) ((x)->size & 0x3FFFFFFF)

extern unsigned long heapSize;
extern int gcPurge;

void initHeap(void);
unsigned char* allocate(unsigned int nBytes);

#endif
