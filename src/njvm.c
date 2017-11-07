#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "headers/instructions.h"
#include "headers/sda.h"
#include "headers/debugger.h"
#include "headers/utils.h"

int halt;
unsigned int pc;
unsigned int* programMemory;

int returnValueRegister;

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
    int fileClose;
    unsigned int formatIdentifier;
    unsigned int njvmVersion;
    unsigned int globalVariableCount;
    unsigned int instructionCount;

    unsigned int runDebugger;

    runDebugger = FALSE;
    programMemory = NULL;
    code = NULL;

    /*
     * Interpret command line arguments
     * Start at one to exclude launch path
     */
    for (args = 1; args < argc; args++){
        if (strcmp("--help", argv[args]) == 0) {
            printf("\nusage: ./njvm [options] codefile\n");
            printf("Options:\n");
            printf("\t--help\t\tDisplays this help.\n");
            printf("\t--version\tDisplays version number of the VM.\n");
            printf("\t--debug\t\tLaunches the NinjaVM debugger.\n");
            return 0;
        }
        else if (strcmp("--version", argv[args]) == 0) {
            printf("Ninja Virtual Machine Version %u (compiled %s, %s)\n", VERSION, __DATE__, __TIME__);
            return 0;
        }
        else if (strcmp("--debug", argv[args]) == 0) {
            runDebugger = TRUE;
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
                return E_ERR_IO_FILE;
            }
        }
        else {
            /* Catch any unknown arguments and terminate */
            printf("Error: Unrecognized argument '%s'\n", argv[args]);
            return E_ERR_CLI;
        }
    }

    /* Check if a codefile has been specified */
    if (code == NULL) {
        printf("Error: No code file specified!\n"); 
        return E_ERR_NO_PROGF;
    }

    if (runDebugger == TRUE) {
        debug(code);
        /* We should NEVER reach this part of the function.
           If we do, there is a bug in the debugger.*/
        exit(E_ERR_KILL_DEBUG);
    }

    /* Validate that the loaded file is a Ninja-Program */
    fread(&formatIdentifier, 1, sizeof(unsigned int), code);
    if (formatIdentifier != 0x46424a4e){
        printf("Not a Ninja program!\n");
        return E_ERR_NO_NJPROG;
    }
    
    /* Validate that the Ninja-Program is compiled for this version of the VM. */
    fread(&njvmVersion, 1, sizeof(unsigned int), code);
    if (njvmVersion != VERSION){
        printf("Wrong VM version!\n");
        printf("VM: %02x, PROGRAM: %02x\n", VERSION, njvmVersion);
        return E_ERR_VM_VER;
    }
    
    /* Allocate memory to store the instructions of the Ninja-Program. */
    fread(&instructionCount, 1, sizeof(unsigned int), code);
    programMemory = malloc(sizeof(unsigned int)*instructionCount);
    if (programMemory == NULL) {
        printf(
            "Error: System could not allocate %lu of memory for program\n",
            sizeof(unsigned int) * instructionCount
        );
        return E_ERR_SYS_MEM;
    }

    /* Allocate memory for the static data area. */
    fread(&globalVariableCount, 1, sizeof(int), code);
    initSda(globalVariableCount);
    
    /* Read all remaining data (instructions) into programMemory. */
    fread(programMemory, instructionCount, sizeof(unsigned int), code);
    
    /* Close the file.*/
    fileClose = fclose(code);
    if (fileClose != 0) {
        printf("Error: Could not close program file after reading:\n");
        printf("%s\n", strerror(errno));
        return E_ERR_IO_FILE;
    }

    pc = 0;
    halt = FALSE;
    initStack(10000);
    returnValueRegister = 0;

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

    return E_EXECOK;
}
