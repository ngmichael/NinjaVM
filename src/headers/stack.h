#ifndef KSP_WS17_18_STACK_H
#define KSP_WS17_18_STACK_H

#include "../../lib/support.h"

extern unsigned int sp;
extern unsigned int fp;
extern unsigned int stackSize;

void initStack(void);

void push(int value);
void pushObjRef(ObjRef value);

int pop(void);
ObjRef popObjRef(void);

void allocateStackFrame(int size);
void releaseStackFrame(void);

void popLocal(int position);
void pushLocal(int position);

void printStackTo(FILE* stream);
void printStack(void);

int isAccessibleStackSlot(int n);
void replaceStackSlotValue(unsigned int slot, int isObjRef, int value);

typedef struct {
	int isObjRef;
	union {
		ObjRef objRef;
		int number;
	} u;
} StackSlot;

extern StackSlot* stack;

#endif /* KSP_WS17_18_STACK_H */
