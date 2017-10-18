#include <stdio.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "headers/instructions.h"

int halt, pc;
unsigned int* programMemory;

/**
 * Main entry point - called at program launch
 *
 * @param argc - number of command line arguments
 * @param argv - an Array containing the command line arguments
 * @return 0 if program executed without error, non-zero value otherwise
 */
int main(int argc, char* argv[]) {

    int args;

    pc = 0;
    programMemory = NULL;
    halt = FALSE;
    initStack(256);

    /*
     * Interpret command line arguments
     * Start at one to exclude launch path
     */
    for (args = 1; args < argc; args++){
        if (strcmp("--help", argv[args]) == 0) {
            printf("\nusage: ./njvm [options]\n");
            printf("Options:\n");
            printf("\t--help\t\tDisplays this help.\n");
            printf("\t--version\tDsiplays version number of the VM.\n");
            printf("\t--prog1\t\tRun program 1.\n");
            return 0;
        }
        else if (strcmp("--version", argv[args]) == 0) {
            printf("Ninija Virtual Machine Version %u\n", VERSION);
            return 0;
        }
        else if (strcmp("--prog1", argv[args]) == 0) {
            const unsigned int prog1[11] = {
                PUSHC   << 24 || IMMEDIATE(3),
                PUSHC   << 24 || IMMEDIATE(4),
                ADD     << 24,
                PUSHC   << 24 || IMMEDIATE(10),
                PUSHC   << 24 || IMMEDIATE(6),
                SUB     << 24,
                MUL     << 24,
                WRINT   << 24,
                PUSHC   << 24 || IMMEDIATE(10),
                WRCHR   << 24,
                HALT    << 24
            };
            printf("%d  %d", prog1[1] >> 24, prog1[1] & 0x00FFFFFF);
            programMemory = malloc(sizeof(unsigned int) * 11);
            memcpy(programMemory, prog1, 11);
        }
        else {
            /* Catch any unknown arguments and terminate */
            printf("Error: Unrecognized argument '%s'\n", argv[args]);
            return 1;
        }
    }

    printf("Ninja Virtual Machine started\n");
    while (halt != TRUE) {
        unsigned int instruction, opcode;
        int operand;

        /* Load instruction */
        instruction = programMemory[pc];

        /* Increment program counter */
        pc = pc + 1;

        /* Decode instruction into opcode and immediate value */
        opcode = instruction >> 24;
        operand = SIGN_EXTEND(IMMEDIATE(instruction));
        
        /* Execute instruction */
        execute(opcode, operand);
    }
    printf("Ninja Virtual Machine stopped\n");

    return 0;
}
