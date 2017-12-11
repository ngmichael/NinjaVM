#include <stdio.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/utils.h"
#include "lib/support.h"


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
