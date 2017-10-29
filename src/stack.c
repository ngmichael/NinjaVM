#include <stdio.h>
#include <stdlib.h>

int* stack;
unsigned int sp;
unsigned int stackSize;

unsigned int fp;

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

    stack = (int*) malloc(sizeof(unsigned int) * size);
    if (stack == NULL) {
        printf("Error: Failed to initialize stack with size %lu Bytes.\n", sizeof(unsigned int) * size);
        exit(1);
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
        exit(1);
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
        exit(1);
    }

    value = pop();
    stack[pos] = value;
}

/**
 * Creates a new stack frame on the stack.
 * The stack frames size is specifed with the functions 
 * first agrument.
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
        exit(1);
    }

    if (sp + (size + 1) > stackSize) {
        printf(
            "Error: Can't allocate stack frame with size %d: Stack overflow\n",
            size
        );
        exit(1);
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
        exit(1);
    }

    sp = fp;
    fp = pop();
}

/**
 * Prints the current content of the stack from top to bottom
 */
void printStack(void) {

    int localSp;

    localSp = sp+1;

    do {
        localSp--;
        if (localSp == sp && localSp == fp) {
            printf("sp, fp\t\t--->\t[%04d]:\txxxx\n", localSp);
        }
        else if (localSp == sp) {
            printf("sp\t\t--->\t[%04d]:\txxxx\n", localSp);
        }
        else if (localSp == fp) {
            int value;

            value = stack[localSp];
            printf("fp\t\t--->\t[%04d]: %d\n", localSp, value);
        }
        else {
            int value;

            value = stack[localSp];
            printf("\t\t\t[%04d]: %d\n", localSp, value);
        }
    } while (localSp > 0);
    
    printf("----- Bottom of stack -----\n");
}
