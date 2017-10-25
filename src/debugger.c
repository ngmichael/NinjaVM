#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "headers/instructions.h"
#include "headers/sda.h"
#include "headers/debugger.h"

int* programMemory;
int quit;
unsigned int pc;    

char* getInput() {
    /* TODO: Implement */
    return "";
}

void debug(FILE* code) {

    unsigned int formatIdentifier;
    unsigned int njvmVersion;
    unsigned int instructionCount;
    unsigned int globalVariableCount;

    int fileClose;

    printf("%s Launching NinjaVM in debug mode...\n", DEBUGGER);
    printf("%s Loading program...\n", DEBUGGER);

    /* Validate that the loaded file is a Ninja-Program */
    printf("%s Checking if file is a NinjaVM program...", DEBUGGER);
    fread(&formatIdentifier, 1, sizeof(unsigned int), code);
    if (formatIdentifier != 0x46424a4e){
        printf("ERROR\n%s Not a Ninja program!\n", DEBUGGER);
        exit(1);
    }
    printf("OK\n");
    
    /* Validate that the Ninja-Program is compiled for this version of the VM. */
    printf("%s Checking if program is compiled for this VM version...", DEBUGGER);
    fread(&njvmVersion, 1, sizeof(unsigned int), code);
    if (njvmVersion != VERSION){
        printf("ERROR!\n");
        printf("%s VM: %02x, PROGRAM: %02x\n", DEBUGGER, VERSION, njvmVersion);
        exit(1);
    }
    printf("OK!\n");
    
    /* Allocate memory to store the instructions of the Ninja-Program. */
    printf("%s Reading instruction count and allocating program memory...", DEBUGGER);
    fread(&instructionCount, 1, sizeof(unsigned int), code);
    programMemory = malloc(sizeof(unsigned int)*instructionCount);
    if (programMemory == NULL) {
        printf("ERROR!\n");
        printf(
            "%s System could not allocate %lu of memory for program\n",
            DEBUGGER, 
            sizeof(unsigned int) * instructionCount
        );
        exit(1);
    }
    printf("OK!\n");

    /* Allocate memory for the static data area. */
    printf("%s Allocating memory for the static data area...", DEBUGGER);
    fread(&globalVariableCount, 1, sizeof(int), code);
    initSda(globalVariableCount);
    printf("OK!\n");
    
    /* Read all remaining data (instructions) into programMemory. */
    printf("%s Loading instructions into program memory...", DEBUGGER);
    fread(programMemory, 1, sizeof(int)*instructionCount, code);
    printf("OK\n");
    
    /* Close the file.*/
    fileClose = fclose(code);
    if (fileClose != 0) {
        printf("Error: Could not close program file after reading:\n");
        printf("%s\n", strerror(errno));
        exit(1);
    }
    
    pc = 0;
    quit = FALSE;

    printf("%s Initialization routine completed! Launching program...\n", DEBUGGER);

    while(quit != TRUE) {
        int instruction;
        int operand;
        unsigned int opcode;
        char* inputCommand;
    
        instruction = programMemory[pc];
        pc = pc + 1;
        opcode = instruction >> 24;
        operand = SIGN_EXTEND(IMMEDIATE(instruction));
    
        printf("[%08d]: %s %d\n", pc-1, opcodes[opcode], operand);
        printf("%s Commands: breakpoint, help, inspect, list, quit, run, step\n", DEBUGGER);
        inputCommand = getInput();
        
        /*TODO: Interpret input here*/


        if (opcode == HALT) {
            quit = TRUE;
        }
    }

    exit(0);
}

