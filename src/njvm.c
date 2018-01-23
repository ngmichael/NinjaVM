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
    changeTextColor("WHITE");
    printf("\nERROR: Caught internal exception SIGSEGV!\n");
    printf("Performing memory dump to '/njvm_err.log'\n");
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

    FILE* code;
    int args;
    char* formatIdentifier;
    unsigned int njvmVersion;
    unsigned int globalVariableCount;
    unsigned int runDebugger;

    signalFlag = FALSE;
    stackSize = 65536; /* Bytes -> 64 KiB */
    heapSize = 8388608; /* Bytes -> 8192 KiB */
    runDebugger = FALSE;
    programMemory = NULL;
    code = NULL;
    gcPurge = FALSE;

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
            printf("%s Launching NinjaVM in debug mode...\n", DEBUGGER);
        }
        else if (strcmp("--stack", argv[args]) == 0) {
            args++;
            if (args >= argc) {
                printf("Error: Size for '--stack' missing!\n");
                printf("\tUsage: '--stack <n> KiB' -> --stack 64\n");
                exit(E_ERR_CLI);
            }
            stackSize = strtol(argv[args], NULL, 10) * 1024; /* n KiB * 1024 = Bytes*/
            if (stackSize <= 0) {
                printf("Error: Stack size must be greater than 0!\n");
                exit(E_ERR_CLI);
            }
        }
        else if (strcmp("--heap", argv[args]) == 0) {
            args++;
            if (args >= argc) {
                printf("Error: Size for '--heap' missing!\n");
                printf("\tUsage: '--heap <n> KiB' -> --heap 8192\n");
                exit(E_ERR_CLI);
            }
            heapSize = strtol(argv[args], NULL, 10) * 1024; /* n KiB * 1024 = Bytes*/
            if (heapSize <= 0) {
                printf("Error: Heap size must be greater than 0!\n");
                exit(E_ERR_CLI);
            }
            if (heapSize > 2146435072) {
                printf("Error: Can not allocate more than 2047 MiB of heap!\n");
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

    /* Validate that the loaded file is a Ninja-Program */
    formatIdentifier = calloc(4, sizeof(char));
    fread(formatIdentifier, 4, sizeof(char), code);
    if (strncmp(formatIdentifier, "NJBF", 4) != 0){
        printf("Not a Ninja program!\n");
        return E_ERR_NO_NJPROG;
    }
    free(formatIdentifier);
    
    /* Validate that the Ninja-Program is compiled for this version of the VM. */
    fread(&njvmVersion, 1, sizeof(unsigned int), code);
    if (njvmVersion > VERSION){
        printf("Wrong VM version!\n");
        printf("VM: %02x, PROGRAM: %02x\n", VERSION, njvmVersion);
        return E_ERR_VM_VER;
    }
    
    /* Allocate memory to store the instructions of the Ninja-Program. */
    fread(&instructionCount, 1, sizeof(unsigned int), code);
    programMemory = calloc(instructionCount, sizeof(unsigned int));
    if (programMemory == NULL) {
        printf(
            "Error: System could not allocate %lu of memory for program\n",
            sizeof(unsigned int) * instructionCount
        );
        return E_ERR_SYS_MEM;
    }

    /* Allocate memory for the static data area. */
    fread(&globalVariableCount, 1, sizeof(int), code);
    
    /* Read all remaining data (instructions) into programMemory. */
    fread(programMemory, instructionCount, sizeof(unsigned int), code);
    
    /* Close the file.*/
    if (fclose(code) != 0) {
        printf("Error: Could not close program file after reading:\n");
        printf("%s\n", strerror(errno));
        return E_ERR_IO_FILE;
    }

    pc = 0;
    halt = FALSE;
    initStack();
    initSda(globalVariableCount);
    initHeap();
    returnValueRegister = NULL;

    if (runDebugger == TRUE) {
        printf("%s Loaded program successfully: %d instructions | %d global variables\n",
            DEBUGGER, instructionCount, globalVariableCount);
        debug();
        /* We should NEVER reach this part of the function.
           If we do, there is a bug in the debugger.*/
        exit(E_ERR_KILL_DEBUG);
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

    return E_EXECOK;
}
