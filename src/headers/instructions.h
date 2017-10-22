#ifndef KSP_WS17_18_INSTRUCTIONS_H
#define KSP_WS17_18_INSTRUCTIONS_H

#define HALT 0
#define PUSHC 1
#define ADD 2
#define SUB 3
#define MUL 4
#define DIV 5
#define MOD 6
#define RDINT 7
#define WRINT 8
#define RDCHR 9
#define WRCHR 10
#define PUSHG 11
#define POPG 12
#define ASF 13
#define RSF 14
#define PUSHL 15
#define POPL 16

extern char* opcodes[];

void execute(unsigned int opcode, int operand);

#endif /* KSP_WS17_18_INSTRUCTIONS_H */
