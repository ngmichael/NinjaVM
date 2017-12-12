#include <stdio.h>
#include <stdlib.h>
#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include "headers/sda.h"
#include "../lib/support.h"
#include "../lib/bigint.h"

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
            bip.op1 = popObjRef();
            bip.op2 = popObjRef();
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
            bip.op1 = popObjRef();
            bip.op2 = popObjRef();
            bigDiv();
            pushObjRef(bip.res);
            break;
        }
        case MOD: {
            bip.op1 = popObjRef();
            bip.op2 = popObjRef();
            bigDiv();
            pushObjRef(bip.rem);
        }
        case RDINT: {
            bigRead(stdin);
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
