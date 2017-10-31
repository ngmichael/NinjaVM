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
 * 
 */
void memoryDump(char* path) {
    FILE* out;
    unsigned int i;

    printf("[Debug/MemoryDump]: Performing memory dump...\n");
    if (path == NULL) {
        printf("[Debug/MemoryDump]: ERROR: PATH IS NULL!\n");
        exit(1);
    }
    out = fopen(path, "w+");
    if (out == NULL) {
        printf("[Debug/MemoryDump]: Could not open %s: %s\n", path, strerror(errno));
        exit(1);
    }

    fprintf(out, "NinjaVM Memory Dump\n");
    fprintf(out, "Exact timestamp: %s, %s\n", __DATE__, __TIME__);
    fprintf(out, "VM Version: %u\n", VERSION);
    fprintf(out, "The instruction this dump was called on:\n");
    fprintf(out, "[%08d]: %s %d\n\n", pc-1, opcodes[programMemory[pc-1] >> 24], programMemory[pc-1] & 0x00FFFFFF);

    fprintf(out, "The stack at dump time:\n\n");
    printStackTo(out);
    fprintf(out, "\n");

    fprintf(out, "The static data area at dump time:\n\n");
    /* TODO: Call dump sda*/

    /* TODO: Dump ret*/

    fprintf(out, "Content of program memory:\n\n");
    for (i = 0; i < instructionCount; i++) {
        fprintf(out, "[%08d]: %6s %d\n", i, opcodes[programMemory[i] >> 24], programMemory[i] & 0x00FFFFFF);
    }
    fprintf(out, "** End of program memory **\n");

    fprintf(out, "----- End of dump -----\n");
    fclose(out);
}

/**
 * Reads the next integer from stdin and truncates the rest.
 */
