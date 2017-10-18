#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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
    initStack(10000);

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
                PUSHC   << 24 | IMMEDIATE(3),
                PUSHC   << 24 | IMMEDIATE(4),
                ADD     << 24,
                PUSHC   << 24 | IMMEDIATE(10),
                PUSHC   << 24 | IMMEDIATE(6),
                SUB     << 24,
                MUL     << 24,
                WRINT   << 24,
                PUSHC   << 24 | IMMEDIATE(10),
                WRCHR   << 24,
                HALT    << 24
            };
            programMemory = malloc(sizeof(unsigned int) * 11);
            memcpy(programMemory, prog1, sizeof(unsigned int) * 11);
        }
        else if (strcmp("--prog2", argv[args]) == 0) {
            const unsigned int prog1[9] = {
                PUSHC   << 24 | IMMEDIATE(-2),
                RDINT   << 24,
                MUL     << 24,
                PUSHC   << 24 | IMMEDIATE(3),
                ADD     << 24,
                WRINT   << 24,
                PUSHC   << 24 | IMMEDIATE(10),
                WRCHR   << 24,
                HALT    << 24
            };
            programMemory = malloc(sizeof(unsigned int) * 9);
            memcpy(programMemory, prog1, sizeof(unsigned int) * 9);
        }
        else if (strcmp("--prog3", argv[args]) == 0) {
            const unsigned int prog1[5] = {
                RDCHR   << 24,
                WRINT   << 24,
                PUSHC   << 24 | IMMEDIATE(10),
                WRCHR   << 24,
                HALT    << 24
            };
            programMemory = malloc(sizeof(unsigned int) * 5);
            memcpy(programMemory, prog1, sizeof(unsigned int) * 5);
        }
        else {
            /* Catch any unknown arguments and terminate */
            printf("Error: Unrecognized argument '%s'\n", argv[args]);
            return 1;
        }
    }

    if (programMemory == NULL) {
        printf("Error: No code file specified!\n");
        return 1;
    }

    printf("Listing contents of program memory:\n");
    do {
        printf("[%04d]:%6s %d\n", pc, opcodes[programMemory[pc] >> 24], SIGN_EXTEND(IMMEDIATE(programMemory[pc])));
        pc = pc + 1;
    } while (programMemory[pc] >> 24 != HALT);

    printf("[%04d]:%6s %d\n", pc, opcodes[programMemory[pc] >> 24], SIGN_EXTEND(IMMEDIATE(programMemory[pc])));
    pc = 0;

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
