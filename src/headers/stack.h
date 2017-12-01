#ifndef KSP_WS17_18_STACK_H
#define KSP_WS17_18_STACK_H

extern unsigned int sp;
extern unsigned int fp;
extern unsigned int stackSize;

void initStack(unsigned int size);

void push(int value);
void pushObjRef(int value);

int pop(void);
int popObjRef(void);

void allocateStackFrame(int size);
void releaseStackFrame(void);

void popLocal(int position);
void pushLocal(int position);

void printStackTo(FILE* stream);
void printStack(void);

int isAccessibleStackSlot(int n);
void replaceStackSlotValue(unsigned int slot, int isObjRef, int value);

#endif /* KSP_WS17_18_STACK_H */
