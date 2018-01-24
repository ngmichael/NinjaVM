#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include "headers/njvm.h"
#include "headers/stack.h"
#include "headers/instructions.h"
#include "headers/sda.h"
#include "headers/debugger.h"
#include "headers/heap.h"
#include "../lib/support.h"

/* Flag for nominally halting the VM */
unsigned int halt;

/* Program counter - always points to the next instruction in program memory */
unsigned int pc;

/* Program memory - pointer to the memory region that holds the instructions */
unsigned int* programMemory;

/* Total amount of instructions in program memory */
unsigned int instructionCount;

/* Flag for determinig if the signal handler was called recursively */
volatile sig_atomic_t signalFlag;

/* The return value register of the VM*/
ObjRef returnValueRegister;

/**
 * This function is responsible for handling a segmentation fault.
 * It attempts to write out a memory dump to an error log file
 * and a gracefull exit.
 * If this causes another segfault, the process simply kills itself.
 */
void sigsegvHandler(int signum) {
    if (signalFlag == TRUE) {
        raise(SIGKILL);
    }
    signalFlag = TRUE;
    changeTextColor(WHITE, BLACK, RESET);
    printf("\nERROR: Caught internal exception SIGSEGV!\n");
    memoryDump("njvm_err.log");
    printf("Dump completed! Exiting gracefully...\n");
    exit(E_ERR_SYS_MEM);
}

/**
 * Main entry point - called at program launch
 *
 * @param argc - number of command line arguments
 * @param argv - an Array containing the command line arguments
 * @return 0 if program executed without error, non-zero value otherwise
 */
