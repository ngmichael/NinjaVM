#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "../lib/support.h"
#include "../lib/bigint.h"

/* Pointer to the stacks memory*/
StackSlot* stack;
/* The stack pointer */
unsigned int sp;
/* The stack frame pointer - points to the first element of the current frame*/
unsigned int fp;
/* Size of the stacks memory */
unsigned int stackSize;
/* The maximum amount of elements that can be on the stack */
unsigned int maxElements;

/**
 * Allocates size * 4 Bytes of memory for the stack
 * and sets the stack pointer to point at byte no. 0.
 * NOTE: If te system can not supply the requested
 * amount of ram the function will display an error
 * message and terminate the VM.
 * 
 * @param size - the number slots for the stack
 */
void initStack(void) {
    stack = (StackSlot*) calloc(stackSize, sizeof(unsigned char));
    if (stack == NULL) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Failed to initialize stack with size %u Bytes.\n", stackSize);
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_SYS_MEM);
    }

    sp = 0;
    fp = 0;
    maxElements = stackSize / sizeof(StackSlot);
}

/**
 * Pushes the supplied value as a number onto the stack
 * NOTE: Trying to push a value while
 * the stack is full will result in a stack
 * overflow error.
 *  
 * @param value - the value to be pushed onto the stack
 */
void push(int value) {
    if (sp >= maxElements) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Stack overflow\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_OVER);
    }

    stack[sp].isObjRef = FALSE;
    stack[sp].u.number = value;
    sp = sp + 1;
}

/**
 * Pushes the supplied value as an Object onto the stack.
 * NOTE: Trying to push a value while
 * the stack is full will result in a stack
 * overflow error.
 *  
 * @param value - the value to be pushed onto the stack
 */
void pushObjRef(ObjRef obj) {
    if (sp >= maxElements) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Stack overflow\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_OVER);
    }

    stack[sp].isObjRef = TRUE;
    stack[sp].u.objRef = obj;
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
    StackSlot value;

    if (sp == 0) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Stack underflow\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_UNDER);
    }

    sp = sp - 1;
    value = stack[sp];

    if (value.isObjRef == TRUE) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Tried to access stackslot as number, but it contains object!\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_NO_NUM);
    }

    return value.u.number;
}

/**
 * Pops a value from the stack and returns it as an Object reference.
 * NOTE: Popping an empty stack will cause a stack underflow error.
 * 
 * @return an object reference
 */
ObjRef popObjRef(void) {
    StackSlot value;

    if (sp == 0) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Stack underflow\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_UNDER);
    }

    sp = sp - 1;
    value = stack[sp];
    
    if (value.isObjRef == FALSE) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Tried to access stackslot as object, but it contains a number!\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_NO_OBJ);
    }

    return value.u.objRef;
}

/**
 * Pushes a variable at the supplied position from the
 * current stack frame onto the stack.
 * 
 * NOTE: If the position lies outside of the stack boundaries the
 * function will display an error message and terminate the VM.
 */
void pushLocal(int position) {
    StackSlot slot;
    int pos;

    pos = fp + position;

    if (pos < 0 || pos >= stackSize) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Local variable outside of stack index range!\n");
        printf("Range: 0 ... %d, Variable position: %d\n", stackSize-1, pos);
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_STF_INDEX);
    }

    slot = stack[pos];
    if (slot.isObjRef == FALSE) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Tried to access stackslot as object, but it contains a number!\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_ST_NO_OBJ);
    }
    pushObjRef(slot.u.objRef);
}

/**
 * Pops the stack and stores the value at the supplied
 * position in the current stack frame.
 * 
 * NOTE: If the position lies outside of the stack boundaries the
 * function will display an error message and terminate the VM.
 */
