#include <stdio.h>
#include <stdlib.h>

int* stack;
unsigned int sp;
unsigned int stackSize;

/**
 * Allocates size * 4 Bytes of memory for the stack
 * and sets the stack pointer to point at byte no. 0.
 * NOTE: If te system can not supply the requested
 * ammount of ram the function will display an error
 * message and terminate the VM.
 * 
 * @param size - the number slots for the stack
 */
void initStack(unsigned int size) {
    unsigned int i;

    sp = 0;
    stackSize = size;
    stack = (int*) malloc(sizeof(unsigned int) * size);
    if (stack == NULL) {
        printf("Error: Failed to initialize stack with size %lu Bytes.\n", sizeof(unsigned int) * size);
        exit(1);
    }

    for (i = 0; i < stackSize; i++) {
        stack[i] = 0;
    }
}

/**
 * Pushes a value onto the stack.
 * NOTE: Trying to push a value while
 * the stack is full will result in a stack
 * overflow error.
 *  
 * @param value - the value to push on the stack
 */
void push(int value) {
    if (sp >= stackSize) {
        printf("Error: Stack overflow\n");
        exit(1);
    }

    stack[sp] = value;
    sp = sp + 1;
}

/**
 * Pops a value from the stack.
 * NOTE: Trying to pop a value from the stack
 * while it is empty will result in a stack
 * underflow error.
 * 
 * @return value - the top most value from the stack as an integer
 */
int pop(void) {

    int value;

    if (sp == 0) {
        printf("Error: Stack underflow\n");
        exit(1);
    }

    sp = sp - 1;
    value = stack[sp];
    return value;
}
