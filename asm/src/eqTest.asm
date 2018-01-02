// Assembler version
	.vers 	5

	call __main

// print new line
__nl:
	pushc 10
	wrchr
	ret

// main
__main:
	pushc 0
	pushc 1
	eq
	wrint
	call __nl

	pushc 1
	pushc 0
	eq
	wrint
	call __nl

	halt
