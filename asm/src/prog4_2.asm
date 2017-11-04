//
// prog03.asm -- call/ret without args, but with ret value
//

	asf	3
	pushc	11
	wrint
	pushc	'\n'
	wrchr
	call	proc
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
	pushc	22
	popr
	rsf
	ret
	