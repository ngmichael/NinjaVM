//
// prog01.asm -- call/ret without args, and without ret value
//

	asf	3
	pushc	11
	wrint
	pushc	'\n'
	wrchr
	call	proc
	pushc	33
	wrint
	pushc	'\n'
	wrchr
	rsf
	halt

proc:
	asf	2
	pushc	22
	wrint
	pushc	'\n'
	wrchr
	rsf
	ret
    