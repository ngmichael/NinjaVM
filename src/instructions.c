#include <stdio.h>
#include <stdlib.h>
#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include "headers/sda.h"

char* opcodes[] = {
    "HALT", "PUSHC", "ADD", "SUB", "MUL", "DIV", "MOD", "RDINT", "WRINT",
    "RDCHR", "WRCHR", "PUSHG", "POPG", "ASF", "RSF", "PUSHL", "POPL", "EQ",
    "NE", "LT", "LE", "GT", "GE", "JMP", "BRF", "BRT",
};

/**
 * Executes an insturction with its operand.
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
            push(operand);
            break;
        }
        case ADD: {
            int val1, val2, res;
            val1 = pop();
            val2 = pop();
            res = val1 + val2;
            push(res);
            break;
        }
        case SUB: {
            int val1, val2, res;
            val2 = pop();
            val1 = pop();
            res = val1 - val2;
            push(res);
            break;
        }
        case MUL: {
            int val1, val2, res;
            val1 = pop();
            val2 = pop();
            res = val1 * val2;
            push(res);
            break;
        }
        case DIV: {
            int val1, val2, res;
            val2 = pop();
            val1 = pop();
            
            if (val1 == 0 || val2 == 0) {
                printf("Error: Division by zero\n");
                exit(1);
            }

            res = val1 / val2;
            push(res);
            break;
        }
        case MOD: {
            int val1, val2, res;
            val2 = pop();
            val1 = pop();
            
            if (val1 == 0 || val2 == 0) {
                printf("Error: Division by zero\n");
                exit(1);
            }

            res = val1 % val2;
            push(res);
            break;
        }
        case RDINT: {
            int read;
            scanf("%d", &read);
            push(read);
            break;
        }
        case WRINT: {
            int val;
            val = pop();
            printf("%d", val);
            break;
        }
        case RDCHR: {
            char read;
            scanf("%c", &read);
            push((int) read);
            break;
        }
        case WRCHR: {
            char val;
            val = (char) pop();
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
            
            val1 = pop();
            val2 = pop();
            res = val1 == val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case NE: {
            int val1, val2, res;
            
            val1 = pop();
            val2 = pop();
            res = val1 != val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case LT: {
            int val1, val2, res;
            
            val2 = pop();
            val1 = pop();
            res = val1 < val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case LE: {
            int val1, val2, res;
            
            val2 = pop();
            val1 = pop();
            res = val1 <= val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case GT: {
            int val1, val2, res;
            
            val2 = pop();
            val1 = pop();
            res = val1 > val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case GE: {
            int val1, val2, res;
            
            val2 = pop();
            val1 = pop();
            res = val1 >= val2 ? TRUE : FALSE;
            push(res);
            break;
        }
        case JMP: {
            pc = operand;
            break;
        }
        case BRF: {
            int value = pop();
            if (value == FALSE) pc = operand;
            break;
        }
        case BRT: {
            int value = pop();
            if (value == TRUE) pc = operand;
            break;
        }
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(1);
        }
    }
}
