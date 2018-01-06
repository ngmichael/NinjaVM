#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/heap.h"

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

/**
 * Copies an object to the free half of the heap.
 * 
 * @param orig - the source object to be copied
 * @return a pointer to an exact replica of the object located in the 
 * free half of the heap
 */
ObjRef copyToFreeMemory(ObjRef orig) {
    unsigned char* copy;
    size_t size;

    size = orig->size;
    copy = allocate(size);
    memcpy((void*) copy, (void*) orig, size);
    return (ObjRef) copy;
}

ObjRef relocate(ObjRef orig) {
    ObjRef copy;

    if (orig == NULL) {
        copy = NULL;
    }
    else if (BROKEN_HEART(orig)) { /* Broken-Heart Flag */
        copy = (ObjRef) (heap + FORWARD_POINTER(orig));
    }
    else { /* Object needs to be copied to free memory*/
        unsigned int newSizeValue;

        copy = copyToFreeMemory(orig); /* Copy the object */
        newSizeValue = 1 << (8 * sizeof(unsigned int) - 2); /* Set BH Flag */
        newSizeValue = newSizeValue | ((unsigned char*) copy - heap);
        orig->size = newSizeValue;
    }

    return copy;
}

/**
 * Main function for the garbage collector
 */
void gc(void) {
    unsigned char* temp;

    /* Step 1: Flip dest and src*/
    temp = dest;
    dest = src;
    src = temp;

    /* Step 2: Copy from all object containing structures (stack, ...)*/
    
}