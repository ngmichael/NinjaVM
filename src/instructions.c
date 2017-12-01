#include <stdio.h>
#include <stdlib.h>
#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include "headers/sda.h"

char* opcodes[] = {
    "HALT", "PUSHC", "ADD", "SUB", "MUL", "DIV", "MOD", "RDINT", "WRINT",
    "RDCHR", "WRCHR", "PUSHG", "POPG", "ASF", "RSF", "PUSHL", "POPL", "EQ",
    "NE", "LT", "LE", "GT", "GE", "JMP", "BRF", "BRT", "CALL", "RET", "DROP",
    "PUSHR", "POPR", "DUP",
};

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
            break;
        }
        case PUSHC: {
            pushObjRef(operand);
            break;
        }
        case ADD: {
            int val1, val2, res;
            val1 = popObjRef();
            val2 = popObjRef();
            res = val1 + val2;
            pushObjRef(res);
            break;
        }
        case SUB: {
            int val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            res = val1 - val2;
            pushObjRef(res);
            break;
        }
        case MUL: {
            int val1, val2, res;
            val1 = popObjRef();
            val2 = popObjRef();
            res = val1 * val2;
            pushObjRef(res);
            break;
        }
        case DIV: {
            int val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            
            if (val2 == 0) {
                printf("Error: Division by zero\n");
                exit(E_ERR_DIV_BY_ZERO);
            }

            res = val1 / val2;
            pushObjRef(res);
            break;
        }
        case MOD: {
            int val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            
            if (val2 == 0) {
                printf("Error: Division by zero\n");
                exit(E_ERR_DIV_BY_ZERO);
            }

            res = val1 % val2;
            pushObjRef(res);
            break;
        }
        case RDINT: {
            int read, result;
            result = scanf(" %d", &read);
            if (result == 0 || result == EOF) {
                printf("Error: Something went wrong while taking user input!\n");
                exit(E_ERR_IO_SHELL);
            }
            pushObjRef(read);
            break;
        }
        case WRINT: {
            int val;
            val = popObjRef();
            printf("%d", val);
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
            pushObjRef((int) read);
            break;
        }
        case WRCHR: {
            char val;
            val = (char) popObjRef();
            printf("%c", val);
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
            int val1, val2, res;
            
            val1 = popObjRef();
            val2 = popObjRef();
            res = val1 == val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case NE: {
            int val1, val2, res;
            
            val1 = popObjRef();
            val2 = popObjRef();
            res = val1 != val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case LT: {
            int val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = val1 < val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case LE: {
            int val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = val1 <= val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case GT: {
            int val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = val1 > val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case GE: {
            int val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = val1 >= val2 ? TRUE : FALSE;
            pushObjRef(res);
            break;
        }
        case JMP: {
            pc = operand;
            break;
        }
        case BRF: {
            int value = popObjRef();
            if (value == FALSE) pc = operand;
            break;
        }
        case BRT: {
            int value = popObjRef();
            if (value == TRUE) pc = operand;
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
            int value;

            value = pop();
            pushObjRef(value);
            pushObjRef(value);
            break;
        }
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(E_ERR_OPCODE);
        }
    }
}
