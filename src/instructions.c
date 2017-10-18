#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include <stdio.h>


char* opcodes[] = {
    "halt", "pushc", "add", "sub", "mul", "div", "mod", "rdint", "wrint",
    "rdchr", "wrchr"
};

void execute(unsigned int opcode, int operand) {
    switch (opcode) {
        case HALT: {
            halt = TRUE;
        }
        case PUSHC: {
            push(operand);
        }
        case ADD: {
            int val1, val2, res;
            val1 = pop();
            val2 = pop();
            res = val1 + val2;
            push(res);
        }
        case SUB: {
            int val1, val2, res;
            val2 = pop();
            val1 = pop();
            res = val1 - val2;
            push(res);
        }
        case MUL: {
            int val1, val2, res;
            val1 = pop();
            val2 = pop();
            res = val1 * val2;
            push(res);
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
        }
        case RDINT: {

        }
        case WRINT: {
            int val;
            val = pop();
            printf("%d", val);
        }
        case RDCHR: {

        }
        case WRCHR: {
            char val;
            val = (char) pop();
            printf("%c", val);
        }
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(1);
        }
    }
}
