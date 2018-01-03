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
// void printList(record { Integer value; List next; })
//
_printList:
	asf	0
	jmp	__2
__1:
	pushl	-3
	getf	0
	call	_writeInteger
	drop	1
	pushc	32
	call	_writeCharacter
	drop	1
	pushl	-3
	getf	1
	popl	-3
__2:
	pushl	-3
	pushn
	refne
	brt	__1
__3:
	pushc	10
	call	_writeCharacter
	drop	1
__0:
	rsf
	ret

//
// record { Integer value; List next; } reverse(record { Integer value; List next; })
//
_reverse:
	asf	2
	pushn
	popl	0
	jmp	__6
__5:
	pushl	-3
	popl	1
	pushl	-3
	getf	1
	popl	-3
	pushl	1
	pushl	0
	putf	1
	pushl	1
	popl	0
__6:
	pushl	-3
	pushn
	refne
	brt	__5
__7:
	pushl	0
	popr
	jmp	__4
__4:
	rsf
	ret

//
// void main()
//
_main:
	asf	3
	pushc	9
	popl	0
	pushn
	popl	1
	jmp	__10
__9:
	new	2
	popl	2
	pushl	2
	pushl	0
	putf	0
	pushl	2
	pushl	1
	putf	1
	pushl	2
	popl	1
	pushl	0
	pushc	1
	sub
	popl	0
__10:
	pushl	0
	pushc	0
	ge
	brt	__9
__11:
	pushl	1
	call	_printList
	drop	1
	pushl	1
	call	_reverse
	drop	1
	pushr
	popl	1
	pushl	1
	call	_printList
	drop	1
__8:
	rsf
	ret
