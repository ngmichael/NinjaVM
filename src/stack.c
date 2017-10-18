#include <stdio.h>
#include <stdlib.h>

int* stack;
unsigned int sp;
unsigned int stackSize;

void initStack(unsigned int size) {
    sp = 0;
    stackSize = size;
    stack = (int*) malloc(sizeof(unsigned int) * size);
    if (stack == NULL) {
        printf("Error: Failed to initialize stack with size %lu Bytes.\n", sizeof(unsigned int) * size);
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
