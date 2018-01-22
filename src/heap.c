#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "headers/heap.h"
#include "headers/stack.h"
#include "headers/sda.h"
#include "headers/njvm.h"
#include "headers/debugger.h"
#include "../lib/support.h"
#include "../lib/bigint.h"

unsigned long heapSize; /* The amount of bytes available to the heap */
unsigned long maxAllocatableBytes; /* Number of bytes for one half of the heap */
unsigned long allocatedBytes; /* Number of occupied bytes in the current half of the heap*/
unsigned int gcRunning; /* Flag for determining if the gc is running or not*/
int gcPurge; /* Flag for determining if the old heap half is cleared after GC run*/
int gcStats; /* Flag for determining if gc statistics should be printed after gc run */

unsigned char* heap; /* Main Heap-Pointer */
unsigned char* src;  /* Source pointer (Quell) - Unused*/
unsigned char* dest; /* Destination pointer (Ziel) - Used for allocation*/
unsigned char* freePointer; /* Points to the next free byte in the current half*/

unsigned int objectCount; /* Amount of objects created since last gc run */
unsigned int occupiedObjectBytes; /* Accumulated byte count of these objects */
unsigned int livingObjectCount; /* Amount of all living objects*/

/* Function delcarations */
unsigned char* allocate(unsigned int nBytes);
void gc(void);
ObjRef relocate(ObjRef orig);
ObjRef copyToFreeMemory(ObjRef orig);
void printGcStatistics(void);

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
    freePointer = heap;
    src = heap + (heapSize / 2); 
    maxAllocatableBytes = heapSize / 2;
    allocatedBytes = 0;
    gcRunning = FALSE;
    objectCount = 0;
    occupiedObjectBytes = 0;
    livingObjectCount = 0;
}

/**
 * Allocates memory for objects on the heap.
 * 
 * @param nBytes - the requested number of bytes of memory
 * @return a pointer to the first byte of the requested memory
 */
unsigned char* allocate(unsigned int nBytes) {
    if (allocatedBytes + nBytes <= maxAllocatableBytes) {
        unsigned char* ret;

        ret = freePointer;
        freePointer = freePointer + nBytes;
        allocatedBytes += nBytes;
        livingObjectCount++;
        objectCount++;
        occupiedObjectBytes += nBytes;
        return ret;
    }
    else if (gcRunning == FALSE) {
        unsigned char* ret;
        gc();
        ret = allocate(nBytes);
        gcRunning = FALSE;
        return ret;
    }
    else {
        printf("Error: Out of memory!\n");
        exit(E_ERR_OUT_OF_MEM);
    }
}

/**
 * Copies an object to the free half of the heap.
 * 
 * @param orig - the source object to be copied
 * @return a pointer to an exact replica of the object located in the 
 * free half of the heap
 */
ObjRef copyToFreeMemory(ObjRef orig) {
    ObjRef copy;

    if (IS_PRIM(orig)) {
        copy = newPrimObject(orig->size);
        memcpy(copy->data, orig->data, orig->size);
    }
    else {
        copy = newComplexObject(GET_SIZE(orig));
        memcpy(copy->data, orig->data, sizeof(ObjRef) * GET_SIZE(orig));
    }
    return copy;
}

ObjRef relocate(ObjRef orig) {
    ObjRef copy;

    if (orig == NULL) {
        copy = NULL;
    }
    else if (IS_RELOCATED(orig)) { /* Broken-Heart Flag */
        copy = (ObjRef) (dest + FORWARD_POINTER(orig));
    }
    else { /* Object needs to be copied to free memory*/
        copy = copyToFreeMemory(orig);
        orig->size = BROKEN_HEART | ((unsigned char*) copy - dest);
    }

    return copy;
}

/**
 * Main function for the garbage collector
 */
void gc(void) {
    unsigned char* temp_for_heap_flip;
    unsigned char* nextObj;
    unsigned int i;
    
    gcRunning = TRUE;
    allocatedBytes = 0;
    livingObjectCount = 0;
    /* Step 1: Flip dest and src*/
    temp_for_heap_flip = dest;
    dest = src;
    src = temp_for_heap_flip;
    freePointer = dest;

    /* Clear the new half of the heap before writing to it. */
    memset((void*)dest, 0, maxAllocatableBytes);

    /* Step 2: Copy from all object containing structures (stack, ...)*/

    /* Stack */
    for (i = 0; i < sp; i++) {
        if (stack[i].isObjRef == FALSE) {
            continue;
        }
        stack[i].u.objRef = relocate(stack[i].u.objRef);
    }

    /* SDA */
    for (i = 0; i < sdaSize; i++) {
        sda[i] = relocate(sda[i]);
    }

    /* RET */
    returnValueRegister = relocate(returnValueRegister);

    /* BIP */
    bip.op1 = relocate(bip.op1);
    bip.op2 = relocate(bip.op2);
    bip.res = relocate(bip.res);
    bip.rem = relocate(bip.rem);
    
    /* Step 3: Iterate over all objects in dest mem and copy all objects from
    src mem that they still point to. Fix these pointers aswell.*/
    nextObj = dest;
    while(nextObj < freePointer) {
        ObjRef obj;
        int refCount;
        ObjRef* refs;

        obj = (ObjRef) nextObj; /* Jump to and fetch the next object in the heap*/

        if (IS_PRIM(obj)) {
            nextObj += sizeof(unsigned int) + obj->size; /* Continue loop if object is primitive*/
        } 
        else {
            refCount = GET_SIZE(obj); /* Get the amount of references*/
            refs = GET_REFS(obj); /* Get the references themselfs*/

            /* Iterate over references and relocate */
            for (i = 0; i < refCount; i++) {
                refs[i] = relocate(refs[i]);
            }
            nextObj += sizeof(unsigned int) + (sizeof(ObjRef) * refCount);
        }
    }

    if (gcStats == TRUE) printGcStatistics();

    if (gcPurge == TRUE) {
        /* Override the src heap half with 0 */
        memset((void*) src, 0, maxAllocatableBytes);
    }
}

void printGcStatistics(void) {
    printf("\n");
    printf(" ----- Garbage Collector Stats -----\n");
    printf("Objects created since last run: %u (%lu Bytes)\n", objectCount-livingObjectCount, occupiedObjectBytes-allocatedBytes);
    printf("Currently alive objects: %u (%lu Bytes)\n", livingObjectCount, allocatedBytes);
    printf("Remaining space on heap: %lu Bytes\n", maxAllocatableBytes - allocatedBytes);
    printf("------------------------------------\n");
    objectCount = 0;
    occupiedObjectBytes = 0;
}

void printHeap(FILE* out) {
    int i;

    if (out == NULL) {
        return;
    }

    fprintf(out, "Address:         0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");
    fprintf(out, "%p:  ", (void*) dest);
    for (i = 0; i < maxAllocatableBytes; i++) {
        if (i % 16 == 0){
            fprintf(out, "\n%p:  ", (void*) (dest+i));
        }
        fprintf(out, "%02X ", (int) dest[i]);
    }
    fprintf(out, "\n");
}