#ifndef KSP_WS17_18_MAIN_H
#define KSP_WS17_18_MAIN_H

#define VERSION 2

#define FALSE 0
#define TRUE 1

#define IMMEDIATE(x) ((x) & 0x00FFFFFF) 
#define SIGN_EXTEND(i) ((i) & 0x00800000 ? (i) | 0xFF000000 : (i)) 

extern int halt;

#endif /* KSP_WS17_18_MAIN_H */
