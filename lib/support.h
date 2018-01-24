/*
 * support.h -- object representation and support functions
 */


#ifndef _SUPPORT_H_
#define _SUPPORT_H_

#define RESET		      0
#define BRIGHT 		    1
#define DIM		        2
#define ITALIC        3
#define UNDERLINE     4
#define REVERSE		    7
#define HIDDEN		    8
#define STRIKETHROUGH 9

#define BLACK 		0
#define RED		    1
#define GREEN		  2
#define YELLOW		3
#define BLUE		  4
#define MAGENTA		5
#define CYAN		  6
#define	WHITE		  7

void changeTextColor(unsigned int foreground, unsigned int background, unsigned int state);


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
