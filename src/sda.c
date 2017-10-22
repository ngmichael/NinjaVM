#include <stdlib.h>
#include <stdio.h>
#include "headers/sda.h"
#include "headers/stack.h"

unsigned int sdaSize;
int* sda;

/**
 * Initializes the static data area.
 * Allocates size * 4 bytes of memory to store
 * n integer values.
 * 
 * NOTE: If the system can not supply the requested
 * ammount of memory the function will display an error
 * message and terminate the VM.
 * 
 * @param size - number of "slots" for the sda
 */
void initSda(unsigned int size) {
    sdaSize = size;
    sda = malloc(sizeof(int) * size);
    if (sda == NULL && size > 0) {
        printf(
            "Error: Can't initialize sda with %lu Bytes of memory.\n",
            sizeof(int) * size
        );
        exit(1);
    }
}

/**
 * Used for pushing values into the static data area.
 * This function pops the top most value from the stack
 * and stores it in the global variable at the supplied
 * postition in the static data area.
 * 
 * NOTE: If the supplied position value is greater than the
 * the total ammount of global variables the function will
 * dsiplay an error message and terminate the VM.
 */
void popGlobal(unsigned int position) {
    int value;

    if (position >= sdaSize) {
        printf(
            "Error: Can't save global variable '%d'! Index out of bounds!\n",
            position
        );
        exit(1);
    }
    
    value = pop();
    sda[position] = value;
}

/**
 * Pops a value from the static data area.
 * This function pops the value from the global variable
 * specifed by position from the static data area.
 * It will then push that value onto the stack.
 * 
 * NOTE: If the supplied position value is greater than the
 * the total ammount of global variables the function will
 * dsiplay an error message and terminate the VM.
 */
void pushGlobal(unsigned int position) {
    int value;

    if (position >= sdaSize) {
        printf(
            "Error: Can't read global variable '%d'! Index out of bounds!\n",
            position
        );
        exit(1);
    }

    value = sda[position];
    push(value);
}