int main(int argc, char* argv[]) {

    FILE* code; /* Pointer to the code file */
    int args; /* Temporary counter variable for cli argument processing loop */
    char* formatIdentifier; /* Temp variable for processing format identifier*/
    unsigned int njvmVersion; /* Temp var for processing program version */
    unsigned int globalVariableCount; /*Var for storing amount of global vars*/
    unsigned int runDebugger; /* Flag for launching debugger */

    signalFlag = FALSE;
    stackSize = 65536; /* Bytes -> 64 KiB */
    heapSize = 8388608; /* Bytes -> 8192 KiB */
    runDebugger = FALSE;
    programMemory = NULL;
    code = NULL;
    gcPurge = FALSE;

    /* Register signal handler for segmentation fault here */
    signal(SIGSEGV, sigsegvHandler);

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
            printf("\t--stack <n>\tSet Stack size to n KiB. Default: 64 KiB\n");
            printf("\t--heap <n>\tSet Heap size to n KiB. Default: 8192 KiB\n");
            printf("\t--gcpurge\tOverrides the cleared heap memory after every GC run.\n");
            printf("\t--gcstats\tPrint GC statistics to stdout after ever GC run.\n");
            return 0;
        }
        else if (strcmp("--version", argv[args]) == 0) {
            printf("Ninja Virtual Machine Version %u (compiled %s, %s)\n", VERSION, __DATE__, __TIME__);
            return 0;
        }
        else if (strcmp("--debug", argv[args]) == 0) {
            runDebugger = TRUE;
            changeTextColor(WHITE, BLACK, BRIGHT);
            printf("%s Launching NinjaVM in debug mode...\n", DEBUGGER);
            changeTextColor(WHITE, BLACK, RESET);
        }
        else if (strcmp("--stack", argv[args]) == 0) {
            args++;
            if (args >= argc) {
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Size for '--stack' missing!\n");
                printf("\tUsage: '--stack <n> KiB' -> --stack 64\n");
                changeTextColor(WHITE, BLACK, RESET);
                exit(E_ERR_CLI);
            }
            stackSize = strtol(argv[args], NULL, 10) * 1024; /* n KiB * 1024 = Bytes*/
            if (stackSize <= 0) {
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Stack size must be greater than 0!\n");
                changeTextColor(WHITE, BLACK, RESET);
                exit(E_ERR_CLI);
            }
        }
        else if (strcmp("--heap", argv[args]) == 0) {
            args++;
            if (args >= argc) {
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Size for '--heap' missing!\n");
                printf("\tUsage: '--heap <n> KiB' -> --heap 8192\n");
                changeTextColor(WHITE, BLACK, RESET);
                exit(E_ERR_CLI);
            }
            heapSize = strtol(argv[args], NULL, 10) * 1024; /* n KiB * 1024 = Bytes*/
            if (heapSize <= 0) {
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Heap size must be greater than 0!\n");
                changeTextColor(WHITE, BLACK, RESET);
                exit(E_ERR_CLI);
            }
            if (heapSize > 2146435072) {
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Can not allocate more than 2047 MiB of heap!\n");
                changeTextColor(WHITE, BLACK, RESET);
                exit(E_ERR_CLI);
            }
        }
        else if (strcmp("--gcpurge", argv[args]) == 0) {
            gcPurge = TRUE;
        }
        else if (strcmp("--gcstats", argv[args]) == 0) {
            gcStats = TRUE;
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
                changeTextColor(YELLOW, BLACK, BRIGHT);
                printf("ERROR: Could not open %s: %s\n", argv[args], strerror(errno));
                return E_ERR_IO_FILE;
            }
        }
        else {
            /* Catch any unknown arguments and terminate */
            changeTextColor(YELLOW, BLACK, BRIGHT);
            printf("ERROR: Unrecognized argument '%s'\n", argv[args]);
            changeTextColor(WHITE, BLACK, RESET);
            return E_ERR_CLI;
        }
    }

    /* Check if a codefile has been specified */
    if (code == NULL) {
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf("ERROR: No code file specified!\n"); 
        changeTextColor(WHITE, BLACK, RESET);
        return E_ERR_NO_PROGF;
    }

    /* Validate that the loaded file is a Ninja-Program */
    formatIdentifier = calloc(4, sizeof(char));
    fread(formatIdentifier, 4, sizeof(char), code);
    if (strncmp(formatIdentifier, "NJBF", 4) != 0){
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf("ERROR: Not a Ninja program!\n");
        changeTextColor(WHITE, BLACK, RESET);
        return E_ERR_NO_NJPROG;
    }
    free(formatIdentifier);
    
    /* Validate that the Ninja-Program is compiled for this version of the VM. */
    fread(&njvmVersion, 1, sizeof(unsigned int), code);
    if (njvmVersion > VERSION){
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf("ERROR: Wrong VM version!\n");
        printf("VM: ");
        changeTextColor(WHITE, GREEN, BRIGHT);
        printf("%02x", VERSION);
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf(", PROGRAM: ");
        changeTextColor(WHITE, RED, BRIGHT);
        printf("%02x\n", njvmVersion);
        changeTextColor(WHITE, BLACK, RESET);
        return E_ERR_VM_VER;
    }
    
    /* Allocate memory to store the instructions of the Ninja-Program. */
    fread(&instructionCount, 1, sizeof(unsigned int), code);
    programMemory = calloc(instructionCount, sizeof(unsigned int));
    if (programMemory == NULL) {
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf(
            "ERROR: System could not allocate %lu of memory for program\n",
            sizeof(unsigned int) * instructionCount
        );
        changeTextColor(WHITE, BLACK, RESET);
        return E_ERR_SYS_MEM;
    }

    /* Read the amount of global variables. */
    fread(&globalVariableCount, 1, sizeof(int), code);
    
    /* Read all remaining data (instructions) into programMemory. */
    fread(programMemory, instructionCount, sizeof(unsigned int), code);
    
    /* Close the file.*/
    if (fclose(code) != 0) {
        changeTextColor(YELLOW, BLACK, BRIGHT);
        printf("ERROR: Could not close program file after reading:\n");
        printf("%s\n", strerror(errno));
        changeTextColor(WHITE, BLACK, RESET);
        return E_ERR_IO_FILE;
    }

    /* Initialize the VM */
    pc = 0;
    halt = FALSE;
    initStack();
    initSda(globalVariableCount);
    initHeap();
    returnValueRegister = NULL;

    /* Launch the debugger if flag is set */
    if (runDebugger == TRUE) {
        changeTextColor(WHITE, BLACK, BRIGHT);
        printf("%s Loaded program successfully: %d instructions | %d global variables\n",
            DEBUGGER, instructionCount, globalVariableCount);
        changeTextColor(WHITE, BLACK, RESET);
        debug();
        /* We should NEVER reach this part of the function.
           If we do, there is a bug in the debugger.*/
        exit(E_ERR_KILL_DEBUG);
    }

    printf("Ninja Virtual Machine started\n");
    while (halt != TRUE) {
        /*Instruction register and variable for storing the decoded opcode */
        unsigned int instruction, opcode;
        /* Variable for storing the decode immediate value */
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
