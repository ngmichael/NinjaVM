#include <stdlib.h>
#include <stdio.h>

int* stack;
unsigned int sp;


size_t stackSize;

void initStack(size_t size) {
    stackSize = size;
    stack = (int*) malloc(size);
    if (stack == NULL) {
        printf("Error: Failed to initialize stack with size %lu Bytes.\n", size);
        exit(1);
    }
}

void push(int value) {
    if (sp >= stackSize) {
        printf("Error: Stack overflow\n");
        exit(1);
    }

    stack[sp] = value;
    sp++;
}

int pop(void) {

    int value;

    if (sp == 0) {
        printf("Error: Stack underflow\n");
        exit(1);
    }

    value = stack[sp];
    sp--;
    return value;
}
