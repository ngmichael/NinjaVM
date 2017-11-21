#include <stdio.h>
#include <string.h>
#include "headers/utils.h"

/**
 * Changes the text color of the terminal to the
 * specified color. The following colors are available:
 * 
 * RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN or WHITE
 * 
 * If the specified color is unrecognized, WHITE will be used as default.
 * 
 * @param color - A string representation of the color name.
 */
void changeTextColor(char* color) {
    if (strcmp(color, "RED") == 0) {
        printf("%s", RED);
    }
    else if (strcmp(color, "GREEN") == 0) {
        printf("%s", GREEN);
    }
    else if (strcmp(color, "YELLOW") == 0) {
        printf("%s", YELLOW);
    }
    else if (strcmp(color, "BLUE") == 0) {
        printf("%s", BLUE);
    }
    else if (strcmp(color, "MAGENTA") == 0) {
        printf("%s", MAGENTA);
    }
    else if (strcmp(color, "CYAN") == 0) {
        printf("%s", CYAN);
    }
    else {
        printf("%s", WHITE);
    }
}
