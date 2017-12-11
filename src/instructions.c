#include <stdio.h>
#include <stdlib.h>
#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include "headers/sda.h"
#include "../lib/support.h"

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
            ObjRef object;

            object = newPrimObject(sizeof(int));
            *(int *)object->data = operand;

            pushObjRef(object);
            break;
        }
        case ADD: {
            ObjRef val1, val2, res;
            val1 = popObjRef();
            val2 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int*)res->data = *(int*)val1->data + *(int*)val2->data;
            pushObjRef(res);
            break;
        }
        case SUB: {
            ObjRef val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int*)res->data = *(int*)val1->data - *(int*)val2->data;
            pushObjRef(res);
            break;
        }
        case MUL: {
            ObjRef val1, val2, res;
            val1 = popObjRef();
            val2 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int*)res->data = *(int*)val1->data * *(int*)val2->data;
            pushObjRef(res);
            break;
        }
        case DIV: {
            ObjRef val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            
            if (*(int *)val2->data == 0) {
                printf("Error: Division by zero\n");
                exit(E_ERR_DIV_BY_ZERO);
            }

            res = newPrimObject(sizeof(int));
            *(int*)res->data = *(int*)val1->data / *(int*)val2->data;
            pushObjRef(res);
            break;
        }
        case MOD: {
            ObjRef val1, val2, res;
            val2 = popObjRef();
            val1 = popObjRef();
            
            if (*(int *)val2->data == 0) {
                printf("Error: Division by zero\n");
                exit(E_ERR_DIV_BY_ZERO);
            }

            res = newPrimObject(sizeof(int));
            *(int*)res->data = *(int*)val1->data % *(int*)val2->data;
            pushObjRef(res);
            break;
        }
        case RDINT: {
            ObjRef object;
            int read, result;
            result = scanf(" %d", &read);
            if (result == 0 || result == EOF) {
                printf("Error: Something went wrong while taking user input!\n");
                exit(E_ERR_IO_SHELL);
            }
            object = newPrimObject(sizeof(int));
            *(int *)object->data = read;
            pushObjRef(object);
            break;
        }
        case WRINT: {
            ObjRef val;
            val = popObjRef();
            printf("%d", *(int *)val->data);
            break;
        }
        case RDCHR: {
            ObjRef object;
            char read;
            int result;
            result = scanf(" %c", &read);
            if (result == 0 || result == EOF) {
                printf("Error: Something went wrong while taking user input!\n");
                exit(E_ERR_IO_SHELL);
            }
            object = newPrimObject(sizeof(int));
            *(int *)object->data = (int)read;
            pushObjRef(object);
            break;
        }
        case WRCHR: {
            ObjRef val;
            val = popObjRef();
            printf("%c", *val->data);
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
            ObjRef val1, val2, res;
            
            val1 = popObjRef();
            val2 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data == *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case NE: {
            ObjRef val1, val2, res;
            
            val1 = popObjRef();
            val2 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data != *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case LT: {
            ObjRef val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data < *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case LE: {
            ObjRef val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data <= *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case GT: {
            ObjRef val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data > *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case GE: {
            ObjRef val1, val2, res;
            
            val2 = popObjRef();
            val1 = popObjRef();
            res = newPrimObject(sizeof(int));
            *(int *)res->data = *(int *)val1->data >= *(int *)val2->data ? TRUE : FALSE; 
            pushObjRef(res);
            break;
        }
        case JMP: {
            pc = operand;
            break;
        }
        case BRF: {
            ObjRef value;

            value = popObjRef();
            if (*(int *)value->data == FALSE) pc = operand;
            break;
        }
        case BRT: {
            ObjRef value;
            
            value = popObjRef();
            if (*(int *)value->data == TRUE) pc = operand;
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
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(E_ERR_OPCODE);
        }
    }
}
