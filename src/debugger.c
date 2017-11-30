#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <strings.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "headers/instructions.h"
#include "headers/sda.h"
#include "headers/debugger.h"
#include "headers/utils.h"

unsigned int run;
unsigned int breakpoint;
unsigned int quit;
unsigned int verbose;

/**
 * Dumps program memory, stack content and static data area
 * content into the file specified by path.
 * If the file does not exist, it will be created. If it does exist,
 * its content will be DISCARDED!
 * 
 * See man page for fopen with mode 'w+'
 * $ man 3 fopen
 * 
 * @param path - the path of the file to dump memory to
 */
void memoryDump(char* path) {
    FILE* out;
    unsigned int i;

    printf("%s Performing memory dump...\n", DEBUG_DUMP);
    if (path == NULL) {
        printf("%s ERROR: PATH IS NULL!\n", DEBUG_DUMP);
        exit(E_ERR_IO_SHELL);
    }
    out = fopen(path, "w+");
    if (out == NULL) {
        printf("%s Could not open %s: %s\n", DEBUG_DUMP, path, strerror(errno));
        exit(E_ERR_IO_FILE);
    }

    fprintf(out, "NinjaVM Memory Dump\n");
    fprintf(out, "Exact timestamp: %s, %s\n", __DATE__, __TIME__);
    fprintf(out, "VM Version: %u\n", VERSION);
    fprintf(out, "The most recently executed instruction:\n");
    fprintf(out, "[%08d]: %s %d\n\n", pc-1, opcodes[programMemory[pc-1] >> 24], programMemory[pc-1] & 0x00FFFFFF);

    fprintf(out, "The stack at dump time:\n\n");
    printStackTo(out);
    fprintf(out, "\n");

    fprintf(out, "The static data area at dump time:\n\n");
    printStaticDataAreaTo(out);
    fprintf(out, "\n");

    fprintf(out, "The content of the return value register: %d\n", returnValueRegister);
    fprintf(out, "\n");

    fprintf(out, "Content of program memory:\n\n");
    for (i = 0; i < instructionCount; i++) {
        fprintf(out, "[%08d]: %6s %d\n", i, opcodes[programMemory[i] >> 24], SIGN_EXTEND(IMMEDIATE(programMemory[i])));
    }
    fprintf(out, "** End of program memory **\n");
    fprintf(out, "\n");

    fprintf(out, "----- End of dump -----\n");
    fclose(out);
}

/**
 * Reads the next integer from stdin and truncates the rest.
 * 
 * @return the first number found in stdin as signed int
 */
