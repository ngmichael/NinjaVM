#ifndef KSP_WS17_18_MAIN_H
#define KSP_WS17_18_MAIN_H

#include "../../lib/support.h"

#define VERSION 8

#define FALSE 0
#define TRUE 1

#define IMMEDIATE(x) ((x) & 0x00FFFFFF) 
#define SIGN_EXTEND(i) ((i) & 0x00800000 ? (i) | 0xFF000000 : (i))

#define MSB (1 << (8 * sizeof(unsigned int) - 1))
#define IS_PRIM(objRef) ((( objRef)->size & MSB) == 0)

#define GET_SIZE(objRef) ((objRef)->size & ~MSB)
#define GET_REFS(objRef) ((ObjRef *)(objRef)->data)

/* Exit codes */

#define E_EXECOK            0  /* Execution OK */

/* I/O and system related exit codes*/
#define E_ERR_IO_SHELL      1  /* I/O Shell Error */
#define E_ERR_IO_FILE       2  /* I/O File Error */
#define E_ERR_CLI           3  /* Unknown CLI argument error */
#define E_ERR_SYS_MEM       4  /* System memory allocation error */
#define E_ERR_OPCODE        5  /* Unknown Instruction error */
#define E_ERR_DIV_BY_ZERO   6  /* Division by Zero error */
#define E_ERR_BIG_INT       7  /* Error during computation with big int object */
#define E_ERR_OUT_OF_MEM    8  /* Remaining heap space to small for memory request */

/* Exit codes from program loading routine */
#define E_ERR_NO_PROGF      10  /* No code file specified error */
#define E_ERR_NO_NJPROG     11  /* Code file not a Ninja program error */
#define E_ERR_VM_VER        12  /* Wrong VM Version error */

/* Internal VM error exit codes */
#define E_ERR_ST_OVER       20 /* Stack overflow error */
#define E_ERR_ST_UNDER      21 /* Stack underflow error */
#define E_ERR_STF_INDEX     22 /* Stackframe access out of bounds error */
#define E_ERR_STF_ALLOC     23 /* Stackframe allocation causes stack overflow error */
#define E_ERR_STF_FREE      24 /* Stackframe release error */
#define E_ERR_SDA_INDEX     25 /* Static data area variable index out of bounds */
#define E_ERR_KILL_DEBUG    26 /* Debugger has exited in a non-standard way */
#define E_ERR_ST_NO_OBJ     27 /* Tried to access a stackslot as an object, when it is a number */
#define E_ERR_ST_NO_NUM     28 /* Tried to access a stackslot as a number, when it is an object */
#define E_ERR_PRIM_OBJ      29 /* Tried to access a field on a primitive object. */
#define E_ERR_REC_INDEX     30 /* Index of field in object was out of bounds */
#define E_ERR_ARR_INDEX     31 /* Array index out of bounds */


extern int halt;
extern unsigned int pc;
extern unsigned int* programMemory;
extern unsigned int instructionCount;

extern ObjRef returnValueRegister;

#endif /* KSP_WS17_18_MAIN_H */
