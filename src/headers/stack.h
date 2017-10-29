#ifndef KSP_WS17_18_STACK_H
#define KSP_WS17_18_STACK_H

extern unsigned int sp;
extern unsigned int stackSize;

void initStack(unsigned int size);

void push(int value);
int pop(void);

void allocateStackFrame(int size);
void releaseStackFrame(void);

void popLocal(int position);
void pushLocal(int position);

void printStack(void);

#endif /* KSP_WS17_18_STACK_H */
