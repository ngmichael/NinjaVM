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
    ObjRef object;

    object = calloc(dataSize + sizeof(int), 1);
    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", dataSize + sizeof(int));
        exit(E_ERR_SYS_MEM);
    }
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
    int i;

    object = calloc((sizeof(ObjRef) * refCount) + sizeof(int), 1);

    if (object == NULL) {
        printf("Error: Failed to initialize memory for object with size %lu!\n", (sizeof(ObjRef) * refCount) + sizeof(int));
        exit(E_ERR_SYS_MEM);
    }

    object->size = refCount | 0x1 << 31;
    return object;
}

/**
 * Prints details about an object to a stream.
 * 
 * @param object - the object that is to be inspected
 * @param outStream - a FILE* representing the stream
 */
void inspectObject(ObjRef object, FILE* outStream) {
    if (object == NULL) { /* NULL-Pointer */
        fprintf(outStream, "The object is a NIL-Reference!\n");
    }
    else if (IS_PRIM(object)) { /* Primitive-Object (BigInt) */
        fprintf(outStream, "\tType             : Primitive\n");
        fprintf(outStream, "\tSize             : %ul Bytes\n", object->size);
        fprintf(outStream, "\tValue (in Base10): ");
        bip.op1 = returnValueRegister;
        bigPrint(outStream);
        fprintf(outStream, "\n");
    }
    else { /* Complex Object */
        fprintf(outStream, "\tType             : Complex\n");
        fprintf(outStream, "\tReferencing:     : %d\n", GET_SIZE(object));
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
