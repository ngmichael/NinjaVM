//
// prog02.asm -- call/ret with args, but without ret value
//

	asf	3
	pushc	11
	pushc	33
	call	proc
	drop	2
	rsf
	halt

proc:
	asf	2
	pushl	-4
	wrint
	pushc	'\n'
	wrchr
	pushc	22
	wrint
	pushc	'\n'
	wrchr
	pushl	-3
	wrint
	pushc	'\n'
	wrchr
	rsf
	ret
    