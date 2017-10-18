#include "headers/instructions.h"
#include "headers/stack.h"
#include "headers/njvm.h"
#include <stdio.h>
#include <stdlib.h>

char* opcodes[] = {
    "halt", "pushc", "add", "sub", "mul", "div", "mod", "rdint", "wrint",
    "rdchr", "wrchr"
};

/**
 * Executes an insturction with its operand.
 * 
 * @param opcode - the instructionto be executed
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
            int cleanUp;
            int read;
            scanf("%d", &read);
            push(read);
            while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }
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
            int cleanUp;
            scanf("%c", &read);
            push((int) read);
            while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }
            break;
        }
        case WRCHR: {
            char val;
            val = (char) pop();
            printf("%c", val);
            break;
        }
        default: {
            printf("Error: Illegal opcode: %u\n", opcode);
            exit(1);
        }
    }
}
