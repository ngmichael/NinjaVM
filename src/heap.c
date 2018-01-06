#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "headers/heap.h"
#include "headers/stack.h"
#include "headers/sda.h"
#include "headers/njvm.h"
#include "../lib/bigint.h"

unsigned long heapSize; /* The amount of bytes available to the heap */
unsigned long maxAllocatableBytes; /* Number of bytes for one half of the heap */
unsigned long allocatedBytes; /* Number of occupied bytes in the current half of the heap*/
unsigned int gcRunning; /* Flag for determining if the gc is running or not*/

unsigned char* heap; /* Main Heap-Pointer */
unsigned char* src;  /* Source pointer (Quell) - Unused*/
unsigned char* dest; /* Destination pointer (Ziel) - Used for allocation*/
unsigned char* freePointer; /* Points to the next free byte in the current half*/

ObjRef copyToFreeMemory(ObjRef orig);
ObjRef relocate(ObjRef orig);
void gc(void);
unsigned char* allocate(unsigned int nBytes);

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
    unsigned int i;
    unsigned int destOffSet;

    gcRunning = TRUE;
    allocatedBytes = 0;
    /* Step 1: Flip dest and src*/
    temp = dest;
    dest = src;
    src = temp;
    freePointer = dest;

    /* Step 2: Copy from all object containing structures (stack, ...)*/

    /* Stack */
    for (i = 0; i < sp; i++) {
        StackSlot slot;
        
        slot = stack[sp];
        if (slot.isObjRef == FALSE) continue;
        slot.u.objRef = relocate(slot.u.objRef);
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
    destOffSet = 0;
    while(destOffSet < allocatedBytes) {
        ObjRef obj;
        int refCount;
        ObjRef* refs;

        obj = (ObjRef) (dest + destOffSet); /* Jump to and fetch the next object in the heap*/
        destOffSet += obj->size; /* Advance the byte counter*/

        if (IS_PRIM(obj)) continue; /* Continue loop if object is primitive*/
        refCount = GET_SIZE(obj); /* Get the amount of references*/
        refs = GET_REFS(obj); /* Get the references themselfs*/

        /* Iterate over references and relocate */
        for (i = 0; i < refCount; i++) {
            refs[i] = relocate(refs[i]);
        }
    }
}