int getNumber(void) {
    int number;
    int cleanUp;

    if (scanf("%d", &number) != 1) {
        changeTextColor("RED");
        printf("%s ", ERROR);
        if (number == EOF) {
            printf("Recived EOF from STDIN; Possible read error?\n");
            printf("%s\n", strerror(errno));
        }
        else {
            printf("Unknown error occured while reading input.\n");
        }
        changeTextColor("WHITE");
        exit(1);
    }
    while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }

    return number;
}

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
    if (input == NULL) {
        changeTextColor("RED");
        printf("%s ", ERROR);
        printf("System could not allocate 12 bytes of memory for debugger input.\n");
        changeTextColor("WHITE");
        exit(1);
    }
    if (fgets(input, 12, stdin) == NULL) {
        changeTextColor("RED");
        printf("Something went wrong while taking user input!\n");
        changeTextColor("WHITE");
        exit(1);
    }
    if (strcmp("\n", input) == 0) {
        return getInput();
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
 * Prints the content of program memory to the console
 */
void listProgramMemory(void) {
    int programCounter;
    
    printf("%s Listing program memory:\n\n", DEBUG_LIST);
    
    programCounter = 0;
    while(programCounter < instructionCount) {
        int instruction;
        unsigned int opcode;
        int operand;
    
        instruction = programMemory[programCounter];
        programCounter++;
    
        opcode = instruction >> 24;
        operand = SIGN_EXTEND(IMMEDIATE(instruction));
    
        printf("[%08d]: ", programCounter-1);
        changeTextColor("GREEN");
        printf("%6s ", opcodes[opcode]);
        changeTextColor("WHITE");
        printf("%d\n", operand);
    }
    
    printf("%s End of program memory!\n\n", DEBUG_LIST);
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
        changeTextColor("MAGENTA");

        if (scanf("%d", &newBreakpoint) != 1) {
            /* TODO implement error handling */
        }
        while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }

        if (newBreakpoint < -1) {
            changeTextColor("WHITE");
            printf("%s ", DEBUG_BREAKPOINT);
            changeTextColor("YELLOW");
            printf("Malformed input! Aborting...\n");
        }
        else if (newBreakpoint == -1) {
            changeTextColor("WHITE");
            printf("%s ", DEBUG_BREAKPOINT);
            changeTextColor("MAGENTA");
            printf("Did not change breakpoint!\n");
        }
        else if (newBreakpoint == 0) {
            changeTextColor("WHITE");
            printf("%s ", DEBUG_BREAKPOINT);
            changeTextColor("MAGENTA");
            printf("Clearing breakpoint...\n");
            breakpoint = 0;
        }
        else {
            changeTextColor("WHITE");
            printf(
                "%s Setting breakpoint on instruction ",
                DEBUG_BREAKPOINT
            );
            changeTextColor("MAGENTA");
            printf("%d!\n", newBreakpoint);
            breakpoint = newBreakpoint;
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if (strcmp("edit", command) == 0){
        unsigned int editNumber;

        printf("%s What would you like to edit:\n", DEBUG_EDIT);
        printf("%s 1: Stack\n", DEBUG_EDIT);
        printf("%s 2: Static data area\n", DEBUG_EDIT);
        printf("%s 3: Return value register\n", DEBUG_EDIT);
        printf("%s 4: Program memory\n", DEBUG_EDIT);
        printf("%s Choose one of the aforementioned or 0 to abort!\n", DEBUG_EDIT);
        printf("%s ", DEBUG_EDIT);

        editNumber = getNumber();

        switch(editNumber) {
            case 0: {
                break;
            }

            case 1: {
                int slot;
                int value;

                printf("%s Listing contents of stack:\n\n", DEBUG_EDIT);
                changeTextColor("CYAN");
                printStack();
                changeTextColor("WHITE");
                printf("\n");

                printf("%s Enter the number of the stack slot you would\n", DEBUG_EDIT);
                printf("%s like to edit or -1 to abort.\n", DEBUG_EDIT);

                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                slot = getNumber();
                changeTextColor("WHITE");

                if (slot == -1) {
                    printf("%s Aborting...\n", DEBUG_EDIT);
                    return FALSE;
                }

                if (isAccessibleStackSlot(slot) == FALSE) {
                    changeTextColor("YELLOW");
                    printf("%s *WARNING* ", DEBUG_EDIT);
                    changeTextColor("WHITE");
                    printf("%u is not an accessible stack slot!\n", slot);
                    return FALSE;
                }

                printf("%s Now enter the new value for this satck slot:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                value = getNumber();
                changeTextColor("WHITE");

                replaceStackSlotValue(slot, value);

                break;
            }

            case 2: {
                int slot;
                int value;

                printf("%s Listing contents of static data area:\n\n", DEBUG_EDIT);
                changeTextColor("CYAN");
                printStaticDataArea();
                printf("\n");
                changeTextColor("WHITE");
                
                printf("%s Enter the number of the global variable you would\n", DEBUG_EDIT);
                printf("%s like to edit or -1 to abort.\n", DEBUG_EDIT);

                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                slot = getNumber();
                changeTextColor("WHITE");
                
                if (slot == -1) {
                    printf("%s Aborting...\n", DEBUG_EDIT);
                    return FALSE;
                }

                if (hasIndex(slot) == FALSE) {
                    printf("%s ", DEBUG_EDIT);
                    changeTextColor("YELLOW");
                    printf("*WARNING* ");
                    changeTextColor("WHITE");
                    printf("Global variable %u does not exist!\n", slot);
                    return FALSE;
                }

                printf("%s Now enter the new value for this global variable:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                value = getNumber();
                changeTextColor("WHITE");

                setVariable(slot, value);
                break;
            }

            case 3: {
                printf("%s Sorry, but this feature is not implemented in this version!\n", DEBUG_EDIT);
                break;
            }

            case 4: {
                int instructionNumber;
                int instruction;
                unsigned int opcode;
                int immediate;

                listProgramMemory();
                
                printf("%s Enter the number of the instruction you would\n", DEBUG_EDIT);
                printf("%s like to edit or -1 to abort.\n", DEBUG_EDIT);

                printf("%s ", DEBUG_EDIT);
                instructionNumber = getNumber();
                
                if (instructionNumber < 0 || instructionNumber >= instructionCount) {
                    if (instructionNumber == -1) {
                        printf("%s Aborting...\n", DEBUG_EDIT);
                        return FALSE;
                    }
                    printf("%s ", DEBUG_EDIT);
                    changeTextColor("YELLOW");
                    printf("*WARNING* ");
                    changeTextColor("WHITE");
                    printf("Instruction number %d outside of program memory!\n", instructionNumber);
                    return FALSE;
                }

                printf("%s Now enter the new opcode for this instruction:\n", DEBUG_EDIT);
                printf("%s (In decimal, as a 8 bit unsigned integer)\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                changeTextColor("GREEN");
                opcode = getNumber();
                changeTextColor("WHITE");

                if (opcode > 25) {
                    printf("%s ", DEBUG_EDIT);
                    changeTextColor("YELLOW");
                    printf("*WARNING* ");
                    changeTextColor("WHITE");
                    printf("%u is an invalid opcode! Aborting...\n", opcode);
                    return FALSE;
                }

                printf("%s Set new instruction to be: ", DEBUG_EDIT);
                changeTextColor("GREEN");
                printf("%s\n", opcodes[opcode]);
                changeTextColor("WHITE");

                printf("%s Now enter the immediate value for this instruction:\n", DEBUG_EDIT);
                printf("%s (In decimal, as a 24 bit signed integer)\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                immediate = getNumber();

                instruction = opcode << 24 | IMMEDIATE(immediate);
                programMemory[instructionNumber] = instruction;
                break;
            }
            
            default: {
                printf("%s ", DEBUG_EDIT);
                changeTextColor("YELLOW");
                printf("There is no option with number '%u'...\n", editNumber);
            }
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if (strcmp("help", command) == 0) {
        printf("\n");
        changeTextColor("YELLOW");
        printf("********************* NinjaVM Debugger *********************\n\n");
        printf("Available commands:\n");
        printf(" help       - Prints this info.\n");
        printf(" breakpoint - Set a breakpoint in your assembler code at a\n");
        printf("              specified instruction.\n");

        printf(" edit       - Starts a small editor for editing program\n");
        printf("              memory, the stack, ect.\n");

        printf(" inspect    - Print the content of one of the VMs many\n");
        printf("              data-containing strcutures like the stack.\n");

        printf(" list       - List the content of program memory, displayed\n");
        printf("              as opcode | immediate.\n");

        printf(" quit       - Stops the VM at the next instruction cycle.\n");
        printf(" run        - Starts continuous execution of instrcutions\n");
        printf("              until a HALT is executed or the breakpoint\n");
        printf("              is reached.\n");

        printf(" step       - Executes the current instrcution and\n");
        printf("              advances the program counter by one.\n");
        printf("************************************************************\n\n");
        changeTextColor("WHITE");
        return FALSE;
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
            changeTextColor("RED");
            printf("%s ", ERROR);
            if (inspectNumber == EOF) {
                printf("Recived EOF from STDIN; Possible read error?\n");
                printf("%s\n", strerror(errno));
            }
            else {
                printf("Unknown error occured while reading inspect input.\n");
            }
            changeTextColor("WHITE");
            exit(1);
        }
        while ((cleanUp = getchar()) != '\n' && cleanUp != EOF) { }

        switch(inspectNumber) {
            case 0: {
                break;
            }

            case 1: {
                printf("%s Listing contents of stack:\n\n", DEBUG_INSPECT);
                changeTextColor("CYAN");
                printStack();
                printf("\n");
                break;
            }

            case 2: {
                printf("%s Listing contents of static data area:\n\n", DEBUG_INSPECT);
                changeTextColor("CYAN");
                printStaticDataArea();
                printf("\n");
                break;
            }

            case 3: {
                printf("%s Sorry, but this feature is not implemented in this version!\n", DEBUG_INSPECT);
                break;
            }

            default: {
                printf("%s ", DEBUG_INSPECT);
                changeTextColor("YELLOW");
                printf("There is no option with number '%u'...\n", inspectNumber);
            }
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if(strcmp("list", command) == 0) {
        listProgramMemory();
        return FALSE;
    }
    else if(strcmp("quit", command) == 0) {
        printf("[Debugger/Quit]: ");
        changeTextColor("YELLOW");
        printf("Halting NinjaVM...\n");
        changeTextColor("WHITE");
        quit = TRUE;
        return FALSE;
    }
    else if (strcmp("run", command) == 0) {
        run = TRUE;
        return FALSE;
    }
    else if (strcmp("step", command) == 0) {
        return TRUE;
    }
    else if (strcmp("", command) == 0) {
        return TRUE;
    }
    else {
        printf("%s ", DEBUGGER);
        changeTextColor("YELLOW");
        printf("Unrecognized command: '%s'\n", command);
        changeTextColor("WHITE");
        return FALSE;
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
        changeTextColor("RED");
        printf("ERROR\n%s Not a Ninja program!\n", DEBUGGER);
        exit(1);
    }
    changeTextColor("GREEN");
    printf("[OK]\n");
    changeTextColor("WHITE");
    
    /* Validate that the Ninja-Program is compiled for this version of the VM. */
    printf("%s Checking if program is compiled for this VM version...", DEBUGGER);
    fread(&njvmVersion, 1, sizeof(unsigned int), code);
    if (njvmVersion != VERSION){
        changeTextColor("RED");
        printf("ERROR!\n");
        printf("%s VM: %02x, PROGRAM: %02x\n", DEBUGGER, VERSION, njvmVersion);
        exit(1);
    }
    changeTextColor("GREEN");
    printf("[OK]\n");
    changeTextColor("WHITE");
    
    /* Allocate memory to store the instructions of the Ninja-Program. */
    printf("%s Reading instruction count and allocating program memory...", DEBUGGER);
    fread(&instructionCount, 1, sizeof(unsigned int), code);
    programMemory = malloc(sizeof(unsigned int)*instructionCount);
    if (programMemory == NULL) {
        changeTextColor("RED");
        printf("ERROR!\n");
        printf(
            "%s System could not allocate %lu of memory for program\n",
            DEBUGGER, 
            sizeof(unsigned int) * instructionCount
        );
        exit(1);
    }
    changeTextColor("GREEN");
    printf("[OK]\n");
    changeTextColor("WHITE");

    /* Allocate memory for the static data area. */
    printf("%s Allocating memory for the static data area...", DEBUGGER);
    fread(&globalVariableCount, 1, sizeof(int), code);
    initSda(globalVariableCount);
    changeTextColor("GREEN");
    printf("[OK]\n");
    changeTextColor("WHITE");
    
    /* Read all remaining data (instructions) into programMemory. */
    printf("%s Loading instructions into program memory...", DEBUGGER);
    fread(programMemory, 1, sizeof(int)*instructionCount, code);
    changeTextColor("GREEN");
    printf("[OK]\n");
    changeTextColor("WHITE");
    
    /* Close the file.*/
    fileClose = fclose(code);
    if (fileClose != 0) {
        changeTextColor("RED");
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
            run = FALSE;
            printf("%s ", DEBUG_BREAKPOINT);
            changeTextColor("MAGENTA");
            printf("Reached breakpoint!\n");
            changeTextColor("WHITE");
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

            printf("%s Commands: breakpoint, edit, help, inspect, list, quit, run, step\n", DEBUGGER);
    
            inputCommand = getInput();
            doExecute = processCommand(inputCommand);
            free(inputCommand);
        }
        else doExecute = TRUE;
        

        if (doExecute) execute(opcode, operand);
        else pc = pc - 1;

        /* Check if the halt instruction has been executed or not */
        if (halt == TRUE) quit = TRUE;
    }

    printf("Ninja Virtual Machine stopped\n");

    memoryDump("test.txt");

    exit(0);
}
