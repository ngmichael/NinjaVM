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
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(E_ERR_OPCODE);
        }
    }
}
