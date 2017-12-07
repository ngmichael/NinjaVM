//
// version
//
	.vers	4

//
// execution framework
//
__start:
	call	_main
	call	_exit
__stop:
	jmp	__stop

//
// Integer readInteger()
//
_readInteger:
	asf	0
	rdint
	popr
	rsf
	ret

//
// void writeInteger(Integer)
//
_writeInteger:
	asf	0
	pushl	-3
	wrint
	rsf
	ret

//
// Character readCharacter()
//
_readCharacter:
	asf	0
	rdchr
	popr
	rsf
	ret

//
// void writeCharacter(Character)
//
_writeCharacter:
	asf	0
	pushl	-3
	wrchr
	rsf
	ret

//
// Integer char2int(Character)
//
_char2int:
	asf	0
	pushl	-3
	popr
	rsf
	ret

//
// Character int2char(Integer)
//
_int2char:
	asf	0
	pushl	-3
	popr
	rsf
	ret

//
// void exit()
//
_exit:
	asf	0
	halt
	rsf
	ret

//
// void main()
//
_main:
	asf	4
	pushc	0
	popl	1
	call	_readInteger
	pushr
	popl	0
	pushl	0
	popl	3
	jmp	__2
__1:
	pushl	0
	pushc	10
	mod
	popl	2
	pushl	1
	pushc	10
	mul
	pushl	2
	add
	popl	1
	pushl	0
	pushc	10
	div
	popl	0
__2:
	pushl	0
	pushc	0
	ne
	brt	__1
__3:
	pushl	3
	pushl	1
	eq
	brf	__4
	pushc	116
	call	_writeCharacter
	drop	1
	jmp	__5
__4:
	pushc	102
	call	_writeCharacter
	drop	1
__5:
	pushc	10
	call	_writeCharacter
	drop	1
__0:
	rsf
	ret
