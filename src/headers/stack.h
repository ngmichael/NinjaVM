#ifndef KSP_WS17_18_STACK_H
#define KSP_WS17_18_STACK_H

#include <stdlib.h>

extern unsigned int sp;
extern size_t stackSize;

void initStack(size_t size);
void push(int value);
int pop(void);

#endif /* KSP_WS17_18_STACK_H */
