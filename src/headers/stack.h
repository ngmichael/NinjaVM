#ifndef KSP_WS17_18_STACK_H
#define KSP_WS17_18_STACK_H

extern unsigned int sp;
extern unsigned int stackSize;

void initStack(unsigned int size);
void push(int value);
int pop(void);

#endif /* KSP_WS17_18_STACK_H */
