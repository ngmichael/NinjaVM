#include <stdlib.h>
#include <stdio.h>
#include "headers/heap.h"
#include "headers/njvm.h"

ObjRef allocate(unsigned int size) {
    ObjRef object = calloc(size + sizeof(unsigned int), sizeof(unsigned int));
    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", size + sizeof(unsigned int));
        exit(E_ERR_SYS_MEM);
    }
    object->size = size;
    return object;
}
