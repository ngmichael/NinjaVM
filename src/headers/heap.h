#ifndef KSP_WS1718_HEAP_H

#define KSP_WS1718_HEAP_H

#define BROKEN_HEART ( (1 << (8 * sizeof(unsigned int) - 2)))
#define IS_RELOCATED(x) ( ((x)->size & BROKEN_HEART) != 0)
#define FORWARD_POINTER(x) ((x)->size & ~BROKEN_HEART)

extern unsigned long heapSize;
extern int gcPurge;
extern int gcStats;
extern unsigned int gcRunning;

void initHeap(void);
unsigned char* allocate(unsigned int nBytes);
void gc(void);
void printHeap(FILE* out);
void purgeHeap(void);

#endif
