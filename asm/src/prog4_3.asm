//
// prog04.asm -- call/ret with args, and with ret value
//

	asf	3
	pushc	11
	wrint
	pushc	'\n'
	wrchr
	pushc	11
	pushc	33
	call	proc
	drop	2
	pushr
	wrint
	pushc	'\n'
	wrchr
	pushc	33
	wrint
	pushc	'\n'
	wrchr
	rsf
	halt

proc:
	asf	2
	pushl	-3
	pushl	-4
	sub
	popr
	rsf
	ret
	