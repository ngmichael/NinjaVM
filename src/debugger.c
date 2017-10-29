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

int* programMemory;
unsigned int quit;
unsigned int run;
unsigned int pc;
unsigned int breakpoint;

unsigned int formatIdentifier;
unsigned int njvmVersion;
unsigned int instructionCount;
unsigned int globalVariableCount;    

/**
 * Reads one 'line' from stdin.
 * NOTE: Only the first 12 characters are read, the rest is truncated.
 * 
 * @return User input from stdin with a max length of 12 characters.
 */
char* getInput(void) {
    int cleanUp;
    char* input;
    char* newLine;

    cleanUp = 0;
    newLine = NULL;
    input = malloc(sizeof(unsigned char) * 12);
    if (fgets(input, 12, stdin) == NULL) {
        changeTextColor("RED");
        printf("Something went wrong while taking user input!\n");
        changeTextColor("WHITE");
        exit(1);
    }

    newLine = strchr(input, 10);
    if (newLine != NULL) { 
        *newLine = 0;
    }
    else {
        /* flush stdin */
        printf("%s ", DEBUGGER);
        changeTextColor("YELLOW");

        printf("*WARNING* ");
        changeTextColor("WHITE");

        printf("Truncated input after 12 characters!\n");
        while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }
    }

    return input;
}


/**
 * Interprets and executes commands for the debugger.
 * 
 * @param command - a char pointer pointing to a string representing a command
 * @return 0 if the command advances the program counter, 1 if it doesn't
 */
int processCommand(char* command) {

    if (strcmp("breakpoint", command) == 0){
        int newBreakpoint;
        int cleanUp;

        printf("%s Enter the number of the instruction,\n", DEBUG_BREAKPOINT);
        printf("%s 0 to clear breakpint or -1 to abort!\n", DEBUG_BREAKPOINT);
        printf("%s Set breakpoint to: ", DEBUG_BREAKPOINT);

        if (scanf("%d", &newBreakpoint) != 1) {
            /* TODO implement error handling */
        }
        while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }

        if (newBreakpoint < -1) {
            printf("%s ", DEBUG_BREAKPOINT);
            changeTextColor("YELLOW");
            printf("Malformed input! Aborting...\n");
        }
        else if (newBreakpoint == -1) {
            printf("%s Did not change breakpoint!\n", DEBUG_BREAKPOINT);
        }
        else if (newBreakpoint == 0) {
            printf("%s Clearing breakpoint...\n", DEBUG_BREAKPOINT);
            breakpoint = 0;
        }
        else {
            printf(
                "%s Setting breakpoint on instruction %d!\n",
                DEBUG_BREAKPOINT,
                newBreakpoint
            );
            breakpoint = newBreakpoint;
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if (strcmp("help", command) == 0) {

    }
    else if (strcmp("inspect", command) == 0) {
        unsigned int inspectNumber;
        int cleanUp;

        printf("%s What would you like to inspect:\n", DEBUG_INSPECT);
        printf("%s 1: Stack\n", DEBUG_INSPECT);
        printf("%s 2: Static data area\n", DEBUG_INSPECT);
        printf("%s 3: Return value register\n", DEBUG_INSPECT);
        printf("%s Choose one of the aforementioned or 0 to abort!\n", DEBUG_INSPECT);
        printf("%s ", DEBUG_INSPECT);

        if (scanf("%u", &inspectNumber) != 1) {
            /* TODO implement error handling */
        }
        while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }

        changeTextColor("CYAN");
        switch(inspectNumber) {
            case 0: {
                break;
            }

            case 1: {
                printf("%s Listing contents of stack:\n\n", DEBUG_INSPECT);
                printStack();
                printf("\n");
            }

            case 2: {
                printf("%s Listing contents of static data area:\n\n", DEBUG_INSPECT);
                printStaticDataArea();
                printf("\n");
            }

            default: {
                /* TODO: Implement error handling */
            }
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if(strcmp("list", command) == 0) {
        int oldPC;

        oldPC = pc;
        printf("%s Listing program memory:\n\n", DEBUG_LIST);

        pc = 0;
        while(pc < instructionCount) {
            int instruction;
            unsigned int opcode;
            int operand;

            instruction = programMemory[pc];
            pc++;

            opcode = instruction >> 24;
            operand = SIGN_EXTEND(IMMEDIATE(instruction));

            printf("[%08d]: ", pc-1);
            changeTextColor("GREEN");
            printf("%6s ", opcodes[opcode]);
            changeTextColor("WHITE");
            printf("%d\n", operand);
        }

        pc = oldPC;
        printf("%s End of program memory!\n", DEBUG_LIST);

        return FALSE;
    }
    else if(strcmp("quit", command) == 0) {
        changeTextColor("MAGENTA");
        printf("Halting NinjaVM...\n");
        exit(0);
        return FALSE;
    }
    else if (strcmp("run", command) == 0) {
        run = TRUE;
        return FALSE;
    }
    else if (strcmp("step", command) == 0) {
        return TRUE;
    }

    return TRUE;
}

/**
 * Main entry point for debugger.
 * 
 * @param code - A FILE pointer pointing to an opened file for reading
 */
void debug(FILE* code) {

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
    
    breakpoint = -1;
    pc = 0;
    quit = FALSE;
    run = FALSE;
    initStack(10000);

    printf("%s Initialization routine completed! Launching program...\n\n", DEBUGGER);

    printf("Ninja Virtual Machine started\n");
    while(quit != TRUE) {
        int instruction;
        int operand;
        unsigned int doExecute;
        unsigned int opcode;
        char* inputCommand;

        if (pc == breakpoint) {
            run == FALSE;
            printf("%s Reached breakpoint!\n", DEBUG_BREAKPOINT);
            breakpoint = 0;
        }
    
        doExecute = FALSE;
        instruction = programMemory[pc];
        pc = pc + 1;
        opcode = instruction >> 24;
        operand = SIGN_EXTEND(IMMEDIATE(instruction));
        
        if (run == FALSE) {
            printf("[%08d]: ", pc-1);

            changeTextColor("GREEN");
            printf("%6s ", opcodes[opcode]);
            changeTextColor("WHITE");
            printf("%d\n", operand);

            printf("%s Commands: breakpoint, help, inspect, list, quit, run, step\n", DEBUGGER);
    
            inputCommand = getInput();
            doExecute = processCommand(inputCommand);
            free(inputCommand);
        }
        else doExecute = TRUE;
        

        if (doExecute) execute(opcode, operand);
        else pc = pc - 1;

        /* Check if the halt instruction has been executed or not */
        quit = halt;
    }

    printf("Ninja Virtual Machine stopped\n");
    exit(0);
}

/*
 - inspect
        * used for inspecting various elements of the vm including stack, sda, ret
        * output could look something like this

[Inspect]: What would you like to inspect:
[Inspect]: 1: Stack
[Inspect]: 2: Static data area
[Inspect]: 3: Return value register
[Inspect]: Choose one of the aforementioned or 0 to abort!
[Inspect]:

        * The out put for stack would look something like this:

[Inpsect]: Listing content of stack:

sp ----->   [0011]: NULL
            [0010]: 231
            [0009]: 245
              .
              .
              .
            [0004]: 10
fp ----->   [0003]: 0
            [0002]: 20
            [0001]: 2367
            [0000]: 1

[Inspect]: Bottom of stack!

*/