void popLocal(int position) {
    int pos;

    pos = fp + position;

    if (pos < 0 || pos >= stackSize) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Local variable outside of stack index range!\n");
        printf("Range: 0 ... %d, Variable position: %d\n", stackSize-1, pos);
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_STF_INDEX);
    }

    stack[pos].u.objRef = popObjRef();
    stack[pos].isObjRef = TRUE;
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
    int i;

    if (size < 0) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Can't allocate stack frame with negative size!\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_STF_ALLOC);
    }

    if (sp + (size + 1) > maxElements) {
        changeTextColor(RED, BLACK, BRIGHT);
        printf(
            "ERROR: Can't allocate stack frame with size %d: Stack overflow\n",
            size
        );
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_STF_ALLOC);
    }

    push(fp);
    fp = sp;
    sp = sp + size;

    for (i = 0; i < sp - fp; i++) {
        stack[fp+i].isObjRef = TRUE;
        stack[fp+i].u.objRef = (ObjRef) NULL;
    }
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
        changeTextColor(RED, BLACK, BRIGHT);
        printf("ERROR: Can't release stack frame that doesn't exist!\n");
        changeTextColor(WHITE, BLACK, RESET);
        exit(E_ERR_STF_FREE);
    }

    sp = fp;
    fp = pop();
}

/**
 * Overrides the stacks entire memory with zeros
 * and resets stackpointer and framepointer
 */
void purgeStack(void) {
    memset((void*) stack, 0, stackSize);
    sp = fp = 0;
}

/**
 * Prints the content of the stack to the specified stream.
 */
void printStackTo(FILE* stream) {
    int i;
    for (i = sp; i >= 0; i--) {
        StackSlot slot;
        int value;
        char* typeString;

        /* Determine type of the stack slot */
        if (i < sp) {
            slot = stack[i];
            switch(slot.isObjRef) {
                case TRUE: {
                    typeString = "OBJREF\0";
                    break;
                }
                case FALSE: {
                    typeString = "NUMBER\0";
                    value = slot.u.number;
                    break;
                }
                default: {
                    typeString = "UNDEFINED\0";
                    value = 0;
                    break;
                }
            }
        }

        if (i == sp && i == fp) {
            fprintf(stream, "sp, fp ---> [%04d]: XXXXXXXXXX\n", i);
        }
        else if (i == sp) {
            fprintf(stream, "sp     ---> [%04d]: XXXXXXXXXX\n", i);
        }
        else if (i == fp) {
            if (slot.isObjRef == TRUE) {
                fprintf(stream, "fp     ---> [%04d]: Type: %s, Address: %p\n", i, typeString, (void*) slot.u.objRef);
                if (slot.u.objRef == NULL) { /* NULL-Pointer */
                    continue;
                }
                else if (IS_PRIM(slot.u.objRef)) { /* Primitive-Object (BigInt) */
                    fprintf(stream, "              Type: Primitive\n");
                    fprintf(stream, "              Size: %u Bytes\n", slot.u.objRef->size);
                }
                else { /* Complex Object */
                    fprintf(stream, "              Type: Complex\n");
                    fprintf(stream, "              Referencing: %d\n", GET_SIZE(slot.u.objRef));
                }
            } else fprintf(stream, "fp     ---> [%04d]: Type: %s, Value:   %d\n", i, typeString, value);
            
        }
        else {
            if (slot.isObjRef == TRUE) {
                fprintf(stream, "            [%04d]: Type: %s, Address: %p\n", i, typeString, (void*) slot.u.objRef);
                if (slot.u.objRef == NULL) { /* NULL-Pointer */
                    continue;
                }
                else if (IS_PRIM(slot.u.objRef)) { /* Primitive-Object (BigInt) */
                    fprintf(stream, "              Type: Primitive\n");
                    fprintf(stream, "              Size: %u Bytes\n", slot.u.objRef->size);
                }
                else { /* Complex Object */
                    fprintf(stream, "              Type: Complex\n");
                    fprintf(stream, "              Referencing: %d\n", GET_SIZE(slot.u.objRef));
                }
            } else fprintf(stream, "            [%04d]: Type: %s, Value:   %d\n", i, typeString, value);
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
