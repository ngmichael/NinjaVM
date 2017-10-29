#define RED     "\x1b[31m"
#define GREEN   "\x1b[32m"
#define YELLOW  "\x1b[33m"
#define BLUE    "\x1b[34m"
#define MAGENTA "\x1b[35m"
#define CYAN    "\x1b[36m"
#define WHITE   "\x1b[0m"

void changeTextColor(char* color);

/*
 * Color codes - and their meaning:
 * 
 * RED: used for fatal errors, all errors that prevent further program execution
 * YELLOW: warings
 * GREEN: OPCODES, when displayed in debugger
 * CYAN: INSPECT OUTPUT: When inspecting stack, sda, ect in debugger
 * MAGENTA: BREAKPOINTS
 * BLUE: unused
 * WHITE: DEFAULT; Everything else
 */
