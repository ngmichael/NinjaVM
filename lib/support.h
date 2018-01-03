/*
 * support.h -- object representation and support functions
 */


#ifndef _SUPPORT_H_
#define _SUPPORT_H_

#define RED     "\x1b[31m"
#define GREEN   "\x1b[32m"
#define YELLOW  "\x1b[33m"
#define BLUE    "\x1b[34m"
#define MAGENTA "\x1b[35m"
#define CYAN    "\x1b[36m"
#define WHITE   "\x1b[0m"

void changeTextColor(char* color);

/*
 * Color codes - and their meaning:
 * 
 * RED: used for fatal errors, all errors that prevent further program execution
 * YELLOW: warnings and debugger help output
 * GREEN: OPCODES, when displayed in debugger
 * CYAN: INSPECT OUTPUT: When inspecting stack, sda, ect in debugger
 * MAGENTA: BREAKPOINTS
 * BLUE: unused
 * WHITE: DEFAULT; Everything else
 */


/* object representation */

typedef struct {
  unsigned int size;			/* byte count of payload data */
  unsigned char data[1];		/* payload data, size as needed */
} *ObjRef;


/* support functions */

void fatalError(char *msg);		/* print a message and exit */
ObjRef newPrimObject(int dataSize);	/* create a new primitive object */
ObjRef newComplexObject(int refCount); /* create a new complex object */

void inspectObject(ObjRef object);


#endif /* _SUPPORT_H_ */
