//
// version
//
	.vers	7

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
// void writeString(String)
//
_writeString:
	asf	1
	pushc	0
	popl	0
	jmp	_writeString_L2
_writeString_L1:
	pushl	-3
	pushl	0
	getfa
	call	_writeCharacter
	drop	1
	pushl	0
	pushc	1
	add
	popl	0
_writeString_L2:
	pushl	0
	pushl	-3
	getsz
	lt
	brt	_writeString_L1
	rsf
	ret

//
// void writeArray(Integer[][])
//
_writeArray:
	asf	4
	pushl	-3
	getsz
	popl	0
	pushc	0
	popl	1
	jmp	__2
__1:
	pushl	-3
	pushl	1
	getfa
	getsz
	popl	2
	pushc	0
	popl	3
	jmp	__5
__4:
	pushl	-3
	pushl	1
	getfa
	pushl	3
	getfa
	call	_writeInteger
	drop	1
	pushc	32
	call	_writeCharacter
	drop	1
	pushl	3
	pushc	1
	add
	popl	3
__5:
	pushl	3
	pushl	2
	lt
	brt	__4
__6:
	pushc	10
	call	_writeCharacter
	drop	1
	pushl	1
	pushc	1
	add
	popl	1
__2:
	pushl	1
	pushl	0
	lt
	brt	__1
__3:
__0:
	rsf
	ret

//
// void main()
//
_main:
	asf	3
	pushc	3
	newa
	popl	0
	pushc	0
	popl	1
	jmp	__9
__8:
	pushl	0
	pushl	1
	pushc	4
	newa
	putfa
	pushc	0
	popl	2
	jmp	__12
__11:
	pushl	0
	pushl	1
	getfa
	pushl	2
	pushc	10
	pushl	1
	pushc	1
	add
	mul
	pushl	2
	pushc	1
	add
	add
	putfa
	pushl	2
	pushc	1
	add
	popl	2
__12:
	pushl	2
	pushc	4
	lt
	brt	__11
__13:
	pushl	1
	pushc	1
	add
	popl	1
__9:
	pushl	1
	pushc	3
	lt
	brt	__8
__10:
	pushl	0
	call	_writeArray
	drop	1
__7:
	rsf
	ret
