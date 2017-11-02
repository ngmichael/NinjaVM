// A program for testing unconditional jumps and conditional jumps in the VM.
// Read 2 numbers and add.
// If result does not equal 100, jump to code that prints "Hello World!"
// After program is done, jump back to start.
// If result equals 100, jump to halt.

test:

rdint
rdint
add
pushc 100
eq
brt exit

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
jmp test

exit:
halt
