#include <stdio.h>
#include <string.h>
#include "headers/njvm.h"
#include "headers/stack.h"

/**
 * Main entry point - called at program launch
 *
 * @param argc - number of command line arguments
 * @param argv - an Array containing the command line arguments
 * @return 0 if program executed without error, non-zero value otherwise
 */
int main(int argc, char* argv[]) {

    int args;

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
            return 0;
        }

        if (strcmp("--version", argv[args]) == 0) {
            printf("Ninija Virtual Machine Version %u\n", VERSION);
            return 0;
        }

        /* Catch any unknown arguments and terminate */
        printf("Error: Unrecognized argument '%s'\n", argv[args]);
        return 1;
    }

    printf("Ninja Virtual Machine started\n");
    printf("Ninja Virtual Machine stopped\n");
    return 0;
}
