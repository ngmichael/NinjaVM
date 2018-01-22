#include <stdio.h>
#include <stdlib.h>
#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include "headers/sda.h"
#include "headers/heap.h"
#include "../lib/support.h"
#include "../lib/bigint.h"

char* opcodes[] = {
    "HALT", "PUSHC", "ADD", "SUB", "MUL", "DIV", "MOD", "RDINT", "WRINT",
    "RDCHR", "WRCHR", "PUSHG", "POPG", "ASF", "RSF", "PUSHL", "POPL", "EQ",
    "NE", "LT", "LE", "GT", "GE", "JMP", "BRF", "BRT", "CALL", "RET", "DROP",
    "PUSHR", "POPR", "DUP", "NEW", "GETF", "PUTF", "NEWA", "GETFA", "PUTFA",
    "GETSZ", "PUSHN", "REFEQ", "REFNE",
};

/**
 * Pops two objects from the stack into the BIP
 * and calls the bigCmp() function.
 * 
 * @return the result of the comparison as regular integer
 */
static int compare(void) {
    bip.op2 = popObjRef();
    bip.op1 = popObjRef();
    return bigCmp();
}

/**
 * Executes an instruction with its operand.
 * 
 * @param opcode - the instruction to be executed
 * @param operand - the instructions immediate value 
 */
