#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "headers/njvm.h"
#include "headers/heap.h"
#include "../lib/support.h"
#include "../lib/bigint.h"


/**
 * Prints the supplied error message
 * 
 * @param msg - the error message
 */
void fatalError(char* msg) {
    fprintf(stderr, "ERROR: %s\n", msg);
    exit(E_ERR_BIG_INT);
}

/**
 * Creates a new object instance on the heap
 * and returns a pointer to the first byte of 
 * that object. The size component of the object is
 * set aswell.
 * 
 * @param size - the amount of bytes that the object shall hold
 * @return A pointer to the first byte of this Object on the heap
 */
ObjRef newPrimObject(int dataSize) {
    ObjRef object;

    object = (ObjRef) allocate(dataSize + sizeof(int));
    object->size = dataSize;
    return object;
}

/**
 * Creates a new complex object. These objects are used for storing
 * records and arrays.
 * 
 * @param refCount - The total amount of object references this object can hold
 * @return a new object with sufficient amount of memory to hold all references
 */
ObjRef newComplexObject(int refCount) {
    ObjRef object;

    object = (ObjRef) allocate((sizeof(ObjRef) * refCount) + sizeof(int));
    object->size = refCount | 0x1 << 31;
    return object;
}

/**
 * Prints details about an object to stdout.
 * 
 * @param object - the object that is to be inspected
 */
void inspectObject(ObjRef object) {
    if (object == NULL) { /* NULL-Pointer */
        printf("\tNIL-Reference\n");
    }
    else if (IS_PRIM(object)) { /* Primitive-Object (BigInt) */
        printf("\tType             : Primitive\n");
        printf("\tSize             : %u Bytes\n", object->size);
        printf("\tValue (in Base10): ");
        bip.op1 = object;
        bigPrint(stdout);
        printf("\n");
    }
    else { /* Complex Object */
        int i, size;
        ObjRef* references;

        size = GET_SIZE(object);
        references = GET_REFS(object);
        printf("\tType             : Complex\n");
        printf("\tReferencing:     : %d\n", size);

        for (i = 0; i < size; i++) {
            printf("\t  [%06d]: %p\n", i, (void*) references[i]);
        }
    }
}

/**
 * Changes the text color of the terminal to the
 * specified color. The following colors are available:
 * 
 * RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN or WHITE
 * 
 * If the specified color is unrecognized, WHITE will be used as default.
 * 
 * @param color - A string representation of the color name.
 */
void changeTextColor(char* color) {
    if (strcmp(color, "RED") == 0) {
        printf("%s", RED);
    }
    else if (strcmp(color, "GREEN") == 0) {
        printf("%s", GREEN);
    }
    else if (strcmp(color, "YELLOW") == 0) {
        printf("%s", YELLOW);
    }
    else if (strcmp(color, "BLUE") == 0) {
        printf("%s", BLUE);
    }
    else if (strcmp(color, "MAGENTA") == 0) {
        printf("%s", MAGENTA);
    }
    else if (strcmp(color, "CYAN") == 0) {
        printf("%s", CYAN);
    }
    else {
        printf("%s", WHITE);
    }
}
