#include <stdlib.h>
#include <stdio.h>
#include "headers/sda.h"
#include "headers/stack.h"

unsigned int sdaSize;
int* sda;

void initSda(unsigned int size) {
    sdaSize = size;
    sda = malloc(sizeof(int) * size);
}

void popGlobal(unsigned int position) {
    int value;

    if (position >= sdaSize) {
        printf(
            "Error: Global variable '%d' undefined! Can't save value!\n",
            position
        );
        exit(1);
    }
    
    value = pop();
    sda[position] = value;
}

void pushGlobal(unsigned int position) {
    int value;

    if (position >= sdaSize) {
        printf(
            "Error: Global variable '%d' undefined! Can't read value!\n",
            position
        );
        exit(1);
    }

    value = sda[position];
    push(value);
}