void execute(unsigned int opcode, int operand) {
    switch (opcode) {
        case HALT: {
            halt = TRUE;
            if (gcStats == TRUE) {
                gc();
                gcRunning = FALSE;
            }
            break;
        }
        case PUSHC: {
            bigFromInt(operand);
            pushObjRef(bip.res);
            break;
        }
        case ADD: {
            bip.op1 = popObjRef();
            bip.op2 = popObjRef();
            bigAdd();
            pushObjRef(bip.res);
            break;
        }
        case SUB: {
            bip.op2 = popObjRef();
            bip.op1 = popObjRef();
            bigSub();
            pushObjRef(bip.res);
            break;
        }
        case MUL: {
            bip.op1 = popObjRef();
            bip.op2 = popObjRef();
            bigMul();
            pushObjRef(bip.res);
            break;
        }
        case DIV: {
            bip.op2 = popObjRef();
            bip.op1 = popObjRef();
            bigDiv();
            pushObjRef(bip.res);
            break;
        }
        case MOD: {
            bip.op2 = popObjRef();
            bip.op1 = popObjRef();
            bigDiv();
            pushObjRef(bip.rem);
            break;
        }
        case RDINT: {
            int read;

            scanf(" %d", &read);
            bigFromInt(read);
            pushObjRef(bip.res);
            break;
        }
        case WRINT: {
            bip.op1 = popObjRef();
            bigPrint(stdout);
            break;
        }
        case RDCHR: {
            char read;
            int result;
            result = scanf(" %c", &read);
            if (result == 0 || result == EOF) {
                printf("Error: Something went wrong while taking user input!\n");
                exit(E_ERR_IO_SHELL);
            }
            
            bigFromInt((int) read);
            pushObjRef(bip.res);
            break;
        }
        case WRCHR: {
            char c;

            bip.op1 = popObjRef();
            c = (char) bigToInt();
            printf("%c", c);
            break;
        }
        case PUSHG: {
            pushGlobal(operand);
            break;
        }
        case POPG: {
            popGlobal(operand);
            break;
        }
        case ASF: {
            allocateStackFrame(operand);
            break;
        }
        case RSF: {
            releaseStackFrame();
            break;
        }
        case PUSHL: {
            pushLocal(operand);
            break;
        }
        case POPL: {
            popLocal(operand);
            break;
        }
        case EQ: {
            int res;

            res = compare();
            bigFromInt(res == 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case NE: {
            int res;
            
            res = compare();
            bigFromInt(res != 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case LT: {
            int res;

            res = compare();
            bigFromInt(res < 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case LE: {
            int res;

            res = compare();
            bigFromInt(res <= 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case GT: {
            int res;

            res = compare();
            bigFromInt(res > 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case GE: {
            int res;

            res = compare();
            bigFromInt(res >= 0 ? TRUE : FALSE);
            pushObjRef(bip.res);
            break;
        }
        case JMP: {
            pc = operand;
            break;
        }
        case BRF: {
            int res;

            bip.op1 = popObjRef();
            res = bigToInt();
            if (res == FALSE) pc = operand;
            break;
        }
        case BRT: {
            int res;

            bip.op1 = popObjRef();
            res = bigToInt();
            if (res == TRUE) pc = operand;
            break;
        }
        case CALL: {
            push(pc);
            pc = operand;
            break;
        }
        case RET: {
            pc = pop();
            break;
        }
        case DROP: {
            if (((int)sp - operand) < 0) {
                printf("Error: Stack underflow!\n");
                exit(E_ERR_ST_UNDER);
            }
            sp = sp - operand;
            break;
        }
        case PUSHR: {
            pushObjRef(returnValueRegister);
            break;
        }
        case POPR: {
            returnValueRegister = popObjRef();
            break;
        }
        case DUP: {
            ObjRef value;

            value = popObjRef();
            pushObjRef(value);
            pushObjRef(value);
            break;
        }
        case NEW: {
            ObjRef object;
            ObjRef* refs;
            int i;

            object = newComplexObject(operand);
            refs = GET_REFS(object);
            for (i = 0; i < operand; i++) {
                refs[i] = (ObjRef) NULL;
            }
            pushObjRef(object);
            break;
        }
        case GETF: {
            ObjRef object;
            ObjRef* fields;
            int size;

            object = popObjRef();
            /* Check that the object is not a NULL-Pointer */
            if (object == NULL) {
                printf("ERROR: Can access fields on NIL-Reference!\n");
                exit(E_ERR_NIL_REF);
            }

            /* Check that the object is not primitive */
            if (IS_PRIM(object)) {
                printf("Error: Can't access fields on primitive objects!\n");
                exit(E_ERR_PRIM_OBJ);
            }
            
            /* Check that access is within boundaries of object */
            size = GET_SIZE(object);
            if (operand < 0 || operand > size-1) {
                printf("Error: Record index out of bounds!\n");
                exit(E_ERR_REC_INDEX);
            }

            /* Retrive the field from the object */
            fields = GET_REFS(object);
            pushObjRef(fields[operand]);
            break;
        }
        case PUTF: {
            ObjRef* fields;
            ObjRef value, object;
            int size;

            value = popObjRef();
            object = popObjRef();
            /* Check that the object is not a NULL-Pointer */
            if (object == NULL) {
                printf("ERROR: Can access fields on NIL-Reference!\n");
                exit(E_ERR_NIL_REF);
            }

            /* Check if the object is not primitive */
            if (IS_PRIM(object)) {
                printf("Error: Can't access fields on primitive objects!\n");
                exit(E_ERR_PRIM_OBJ);
            }
            
            /* Check that access is within boundaries of object */
            size = GET_SIZE(object);
            if (operand < 0 || operand > size-1) {
                printf("Error: Record index out of bounds!\n");
                exit(E_ERR_REC_INDEX);
            }

            /* Put the value into the field */
            fields = GET_REFS(object);
            fields[operand] = value;
            break;
        }
        case NEWA: {
            int size;
            ObjRef array;

            bip.op1 = popObjRef();
            size = bigToInt();

            array = newComplexObject(size);
            pushObjRef(array);
            break;
        }
        case GETFA: {
            int index, size;
            ObjRef array;
            ObjRef* fields;

            bip.op1 = popObjRef();
            index = bigToInt();

            array = popObjRef();
            if (IS_PRIM(array)) {
                printf("Error: Can't access fields on primitive objects!\n");
                exit(E_ERR_PRIM_OBJ);
            }
            
            /* Check that access is within boundaries of array */
            size = GET_SIZE(array);
            if (index < 0 || index > size-1) {
                printf("Error: Array index out of bounds!\n");
                exit(E_ERR_ARR_INDEX);
            }

            /* Retrive the field from the array */
            fields = GET_REFS(array);
            pushObjRef(fields[index]);
            break;
        }
        case PUTFA: {
            int index, size;
            ObjRef array, value;
            ObjRef* fields;

            value = popObjRef();
            bip.op1 = popObjRef();
            index = bigToInt();

            array = popObjRef();
            
            /* Check if the object is not primitive */
            if (IS_PRIM(array)) {
                printf("Error: Can't access fields on primitive objects!\n");
                exit(E_ERR_PRIM_OBJ);
            }
            
            /* Check that access is within boundaries of object */
            size = GET_SIZE(array);
            if (index < 0 || index > size-1) {
                printf("Error: Array index out of bounds!\n");
                exit(E_ERR_ARR_INDEX);
            }

            /* Put the value into the field */
            fields = GET_REFS(array);
            fields[index] = value;
            break;
        }
        case GETSZ: {
            ObjRef object;

            object = popObjRef();
            if (object == NULL) {
                printf("ERROR: Can't get size from NIL-Object!");
                exit(E_ERR_NIL_REF);
            }
            if (IS_PRIM(object)) {
                bigFromInt(-1);
                pushObjRef(bip.res);
                break;
            }

            bigFromInt(GET_SIZE(object));
            pushObjRef(bip.res);
            break;
        }
        case PUSHN: {
            pushObjRef((ObjRef) NULL);
            break;
        }
        case REFEQ: {
            ObjRef ob1, ob2;
            int res;

            ob1 = popObjRef();
            ob2 = popObjRef();
            res = ob1 == ob2;
            
            bigFromInt(res);
            pushObjRef(bip.res);
            break;
        }
        case REFNE: {
            ObjRef ob1, ob2;
            int res;

            ob1 = popObjRef();
            ob2 = popObjRef();
            res = ob1 != ob2;
            
            bigFromInt(res);
            pushObjRef(bip.res);
            break;
        }
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(E_ERR_OPCODE);
        }
    }
}
