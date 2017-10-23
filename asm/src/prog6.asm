//
// prog6.asm - an example using stackframes and global variables
//

pushc 2
pushc 18
popg 1
popg 0

pushc '\n'
pushc 'd'
pushc 'l'
pushc 'r'
pushc 'o'
pushc 'W'
pushc ' '
pushc 'o'
pushc 'l'
pushc 'l'
pushc 'e'
pushc 'H'
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr
wrchr

asf 5
pushg 0
popl 0
pushg 1
popl 1

pushl 0
pushl 1

add
wrint
rsf
pushc '\n'
wrchr
halt
