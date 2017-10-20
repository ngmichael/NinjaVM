#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
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

    FILE* code;
    int args;
    unsigned int ninjaIdentifier, ninjaVmVer, staticVarCount, irCount;

    programMemory = NULL;

    /*
     * Interpret command line arguments
     * Start at one to exclude launch path
     */
    for (args = 1; args < argc; args++){
        if (strcmp("--help", argv[args]) == 0) {
            printf("\nusage: ./njvm [options] codefile\n");
            printf("Options:\n");
            printf("\t--help\t\tDisplays this help.\n");
            printf("\t--version\tDsiplays version number of the VM.\n");
            return 0;
        }
        else if (strcmp("--version", argv[args]) == 0) {
            printf("Ninija Virtual Machine Version %u\n", VERSION);
            return 0;
        }
        /* 
         * If the argument does not start with a "--" it is
         * the path to the program file
         */
        else if (strstr(argv[args], "--") == NULL) {
            /* Try to load the file */
            code = fopen(argv[args], "r");
            /* Check if the file has been opened successfully... */
            if (code == NULL){
                printf("Could not open %s: %s\n", argv[args], strerror(errno));
                return errno;
            }
        }
        else {
            /* Catch any unknown arguments and terminate */
            printf("Error: Unrecognized argument '%s'\n", argv[args]);
            return 1;
        }
    }

    /*Validate that the loaded file is a Ninja-Program*/
    fread(&ninjaIdentifier, 1, sizeof(unsigned int), code);
    if (ninjaIdentifier != 0x46424a4e){
        printf("Not a Ninja program!\n");
        return 1;
    }
    
    /*Validate that the Ninja-Program is compiled for this version of the VM.*/
    fread(&ninjaVmVer, 1, sizeof(unsigned int), code);
    if (ninjaVmVer != VERSION){
        printf("Wrong VM version!\n");
        printf("VM: %02x, PROGRAM: %02x\n", VERSION, ninjaVmVer);
        return 1;
    }
    
    /*Allocate memory to store the instructions of the Ninja-Program.*/
    fread(&irCount, 1, sizeof(int), code);
    programMemory = malloc(sizeof(int)*irCount);

    /*Allocate memory for the static data area.*/
    fread(&staticVarCount, 1, sizeof(int), code);
    /* Call sda initialization routine once the sda is implemented */
    
    /*Read all remaining data (instructions) into programMemory.*/
    fread(programMemory, 1, sizeof(int)*irCount, code);
    
    /*Close the file.*/
    fclose(code);

    if (programMemory == NULL) {
        printf("Error: No code file specified!\n");
        return 1;
    }

    pc = 0;
    halt = FALSE;
    initStack(10000);

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
