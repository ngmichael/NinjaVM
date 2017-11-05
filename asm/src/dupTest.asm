//
// A test for testing the DUP instruction
// Enter a number to which the VM will count to
//

init:
rdint
popg 0
pushc 0

loop:
pushc 1
add
dup
call print
pushg 0
eq
brf loop

halt

print:
asf 1
pushl -3
wrint
pushc 10
wrchr
rsf
ret
