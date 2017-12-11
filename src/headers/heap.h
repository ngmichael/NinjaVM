#ifndef KSP_WS17_18_HEAP_H
#define KSP_WS17_18_HEAP_H

typedef struct {
	unsigned int size;		/* Byte-count of payload data   */
	unsigned char data[1];	/* Payload data, size as needed */
} Object;

typedef Object* ObjRef;

typedef struct {
	int isObjRef;
	union {
		ObjRef objRef;
		int number;
	} u;
} StackSlot;

ObjRef allocate(unsigned int size);

#endif