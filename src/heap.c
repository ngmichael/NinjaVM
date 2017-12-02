#include <stdlib.h>
#include <stdio.h>
#include "headers/heap.h"
#include "headers/njvm.h"

/**
 * Creates a new object instance on the heap
 * and returns a pointer to the first byte of 
 * that object. The size component of the object is
 * set aswell.
 * 
 * @param size - the amount of bytes that the object shall hold
 * @return A pointer to the first byte of this Object on the heap
 */
ObjRef allocate(unsigned int size) {
    ObjRef object = calloc(size + sizeof(unsigned int), sizeof(unsigned int));
    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", size + sizeof(unsigned int));
        exit(E_ERR_SYS_MEM);
    }
    object->size = size;
    return object;
}