int getNumber(void) {
    int number;
    int cleanUp;

    if (scanf("%d", &number) != 1) {
        changeTextColor("RED");
        printf("%s ", ERROR);
        if (number == EOF) {
            printf("Received EOF from STDIN; Possible read error?\n");
            printf("%s\n", strerror(errno));
        }
        else {
            printf("Read unexpected string from STDIN!\n");
        }
        changeTextColor("WHITE");
        exit(E_ERR_IO_SHELL);
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
    input = calloc(12, sizeof(unsigned char));
    if (input == NULL) {
        changeTextColor("RED");
        printf("%s ", ERROR);
        printf("System could not allocate 12 bytes of memory for debugger input.\n");
        changeTextColor("WHITE");
        exit(E_ERR_IO_SHELL);
    }
    if (fgets(input, 12, stdin) == NULL) {
        changeTextColor("RED");
        printf("Something went wrong while taking user input!\n");
        changeTextColor("WHITE");
        exit(E_ERR_IO_SHELL);
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
    
    printf("%s Listing program memory:\n\n", DEBUG_INSPECT);
    
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
    
    printf("%s End of program memory!\n\n", DEBUG_INSPECT);
}


/**
 * Interprets and executes commands for the debugger.
 * 
 * @param command - the command as a string
 * @return 0 if the command advances the program counter, 1 if it doesn't
 */
int processCommand(char* command) {

    if (strcmp("breakpoint", command) == 0){
        int newBreakpoint;

        printf("%s Enter the number of the instruction,\n", DEBUG_BREAKPOINT);
        printf("%s 0 to clear breakpint or -1 to abort!\n", DEBUG_BREAKPOINT);
        printf("%s Set breakpoint to: ", DEBUG_BREAKPOINT);
        changeTextColor("MAGENTA");

        newBreakpoint = getNumber();

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
            printf("%d", newBreakpoint);
            changeTextColor("WHITE");
            printf("!\n");
            breakpoint = newBreakpoint;
        }

        changeTextColor("WHITE");
        return FALSE;
    }
    else if (strcmp("dump", command) == 0) {
        char* path;
        int i;

        printf("%s Please specify a file path to dump memory to.\n", DEBUG_DUMP);
        printf("%s ", DEBUG_DUMP);
        changeTextColor("YELLOW");
        printf("*WARNING* ");
        printf("IF THE FILE EXISTS IT WILL BE OVERWRITTEN!\n");
        changeTextColor("WHITE");
        printf("%s ", DEBUG_DUMP);
        changeTextColor("YELLOW");
        printf("*WARNING* ");
        changeTextColor("WHITE");
        printf("Input will be truncated after 128 characters!\n");
        printf("%s ", DEBUG_DUMP);

        path = (char*) calloc(128, sizeof(char));
        fgets(path, 128, stdin);
        for (i = 0; i < 128; i++) {
            if (path[i] == '\n') {
                path[i] = 0;
                break;
            }
        }

        memoryDump(path);
        free(path);
        return FALSE;
    }
    else if (strcmp("edit", command) == 0){
        unsigned int editNumber;

        printf("%s What would you like to edit:\n", DEBUG_EDIT);
        printf("%s 1: Stack\n", DEBUG_EDIT);
        printf("%s 2: Static data area\n", DEBUG_EDIT);
        printf("%s 3: Return value register\n", DEBUG_EDIT);
        printf("%s 4: Program memory\n", DEBUG_EDIT);
        printf("%s 5: Program Counter\n", DEBUG_EDIT);
        printf("%s 6: Stack Pointer\n", DEBUG_EDIT);
        printf("%s 7: Stack-Frame Pointer\n", DEBUG_EDIT);
        printf("%s Choose one of the aforementioned or 0 to abort!\n", DEBUG_EDIT);
        printf("%s ", DEBUG_EDIT);

        editNumber = getNumber();

        switch(editNumber) {
            case 0: { /* Abort */
                break;
            }

            case 1: { /* Stack */
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

                printf("%s Now enter the new value for this stack slot:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                value = getNumber();
                changeTextColor("WHITE");

                replaceStackSlotValue(slot, value);

                break;
            }

            case 2: { /* Static data area*/
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

            case 3: { /* Return value register */
                int value;

                printf("%s ", DEBUG_EDIT);
                changeTextColor("CYAN");
                printf("The current value of the return value register is: ");
                printf("%d\n", returnValueRegister);
                changeTextColor("WHITE");
                printf("%s Now enter a new value for the return value register: ", DEBUG_EDIT);
                changeTextColor("CYAN");
                value = getNumber();
                changeTextColor("WHITE");
                returnValueRegister = value;
                break;
            }

            case 4: { /* Program Memory*/
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

            case 5: { /* Program Counter */
                int newPC;

                printf("%s Enter a new value for the program counter:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                newPC = getNumber();
                printf("\n%s ", DEBUG_EDIT);

                if (newPC < 0 || newPC >= instructionCount) {
                    changeTextColor("YELLOW");
                    printf("Error: %d lies outside of program memory!\n", newPC);
                    changeTextColor("WHITE");
                } else {
                    pc = (unsigned int) newPC + 1;
                    printf("Changed program counter to %d.\n", newPC);
                }
                break;
            }

            case 6: { /* Stack Pointer*/
                int newSP;

                printf("%s Enter a new value for the stack pointer:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                newSP = getNumber();
                printf("\n%s ", DEBUG_EDIT);

                if (newSP < 0 || newSP >= stackSize) {
                    changeTextColor("YELLOW");
                    printf("Error: %d lies outside of stack boundaries!\n", newSP);
                    changeTextColor("WHITE");
                } else {
                    sp = (unsigned int) newSP;
                    printf("Changed stack pointer to %d.\n", newSP);
                }
                break;
            }

            case 7: { /* Frame Pointer*/
                int newFP;

                printf("%s Enter a new value for the current frame pointer:\n", DEBUG_EDIT);
                printf("%s ", DEBUG_EDIT);
                newFP = getNumber();
                printf("\n%s ", DEBUG_EDIT);

                if (newFP < 0 || newFP > sp) {
                    changeTextColor("YELLOW");
                    printf("Error: Illegal frame pointer value!\n");
                    changeTextColor("WHITE");
                } else {
                    fp = (unsigned int) newFP;
                    printf("Changed frame pointer to %d.\n", newFP);
                }
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
    else if (strcmp("execute", command) == 0) {
        char* asmInstr;

        unsigned int opcode;
        int operand;
                
        printf("%s Enter the the instruction you would\n", DEBUG_EXEC);
        printf("%s like to execute or 'ABORT' to abort.\n", DEBUG_EXEC);

        printf("%s ", DEBUG_EXEC);
        changeTextColor("GREEN");
        asmInstr = getInput();
        changeTextColor("WHITE");

        if (strcasecmp(asmInstr, "ABORT") == 0) {
            printf("%s Aborting...\n", DEBUG_EXEC);
                return FALSE;
        }

        opcode = 0;
        while(opcode < 32) {
            if (strcasecmp(asmInstr, opcodes[opcode]) == 0) {
                break;
            }
            opcode = opcode + 1;
        }

        if (opcode == 32) {
            printf("%s ", DEBUG_EXEC);
            changeTextColor("YELLOW");
            printf("*WARNING* ");
            changeTextColor("WHITE");
            printf("%s is an invalid opcode! Aborting...\n", asmInstr);
            return FALSE;
        }

        printf("%s Now enter the immediate value for this instruction:\n", DEBUG_EXEC);
        printf("%s (In decimal, as a 24 bit signed integer)\n", DEBUG_EXEC);
        printf("%s ", DEBUG_EXEC);
        operand = getNumber();
        
        printf("%s Executing instruction...\n", DEBUG_EXEC);
        execute(opcode, operand);
        printf("%s Done!\n", DEBUG_EXEC);
        free(asmInstr);
        return FALSE;
    }
    else if (strcmp("help", command) == 0) {
        printf("\n");
        changeTextColor("YELLOW");
        printf("********************* NinjaVM Debugger *********************\n\n");
        printf("Available commands:\n");
        printf(" help\t\t- Prints this info.\n");
        printf(" breakpoint\t- Set a breakpoint in the program at a\n");
        printf(" \t\t  specified instruction.\n");

        printf(" dump\t\t- Dumps memory to the specified file.\n");
        printf(" edit\t\t- Starts a small editor for editing program\n");
        printf(" \t\t  memory, the stack, ect.\n");

        printf(" exectue\t- Executes an instruction\n");
        printf(" inspect\t- Print the content of one of the VMs many\n");
        printf(" \t\t  data-containing structures like the stack.\n");

        printf(" quit\t\t- Stops the VM at the next instruction cycle.\n");
        printf(" run\t\t- Starts continuous execution of instrcutions\n");
        printf(" \t\t  until a HALT is executed or the breakpoint\n");
        printf(" \t\t  is reached.\n");

        printf(" skip\t\t- Skips the current instruction.\n");
        printf(" step\t\t- Executes the current instrcution and\n");
        printf(" \t\t  advances the program counter by one.\n");
        printf(" verbose\t- Toggles output mode for run command.\n");
        printf("************************************************************\n\n");
        printf("%s Consult the debugger documentation for further information.\n", DEBUGGER);
        changeTextColor("WHITE");
        return FALSE;
    }
    else if (strcmp("inspect", command) == 0) {
        unsigned int inspectNumber;

        printf("%s What would you like to inspect:\n", DEBUG_INSPECT);
        printf("%s 1: Stack\n", DEBUG_INSPECT);
        printf("%s 2: Static data area\n", DEBUG_INSPECT);
        printf("%s 3: Return value register\n", DEBUG_INSPECT);
        printf("%s 4: Program Memory\n", DEBUG_INSPECT);
        printf("%s Choose one of the aforementioned or 0 to abort!\n", DEBUG_INSPECT);
        printf("%s ", DEBUG_INSPECT);

        inspectNumber = getNumber();

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
                printf("%s ", DEBUG_INSPECT);
                changeTextColor("CYAN");
                printf("The current value of the return value register is: ");
                printf("%d\n", returnValueRegister);
                changeTextColor("WHITE");
                break;
            }
            
            case 4: {
                listProgramMemory();
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
    else if (strcmp("skip", command) == 0) {
        pc = pc + 1;
        return FALSE;
    }
    else if (strcmp("step", command) == 0) {
        return TRUE;
    }
    else if (strcmp("verbose", command) == 0) {
        verbose = verbose == TRUE ? FALSE : TRUE;
        printf("%s ", DEBUGGER);
        changeTextColor("GREEN");
        printf("Toggled verbose run output: %s\n", verbose == TRUE ? "TRUE" : "FALSE");
        changeTextColor("WHITE");
        return FALSE;
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
void debug(void) {
    
    verbose = FALSE;
    breakpoint = -1;
    quit = FALSE;
    run = FALSE;

    printf("%s Initialization routine completed! Launching program...\n\n", DEBUGGER);

    printf("Ninja Virtual Machine started\n");
    while(quit != TRUE) {
        int instruction;
        int operand;
        unsigned int doExecute;
        unsigned int opcode;
        char* inputCommand;

        if (pc == breakpoint && breakpoint != 0) {
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

            printf("%s Enter a command or 'help' for a list of available commands.\n", DEBUGGER);
            printf("%s ", DEBUGGER);
    
            inputCommand = getInput();
            doExecute = processCommand(inputCommand);
            free(inputCommand);
        }
        else doExecute = TRUE;
        

        if (doExecute) {
            if (run == TRUE && verbose == TRUE) {
                printf("[%08d]: ", pc-1);

                changeTextColor("GREEN");
                printf("%6s ", opcodes[opcode]);
                changeTextColor("WHITE");
                printf("%d\n", operand);
            }
            execute(opcode, operand);
        }
        else
            pc = pc - 1;

        /* Check if the halt instruction has been executed or not */
        if (halt == TRUE) quit = TRUE;
    }

    printf("Ninja Virtual Machine stopped\n");

    exit(E_EXECOK);
}
