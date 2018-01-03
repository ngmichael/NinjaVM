#include <stdlib.h>
#include <stdio.h>
#include "headers/njvm.h"
#include "headers/sda.h"
#include "headers/stack.h"
#include "../lib/support.h"
#include "../lib/bigint.h"

unsigned int sdaSize;
ObjRef* sda;

/**
 * Initializes the static data area.
 * Allocates size * 4 bytes of memory to store
 * n integer values.
 * 
 * NOTE: If the system can not supply the requested
 * amount of memory the function will display an error
 * message and terminate the VM.
 * 
 * @param size - number of "slots" for the sda
 */
void initSda(unsigned int size) {
    sdaSize = size;
    sda = calloc(size, sizeof(ObjRef));
    if (sda == NULL && size > 0) {
        printf(
            "Error: Can't initialize sda with %lu Bytes of memory.\n",
            sizeof(int) * size
        );
        exit(E_ERR_SYS_MEM);
    }
}

/**
 * Used for pushing values into the static data area.
 * This function pops the top most value from the stack
 * and stores it in the global variable at the supplied
 * position in the static data area.
 * 
 * NOTE: If the supplied position value is greater than the
 * the total amount of global variables the function will
 * dsiplay an error message and terminate the VM.
 */
void popGlobal(unsigned int position) {
    ObjRef value;

    if (position >= sdaSize) {
        printf(
            "Error: Can't save global variable '%d'! Index out of bounds!\n",
            position
        );
        exit(E_ERR_SDA_INDEX);
    }
    
    value = popObjRef();
    sda[position] = value;
}

/**
 * Pops a value from the static data area.
 * This function pops the value from the global variable
 * specifed by position from the static data area.
 * It will then push that value onto the stack.
 * 
 * NOTE: If the supplied position value is greater than the
 * the total amount of global variables the function will
 * dsiplay an error message and terminate the VM.
 */
void pushGlobal(unsigned int position) {
    ObjRef value;

    if (position >= sdaSize) {
        printf(
            "Error: Can't read global variable '%d'! Index out of bounds!\n",
            position
        );
        exit(E_ERR_SDA_INDEX);
    }

    value = sda[position];
    pushObjRef(value);
}

void printStaticDataAreaTo(FILE* stream) {
    unsigned int i;

    fprintf(stream, "Static data area contains %u variable(s):\n", sdaSize);
    for (i = 0; i < sdaSize; i++) {
        fprintf(stream, "[%04u]:\t", i);
        if (sda[i] == NULL) { /* NULL-Pointer */
            fprintf(stream, "(NIL)\n");
        }
        else if (IS_PRIM(sda[i])) { /* Primitive-Object (BigInt) */
            fprintf(stream, "Address: %p\n", (void*) sda[i]);
            fprintf(stream, "\tType: Primitive\n");
            fprintf(stream, "\tSize: %u Bytes\n", sda[i]->size);
            fprintf(stream, "\tValue (in Base10): ");
            bip.op1 = sda[i];
            bigPrint(stream);
            fprintf(stream, "\n");
        }
        else { /* Complex Object */
            fprintf(stream, "Address: %p\n", (void*) sda[i]);
            fprintf(stream, "\tType: Complex\n");
            fprintf(stream, "\tReferencing: %d\n", GET_SIZE(sda[i]));
        }
    }

    if (sdaSize > 0)
        fprintf(stream, "----- End of static data area -----\n");
}

/**
 * Prints the contents of the static data are to stdout.
 */
void printStaticDataArea(void) {
    printStaticDataAreaTo(stdout);
}

/**
 * Checks if the static data area has the specified index.
 * 
 * @param n the index to be checked
 * @return TRUE if index is valid, FALSE otherwise
 */
int hasIndex(unsigned int n) {
    return n < sdaSize ? TRUE : FALSE;
}

/**
 * Directly alters the specified variable to the specified value.
 * 
 * @param variable - the index of the global variable
 * @param value - the new value
 * @return TRUE if variable exists, FALSE otherwise
 */
int setVariable(unsigned int varnum, ObjRef value) {

    if (hasIndex(varnum) == FALSE) return FALSE;

    sda[varnum] = value;
    return TRUE;
}
