#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "headers/njvm.h"
#include "../lib/support.h"


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
    ObjRef object = calloc(dataSize + sizeof(int), sizeof(int));
    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", dataSize + sizeof(int));
        exit(E_ERR_SYS_MEM);
    }
    object->size = dataSize;
    return object;
}

ObjRef newComplexObject(int refCount) {
    ObjRef object = calloc((sizeof(ObjRef) * refCount) + sizeof(int), 1);

    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", (sizeof(ObjRef) * refCount) + sizeof(int));
        exit(E_ERR_SYS_MEM);
    }

    object->size = refCount | 0x1 << 31;
    return NULL;
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
