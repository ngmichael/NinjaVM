#include <stdlib.h>
#include <stdio.h>
#include "headers/njvm.h"

unsigned long heapSize;

unsigned char* heap; /* Main Heap-Pointer */
unsigned char* src;  /* Source pointer (Quell) - Unused*/
unsigned char* dest; /* Destination pointer (Ziel) - Used for allocation*/

/**
 * Initializes the heap based on the value of variable heapSize
 */
void initHeap(void) {
    heap = calloc(heapSize, sizeof(unsigned char));
    if (heap == NULL) {
        printf("Error: System can't supply %lu Bytes for heap creation!\n", heapSize);
        exit(E_ERR_SYS_MEM);
    }
    dest = heap;
    src = heap + (heapSize / 2); 
}

/**
 * Allocates memory for objects on the heap.
 * 
 * @param nBytes - the requested number of bytes of memory
 * @return a pointer to the first byte of the requested memory
 */
unsigned char* allocate(unsigned int nBytes) {
    if (dest + nBytes <= src) {
        unsigned char* ret;
        ret = dest;
        dest = dest + nBytes;
        return ret;
    }

    printf("Error: Out of memory!\n");
    exit(E_ERR_OUT_OF_MEM);
}