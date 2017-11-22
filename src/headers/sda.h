#ifndef KSP_WS17_18_SDA_H
#define KSP_WS17_18_SDA_H

void initSda(unsigned int size);
void pushGlobal(unsigned int size);
void popGlobal(unsigned int size);

void printStaticDataArea(void);
void printStaticDataAreaTo(FILE* stream);

int hasIndex(unsigned int n);
int setVariable(unsigned int varnum, int value);

#endif /* KSP_WS17_18_SDA_H */