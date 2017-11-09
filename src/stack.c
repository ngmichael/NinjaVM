#include <stdio.h>
#include <stdlib.h>
#include "headers/njvm.h"
#include "headers/stack.h"

int* stack;
unsigned int sp;
unsigned int stackSize;

unsigned int fp;

/**
 * Allocates size * 4 Bytes of memory for the stack
 * and sets the stack pointer to point at byte no. 0.
 * NOTE: If te system can not supply the requested
 * amount of ram the function will display an error
 * message and terminate the VM.
 * 
 * @param size - the number slots for the stack
 */
void initStack(unsigned int size) {
    unsigned int i;

    stack = (int*) malloc(sizeof(unsigned int) * size);
    if (stack == NULL) {
        printf("Error: Failed to initialize stack with size %lu Bytes.\n", sizeof(unsigned int) * size);
        exit(E_ERR_SYS_MEM);
    }

    sp = 0;
    fp = 0;
    stackSize = size;

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
        exit(E_ERR_ST_OVER);
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
        exit(E_ERR_ST_UNDER);
    }

    sp = sp - 1;
    value = stack[sp];
    return value;
}

/**
 * Pushes a variable at the supplied position from the
 * current stack frame onto the stack.
 * 
 * NOTE: If the position lies outside of the stack boundaries the
 * function will display an error message and terminate the VM.
 */
void pushLocal(int position) {
    int value;
    int pos;

    pos = fp + position;

    if (pos < 0 || pos >= stackSize) {
        printf("Error: Local variable outside of stack index range!\n");
        printf("Range: 0 ... %d, Variable position: %d\n", stackSize-1, pos);
        exit(E_ERR_STF_INDEX);
    }

    value = stack[pos];
    push(value);
}

/**
 * Pops the stack and stores the value at the supplied
 * position in the current stack frame.
 * 
 * NOTE: If the position lies outside of the stack boundaries the
 * function will display an error message and terminate the VM.
 */
void popLocal(int position) {
    int value;
    int pos;

    pos = fp + position;

    if (pos < 0 || pos >= stackSize) {
        printf("Error: Local variable outside of stack index range!\n");
        printf("Range: 0 ... %d, Variable position: %d\n", stackSize-1, pos);
        exit(E_ERR_STF_INDEX);
    }

    value = pop();
    stack[pos] = value;
}

/**
 * Creates a new stack frame on the stack.
 * The stack frames size is specifed with the functions 
 * first argument.
 * 
 * NOTE: If the newly created stack frame is larger than the
 * remaining space on the stack the function will display an
 * error message and terminate the VM.
 * 
 * @param size - The size of the new stack frame
 */
void allocateStackFrame(int size) {

    if (size < 0) {
        printf("Error: Can't allocate stack frame with negative size!\n");
        exit(E_ERR_STF_ALLOC);
    }

    if (sp + (size + 1) > stackSize) {
        printf(
            "Error: Can't allocate stack frame with size %d: Stack overflow\n",
            size
        );
        exit(E_ERR_STF_ALLOC);
    }

    push(fp);
    fp = sp;
    sp = sp + size;
}

/**
 * Releases the current stack frame and makes
 * the previous stack frame the current one.
 * 
 * NOTE: If there is no stack frame allocated, the 
 * function will display an error message and terminate
 * the VM.
 */
void releaseStackFrame(void) {
    if (fp == 0) {
        printf("Error: Can't release stack frame that doesn't exist!\n");
        exit(E_ERR_STF_FREE);
    }

    sp = fp;
    fp = pop();
}

void printStackTo(FILE* stream) {
    int i;
    for (i = sp; i >= 0; i--) {
        if (i == sp && i == fp) {
            fprintf(stream, "sp, fp\t--->\t[%04d]:\txxxx\n", i);
        }
        else if (i == sp) {
            fprintf(stream, "sp\t--->\t[%04d]:\txxxx\n", i);
        }
        else if (i == fp) {
            int value;
    
            value = stack[i];
            fprintf(stream, "fp\t--->\t[%04d]: %d\n", i, value);
        }
        else {
            int value;
    
            value = stack[i];
            fprintf(stream, "\t\t\t[%04d]: %d\n", i, value);
        }
    }
        
    fprintf(stream, "----- Bottom of stack -----\n");
}

/**
 * Prints the current content of the stack from top to bottom
 */
void printStack(void) {
    printStackTo(stdout);
}

/**
 * Checks if value n is within the stack boundaries
 *
 * @param n - the value to be checked
 * @return TRUE if n lies within stack boundaries, FALSE otherwise
 */
int isAccessibleStackSlot(int n) {
    return n >= 0 && n < sp ? TRUE : FALSE;
}


/**
 * Sets the specified value at the specified position in the stack.
 * 
 * @param slot - the slot that should be set
 * @param value - the value to set
 */
void replaceStackSlotValue(unsigned int slot, int value) {
    if (isAccessibleStackSlot(slot) == FALSE) {
        printf("Warning: %u is not an accessible stack slot!\n", slot);
    }
    stack[slot] = value;
}
