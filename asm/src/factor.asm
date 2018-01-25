//
// version
//
	.vers	8

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
// record { Integer value; List next; } addToList(Integer, record { Integer value; List next; })
//
_addToList:
	asf	1
	new	2
	popl	0
	pushl	0
	pushl	-4
	putf	0
	pushl	0
	pushl	-3
	putf	1
	pushl	0
	popr
	jmp	__0
__0:
	rsf
	ret

//
// record { Integer value; List next; } sortList(record { Integer value; List next; })
//
_sortList:
	asf	3
	pushn
	popl	0
	jmp	__3
__2:
	pushl	-3
	popl	1
	pushl	-3
	getf	1
	popl	-3
	pushl	0
	pushn
	refeq
	dup
	brt	__7
	drop	1
	pushl	1
	getf	0
	pushl	0
	getf	0
	lt
__7:
	brf	__5
	pushl	1
	pushl	0
	putf	1
	pushl	1
	popl	0
	jmp	__6
__5:
	pushl	0
	popl	2
	jmp	__9
__8:
	pushl	2
	getf	1
	popl	2
__9:
	pushl	2
	getf	1
	pushn
	refne
	dup
	brf	__11
	drop	1
	pushl	1
	getf	0
	pushl	2
	getf	1
	getf	0
	ge
__11:
	brt	__8
__10:
	pushl	1
	pushl	2
	getf	1
	putf	1
	pushl	2
	pushl	1
	putf	1
__6:
__3:
	pushl	-3
	pushn
	refne
	brt	__2
__4:
	pushl	0
	popr
	jmp	__1
__1:
	rsf
	ret

//
// void showList(record { Integer value; List next; })
//
_showList:
	asf	0
	pushl	-3
	pushn
	refeq
	brf	__13
	pushc	1
	newa
	dup
	pushc	0
	pushc	49
	putfa
	call	_writeString
	drop	1
	jmp	__14
__13:
	jmp	__16
__15:
	pushl	-3
	getf	0
	call	_writeInteger
	drop	1
	pushl	-3
	getf	1
	popl	-3
	pushl	-3
	pushn
	refeq
	brf	__18
	jmp	__17
__18:
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	42
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
__16:
	pushc	1
	brt	__15
__17:
__14:
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__12:
	rsf
	ret

//
// Integer evalList(record { Integer value; List next; })
//
_evalList:
	asf	1
	pushc	1
	popl	0
	jmp	__21
__20:
	pushl	0
	pushl	-3
	getf	0
	mul
	popl	0
	pushl	-3
	getf	1
	popl	-3
__21:
	pushl	-3
	pushn
	refne
	brt	__20
__22:
	pushl	0
	popr
	jmp	__19
__19:
	rsf
	ret

//
// record { Integer value; List next; } fuseLists(record { Integer value; List next; }, record { Integer value; List next; })
//
_fuseLists:
	asf	1
	jmp	__25
__24:
	pushl	-4
	popl	0
	pushl	-4
	getf	1
	popl	-4
	pushl	0
	pushl	-3
	putf	1
	pushl	0
	popl	-3
__25:
	pushl	-4
	pushn
	refne
	brt	__24
__26:
	pushl	-3
	popr
	jmp	__23
__23:
	rsf
	ret

//
// Integer computeTarget(Integer)
//
_computeTarget:
	asf	2
	pushc	1
	popl	0
	pushc	0
	popl	1
	jmp	__29
__28:
	pushl	0
	pushc	10
	mul
	popl	0
	pushl	1
	pushc	1
	add
	popl	1
__29:
	pushl	1
	pushl	-3
	lt
	brt	__28
__30:
	pushl	0
	pushc	1
	add
	popl	0
	pushl	0
	popr
	jmp	__27
__27:
	rsf
	ret

//
// void testComputeTarget()
//
_testComputeTarget:
	asf	0
	pushc	16
	newa
	dup
	pushc	0
	pushc	99
	putfa
	dup
	pushc	1
	pushc	111
	putfa
	dup
	pushc	2
	pushc	109
	putfa
	dup
	pushc	3
	pushc	112
	putfa
	dup
	pushc	4
	pushc	117
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	101
	putfa
	dup
	pushc	7
	pushc	84
	putfa
	dup
	pushc	8
	pushc	97
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	103
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	116
	putfa
	dup
	pushc	13
	pushc	40
	putfa
	dup
	pushc	14
	pushc	41
	putfa
	dup
	pushc	15
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	16
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	45
	putfa
	dup
	pushc	14
	pushc	45
	putfa
	dup
	pushc	15
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	114
	putfa
	dup
	pushc	3
	pushc	103
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	40
	putfa
	dup
	pushc	7
	pushc	49
	putfa
	dup
	pushc	8
	pushc	41
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	61
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	1
	call	_computeTarget
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	114
	putfa
	dup
	pushc	3
	pushc	103
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	40
	putfa
	dup
	pushc	7
	pushc	50
	putfa
	dup
	pushc	8
	pushc	41
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	61
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	2
	call	_computeTarget
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	114
	putfa
	dup
	pushc	3
	pushc	103
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	40
	putfa
	dup
	pushc	7
	pushc	51
	putfa
	dup
	pushc	8
	pushc	41
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	61
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	3
	call	_computeTarget
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	114
	putfa
	dup
	pushc	3
	pushc	103
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	40
	putfa
	dup
	pushc	7
	pushc	52
	putfa
	dup
	pushc	8
	pushc	41
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	61
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	4
	call	_computeTarget
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__31:
	rsf
	ret

//
// void showSmallPrimes()
//
_showSmallPrimes:
	asf	2
	pushc	0
	popl	0
	pushc	0
	popl	1
	jmp	__34
__33:
	pushg	1
	pushl	0
	getfa
	call	_writeInteger
	drop	1
	pushc	2
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	1
	pushc	1
	add
	popl	1
	pushl	1
	pushc	8
	eq
	brf	__36
	pushc	0
	popl	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__36:
	pushl	0
	pushc	1
	add
	popl	0
__34:
	pushl	0
	pushg	2
	lt
	brt	__33
__35:
	pushl	1
	pushc	0
	ne
	brf	__37
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__37:
__32:
	rsf
	ret

//
// void enterSmallPrime(Integer)
//
_enterSmallPrime:
	asf	3
	pushg	1
	getsz
	pushg	2
	eq
	brf	__39
	pushc	2
	pushg	2
	mul
	popl	0
	pushl	0
	newa
	popl	1
	pushc	0
	popl	2
	jmp	__41
__40:
	pushl	1
	pushl	2
	pushg	1
	pushl	2
	getfa
	putfa
	pushl	2
	pushc	1
	add
	popl	2
__41:
	pushl	2
	pushg	2
	lt
	brt	__40
__42:
	pushl	1
	popg	1
__39:
	pushg	1
	pushg	2
	pushl	-3
	putfa
	pushg	2
	pushc	1
	add
	popg	2
__38:
	rsf
	ret

//
// Boolean isPrime(Integer)
//
_isPrime:
	asf	1
	pushc	3
	popl	0
	jmp	__45
__44:
	pushl	-3
	pushl	0
	mod
	pushc	0
	eq
	brf	__47
	pushc	0
	popr
	jmp	__43
__47:
	pushl	0
	pushc	2
	add
	popl	0
__45:
	pushl	0
	pushl	0
	mul
	pushl	-3
	le
	brt	__44
__46:
	pushc	1
	popr
	jmp	__43
__43:
	rsf
	ret

//
// void calcSmallPrimes(Integer)
//
_calcSmallPrimes:
	asf	1
	pushl	-3
	popg	0
	pushc	256
	newa
	popg	1
	pushc	0
	popg	2
	pushc	2
	call	_enterSmallPrime
	drop	1
	pushc	3
	call	_enterSmallPrime
	drop	1
	pushc	5
	popl	0
	jmp	__50
__49:
	pushl	0
	pushg	0
	gt
	brf	__52
	jmp	__51
__52:
	pushl	0
	call	_isPrime
	drop	1
	pushr
	brf	__53
	pushl	0
	call	_enterSmallPrime
	drop	1
__53:
	pushl	0
	pushc	2
	add
	popl	0
	pushl	0
	pushg	0
	gt
	brf	__54
	jmp	__51
__54:
	pushl	0
	call	_isPrime
	drop	1
	pushr
	brf	__55
	pushl	0
	call	_enterSmallPrime
	drop	1
__55:
	pushl	0
	pushc	4
	add
	popl	0
__50:
	pushc	1
	brt	__49
__51:
__48:
	rsf
	ret

//
// void testCalcSmallPrimes()
//
_testCalcSmallPrimes:
	asf	0
	pushc	18
	newa
	dup
	pushc	0
	pushc	99
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	108
	putfa
	dup
	pushc	3
	pushc	99
	putfa
	dup
	pushc	4
	pushc	83
	putfa
	dup
	pushc	5
	pushc	109
	putfa
	dup
	pushc	6
	pushc	97
	putfa
	dup
	pushc	7
	pushc	108
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	80
	putfa
	dup
	pushc	10
	pushc	114
	putfa
	dup
	pushc	11
	pushc	105
	putfa
	dup
	pushc	12
	pushc	109
	putfa
	dup
	pushc	13
	pushc	101
	putfa
	dup
	pushc	14
	pushc	115
	putfa
	dup
	pushc	15
	pushc	40
	putfa
	dup
	pushc	16
	pushc	41
	putfa
	dup
	pushc	17
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	18
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	45
	putfa
	dup
	pushc	14
	pushc	45
	putfa
	dup
	pushc	15
	pushc	45
	putfa
	dup
	pushc	16
	pushc	45
	putfa
	dup
	pushc	17
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	34
	newa
	dup
	pushc	0
	pushc	112
	putfa
	dup
	pushc	1
	pushc	114
	putfa
	dup
	pushc	2
	pushc	105
	putfa
	dup
	pushc	3
	pushc	109
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	115
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	108
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	115
	putfa
	dup
	pushc	10
	pushc	115
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	116
	putfa
	dup
	pushc	13
	pushc	104
	putfa
	dup
	pushc	14
	pushc	97
	putfa
	dup
	pushc	15
	pushc	110
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	111
	putfa
	dup
	pushc	18
	pushc	114
	putfa
	dup
	pushc	19
	pushc	32
	putfa
	dup
	pushc	20
	pushc	101
	putfa
	dup
	pushc	21
	pushc	113
	putfa
	dup
	pushc	22
	pushc	117
	putfa
	dup
	pushc	23
	pushc	97
	putfa
	dup
	pushc	24
	pushc	108
	putfa
	dup
	pushc	25
	pushc	32
	putfa
	dup
	pushc	26
	pushc	116
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	32
	putfa
	dup
	pushc	29
	pushc	49
	putfa
	dup
	pushc	30
	pushc	48
	putfa
	dup
	pushc	31
	pushc	48
	putfa
	dup
	pushc	32
	pushc	58
	putfa
	dup
	pushc	33
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	100
	call	_calcSmallPrimes
	drop	1
	call	_showSmallPrimes
	pushc	44
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	117
	putfa
	dup
	pushc	2
	pushc	109
	putfa
	dup
	pushc	3
	pushc	98
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	111
	putfa
	dup
	pushc	8
	pushc	102
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	109
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	115
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	108
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	115
	putfa
	dup
	pushc	20
	pushc	115
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	116
	putfa
	dup
	pushc	23
	pushc	104
	putfa
	dup
	pushc	24
	pushc	97
	putfa
	dup
	pushc	25
	pushc	110
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	114
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	dup
	pushc	30
	pushc	101
	putfa
	dup
	pushc	31
	pushc	113
	putfa
	dup
	pushc	32
	pushc	117
	putfa
	dup
	pushc	33
	pushc	97
	putfa
	dup
	pushc	34
	pushc	108
	putfa
	dup
	pushc	35
	pushc	32
	putfa
	dup
	pushc	36
	pushc	116
	putfa
	dup
	pushc	37
	pushc	111
	putfa
	dup
	pushc	38
	pushc	32
	putfa
	dup
	pushc	39
	pushc	49
	putfa
	dup
	pushc	40
	pushc	48
	putfa
	dup
	pushc	41
	pushc	48
	putfa
	dup
	pushc	42
	pushc	58
	putfa
	dup
	pushc	43
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushg	2
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1000
	call	_calcSmallPrimes
	drop	1
	pushc	45
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	117
	putfa
	dup
	pushc	2
	pushc	109
	putfa
	dup
	pushc	3
	pushc	98
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	111
	putfa
	dup
	pushc	8
	pushc	102
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	109
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	115
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	108
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	115
	putfa
	dup
	pushc	20
	pushc	115
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	116
	putfa
	dup
	pushc	23
	pushc	104
	putfa
	dup
	pushc	24
	pushc	97
	putfa
	dup
	pushc	25
	pushc	110
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	114
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	dup
	pushc	30
	pushc	101
	putfa
	dup
	pushc	31
	pushc	113
	putfa
	dup
	pushc	32
	pushc	117
	putfa
	dup
	pushc	33
	pushc	97
	putfa
	dup
	pushc	34
	pushc	108
	putfa
	dup
	pushc	35
	pushc	32
	putfa
	dup
	pushc	36
	pushc	116
	putfa
	dup
	pushc	37
	pushc	111
	putfa
	dup
	pushc	38
	pushc	32
	putfa
	dup
	pushc	39
	pushc	49
	putfa
	dup
	pushc	40
	pushc	48
	putfa
	dup
	pushc	41
	pushc	48
	putfa
	dup
	pushc	42
	pushc	48
	putfa
	dup
	pushc	43
	pushc	58
	putfa
	dup
	pushc	44
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushg	2
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	10000
	call	_calcSmallPrimes
	drop	1
	pushc	46
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	117
	putfa
	dup
	pushc	2
	pushc	109
	putfa
	dup
	pushc	3
	pushc	98
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	111
	putfa
	dup
	pushc	8
	pushc	102
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	109
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	115
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	108
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	115
	putfa
	dup
	pushc	20
	pushc	115
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	116
	putfa
	dup
	pushc	23
	pushc	104
	putfa
	dup
	pushc	24
	pushc	97
	putfa
	dup
	pushc	25
	pushc	110
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	114
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	dup
	pushc	30
	pushc	101
	putfa
	dup
	pushc	31
	pushc	113
	putfa
	dup
	pushc	32
	pushc	117
	putfa
	dup
	pushc	33
	pushc	97
	putfa
	dup
	pushc	34
	pushc	108
	putfa
	dup
	pushc	35
	pushc	32
	putfa
	dup
	pushc	36
	pushc	116
	putfa
	dup
	pushc	37
	pushc	111
	putfa
	dup
	pushc	38
	pushc	32
	putfa
	dup
	pushc	39
	pushc	49
	putfa
	dup
	pushc	40
	pushc	48
	putfa
	dup
	pushc	41
	pushc	48
	putfa
	dup
	pushc	42
	pushc	48
	putfa
	dup
	pushc	43
	pushc	48
	putfa
	dup
	pushc	44
	pushc	58
	putfa
	dup
	pushc	45
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushg	2
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	100000
	call	_calcSmallPrimes
	drop	1
	pushc	47
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	117
	putfa
	dup
	pushc	2
	pushc	109
	putfa
	dup
	pushc	3
	pushc	98
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	111
	putfa
	dup
	pushc	8
	pushc	102
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	109
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	115
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	108
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	115
	putfa
	dup
	pushc	20
	pushc	115
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	116
	putfa
	dup
	pushc	23
	pushc	104
	putfa
	dup
	pushc	24
	pushc	97
	putfa
	dup
	pushc	25
	pushc	110
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	114
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	dup
	pushc	30
	pushc	101
	putfa
	dup
	pushc	31
	pushc	113
	putfa
	dup
	pushc	32
	pushc	117
	putfa
	dup
	pushc	33
	pushc	97
	putfa
	dup
	pushc	34
	pushc	108
	putfa
	dup
	pushc	35
	pushc	32
	putfa
	dup
	pushc	36
	pushc	116
	putfa
	dup
	pushc	37
	pushc	111
	putfa
	dup
	pushc	38
	pushc	32
	putfa
	dup
	pushc	39
	pushc	49
	putfa
	dup
	pushc	40
	pushc	48
	putfa
	dup
	pushc	41
	pushc	48
	putfa
	dup
	pushc	42
	pushc	48
	putfa
	dup
	pushc	43
	pushc	48
	putfa
	dup
	pushc	44
	pushc	48
	putfa
	dup
	pushc	45
	pushc	58
	putfa
	dup
	pushc	46
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushg	2
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__56:
	rsf
	ret

//
// Integer smallPrimeFactor(Integer)
//
_smallPrimeFactor:
	asf	1
	pushc	0
	popl	0
	jmp	__59
__58:
	pushl	-3
	pushg	1
	pushl	0
	getfa
	mod
	pushc	0
	eq
	brf	__61
	pushg	1
	pushl	0
	getfa
	popr
	jmp	__57
__61:
	pushl	0
	pushc	1
	add
	popl	0
__59:
	pushl	0
	pushg	2
	lt
	brt	__58
__60:
	pushc	0
	popr
	jmp	__57
__57:
	rsf
	ret

//
// void testSmallPrimeFactor()
//
_testSmallPrimeFactor:
	asf	0
	pushc	10000
	call	_calcSmallPrimes
	drop	1
	pushc	19
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	80
	putfa
	dup
	pushc	6
	pushc	114
	putfa
	dup
	pushc	7
	pushc	105
	putfa
	dup
	pushc	8
	pushc	109
	putfa
	dup
	pushc	9
	pushc	101
	putfa
	dup
	pushc	10
	pushc	70
	putfa
	dup
	pushc	11
	pushc	97
	putfa
	dup
	pushc	12
	pushc	99
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	111
	putfa
	dup
	pushc	15
	pushc	114
	putfa
	dup
	pushc	16
	pushc	40
	putfa
	dup
	pushc	17
	pushc	41
	putfa
	dup
	pushc	18
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	19
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	45
	putfa
	dup
	pushc	14
	pushc	45
	putfa
	dup
	pushc	15
	pushc	45
	putfa
	dup
	pushc	16
	pushc	45
	putfa
	dup
	pushc	17
	pushc	45
	putfa
	dup
	pushc	18
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	25
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	112
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	109
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	102
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	99
	putfa
	dup
	pushc	15
	pushc	116
	putfa
	dup
	pushc	16
	pushc	111
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	102
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	50
	putfa
	dup
	pushc	23
	pushc	58
	putfa
	dup
	pushc	24
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	2
	call	_smallPrimeFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	27
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	112
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	109
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	102
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	99
	putfa
	dup
	pushc	15
	pushc	116
	putfa
	dup
	pushc	16
	pushc	111
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	102
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	50
	putfa
	dup
	pushc	23
	pushc	50
	putfa
	dup
	pushc	24
	pushc	50
	putfa
	dup
	pushc	25
	pushc	58
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	222
	call	_smallPrimeFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	32
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	112
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	109
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	102
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	99
	putfa
	dup
	pushc	15
	pushc	116
	putfa
	dup
	pushc	16
	pushc	111
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	102
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	49
	putfa
	dup
	pushc	23
	pushc	55
	putfa
	dup
	pushc	24
	pushc	42
	putfa
	dup
	pushc	25
	pushc	49
	putfa
	dup
	pushc	26
	pushc	57
	putfa
	dup
	pushc	27
	pushc	42
	putfa
	dup
	pushc	28
	pushc	50
	putfa
	dup
	pushc	29
	pushc	51
	putfa
	dup
	pushc	30
	pushc	58
	putfa
	dup
	pushc	31
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	17
	pushc	19
	mul
	pushc	23
	mul
	call	_smallPrimeFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	28
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	112
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	109
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	102
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	99
	putfa
	dup
	pushc	15
	pushc	116
	putfa
	dup
	pushc	16
	pushc	111
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	102
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	55
	putfa
	dup
	pushc	23
	pushc	57
	putfa
	dup
	pushc	24
	pushc	49
	putfa
	dup
	pushc	25
	pushc	57
	putfa
	dup
	pushc	26
	pushc	58
	putfa
	dup
	pushc	27
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	7919
	call	_smallPrimeFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	33
	newa
	dup
	pushc	0
	pushc	115
	putfa
	dup
	pushc	1
	pushc	109
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	112
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	109
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	102
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	99
	putfa
	dup
	pushc	15
	pushc	116
	putfa
	dup
	pushc	16
	pushc	111
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	102
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	57
	putfa
	dup
	pushc	23
	pushc	56
	putfa
	dup
	pushc	24
	pushc	55
	putfa
	dup
	pushc	25
	pushc	54
	putfa
	dup
	pushc	26
	pushc	53
	putfa
	dup
	pushc	27
	pushc	52
	putfa
	dup
	pushc	28
	pushc	51
	putfa
	dup
	pushc	29
	pushc	50
	putfa
	dup
	pushc	30
	pushc	51
	putfa
	dup
	pushc	31
	pushc	58
	putfa
	dup
	pushc	32
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	987654
	pushc	1000
	mul
	pushc	323
	add
	call	_smallPrimeFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__62:
	rsf
	ret

//
// Integer powerMod(Integer, Integer, Integer)
//
_powerMod:
	asf	1
	pushc	1
	popl	0
	jmp	__65
__64:
	pushl	-4
	pushc	2
	mod
	pushc	0
	eq
	brf	__67
	pushl	-5
	pushl	-5
	mul
	pushl	-3
	mod
	popl	-5
	pushl	-4
	pushc	2
	div
	popl	-4
	jmp	__68
__67:
	pushl	0
	pushl	-5
	mul
	pushl	-3
	mod
	popl	0
	pushl	-4
	pushc	1
	sub
	popl	-4
__68:
__65:
	pushl	-4
	pushc	0
	ne
	brt	__64
__66:
	pushl	0
	popr
	jmp	__63
__63:
	rsf
	ret

//
// void testPowerMod()
//
_testPowerMod:
	asf	0
	pushc	11
	newa
	dup
	pushc	0
	pushc	112
	putfa
	dup
	pushc	1
	pushc	111
	putfa
	dup
	pushc	2
	pushc	119
	putfa
	dup
	pushc	3
	pushc	101
	putfa
	dup
	pushc	4
	pushc	114
	putfa
	dup
	pushc	5
	pushc	77
	putfa
	dup
	pushc	6
	pushc	111
	putfa
	dup
	pushc	7
	pushc	100
	putfa
	dup
	pushc	8
	pushc	40
	putfa
	dup
	pushc	9
	pushc	41
	putfa
	dup
	pushc	10
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	11
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	50
	putfa
	dup
	pushc	1
	pushc	94
	putfa
	dup
	pushc	2
	pushc	49
	putfa
	dup
	pushc	3
	pushc	54
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	109
	putfa
	dup
	pushc	6
	pushc	111
	putfa
	dup
	pushc	7
	pushc	100
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	55
	putfa
	dup
	pushc	10
	pushc	58
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	2
	pushc	16
	pushc	7
	call	_powerMod
	drop	3
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	13
	newa
	dup
	pushc	0
	pushc	51
	putfa
	dup
	pushc	1
	pushc	94
	putfa
	dup
	pushc	2
	pushc	49
	putfa
	dup
	pushc	3
	pushc	48
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	109
	putfa
	dup
	pushc	6
	pushc	111
	putfa
	dup
	pushc	7
	pushc	100
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	49
	putfa
	dup
	pushc	10
	pushc	57
	putfa
	dup
	pushc	11
	pushc	58
	putfa
	dup
	pushc	12
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	3
	pushc	10
	pushc	19
	call	_powerMod
	drop	3
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	29
	newa
	dup
	pushc	0
	pushc	49
	putfa
	dup
	pushc	1
	pushc	50
	putfa
	dup
	pushc	2
	pushc	51
	putfa
	dup
	pushc	3
	pushc	94
	putfa
	dup
	pushc	4
	pushc	57
	putfa
	dup
	pushc	5
	pushc	56
	putfa
	dup
	pushc	6
	pushc	55
	putfa
	dup
	pushc	7
	pushc	54
	putfa
	dup
	pushc	8
	pushc	53
	putfa
	dup
	pushc	9
	pushc	52
	putfa
	dup
	pushc	10
	pushc	51
	putfa
	dup
	pushc	11
	pushc	50
	putfa
	dup
	pushc	12
	pushc	51
	putfa
	dup
	pushc	13
	pushc	32
	putfa
	dup
	pushc	14
	pushc	109
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	100
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	57
	putfa
	dup
	pushc	19
	pushc	56
	putfa
	dup
	pushc	20
	pushc	55
	putfa
	dup
	pushc	21
	pushc	54
	putfa
	dup
	pushc	22
	pushc	53
	putfa
	dup
	pushc	23
	pushc	52
	putfa
	dup
	pushc	24
	pushc	51
	putfa
	dup
	pushc	25
	pushc	50
	putfa
	dup
	pushc	26
	pushc	51
	putfa
	dup
	pushc	27
	pushc	58
	putfa
	dup
	pushc	28
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	123
	pushc	987654
	pushc	1000
	mul
	pushc	323
	add
	pushc	987654
	pushc	1000
	mul
	pushc	323
	add
	call	_powerMod
	drop	3
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__69:
	rsf
	ret

//
// Integer GCD(Integer, Integer)
//
_GCD:
	asf	1
	pushl	-4
	pushc	0
	lt
	brf	__71
	pushc	0
	pushl	-4
	sub
	popl	-4
__71:
	pushl	-3
	pushc	0
	lt
	brf	__72
	pushc	0
	pushl	-3
	sub
	popl	-3
__72:
	jmp	__74
__73:
	pushl	-4
	pushl	-3
	mod
	popl	0
	pushl	-3
	popl	-4
	pushl	0
	popl	-3
__74:
	pushl	-3
	pushc	0
	ne
	brt	__73
__75:
	pushl	-4
	popr
	jmp	__70
__70:
	rsf
	ret

//
// void testGCD()
//
_testGCD:
	asf	0
	pushc	6
	newa
	dup
	pushc	0
	pushc	71
	putfa
	dup
	pushc	1
	pushc	67
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	40
	putfa
	dup
	pushc	4
	pushc	41
	putfa
	dup
	pushc	5
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	6
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	32
	newa
	dup
	pushc	0
	pushc	71
	putfa
	dup
	pushc	1
	pushc	67
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	40
	putfa
	dup
	pushc	4
	pushc	51
	putfa
	dup
	pushc	5
	pushc	42
	putfa
	dup
	pushc	6
	pushc	53
	putfa
	dup
	pushc	7
	pushc	42
	putfa
	dup
	pushc	8
	pushc	53
	putfa
	dup
	pushc	9
	pushc	42
	putfa
	dup
	pushc	10
	pushc	49
	putfa
	dup
	pushc	11
	pushc	49
	putfa
	dup
	pushc	12
	pushc	42
	putfa
	dup
	pushc	13
	pushc	51
	putfa
	dup
	pushc	14
	pushc	55
	putfa
	dup
	pushc	15
	pushc	44
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	50
	putfa
	dup
	pushc	18
	pushc	42
	putfa
	dup
	pushc	19
	pushc	50
	putfa
	dup
	pushc	20
	pushc	42
	putfa
	dup
	pushc	21
	pushc	53
	putfa
	dup
	pushc	22
	pushc	42
	putfa
	dup
	pushc	23
	pushc	51
	putfa
	dup
	pushc	24
	pushc	55
	putfa
	dup
	pushc	25
	pushc	42
	putfa
	dup
	pushc	26
	pushc	53
	putfa
	dup
	pushc	27
	pushc	51
	putfa
	dup
	pushc	28
	pushc	41
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	dup
	pushc	30
	pushc	61
	putfa
	dup
	pushc	31
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	3
	pushc	5
	mul
	pushc	5
	mul
	pushc	11
	mul
	pushc	37
	mul
	pushc	2
	pushc	2
	mul
	pushc	5
	mul
	pushc	37
	mul
	pushc	53
	mul
	call	_GCD
	drop	2
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__76:
	rsf
	ret

//
// Boolean isComposite(Integer)
//
_isComposite:
	asf	6
	pushl	-3
	pushc	1
	sub
	popl	0
	pushc	0
	popl	1
	jmp	__79
__78:
	pushl	0
	pushc	2
	div
	popl	0
	pushl	1
	pushc	1
	add
	popl	1
__79:
	pushl	0
	pushc	2
	mod
	pushc	0
	eq
	brt	__78
__80:
	pushc	0
	popl	2
	jmp	__82
__81:
	pushg	1
	pushl	2
	getfa
	popl	3
	pushl	3
	pushl	-3
	ge
	brf	__84
	jmp	__83
__84:
	pushc	0
	popl	4
	pushl	3
	pushl	0
	pushl	-3
	call	_powerMod
	drop	3
	pushr
	popl	5
	pushl	5
	pushc	1
	ne
	brf	__85
	jmp	__87
__86:
	pushl	5
	pushl	5
	mul
	pushl	-3
	mod
	popl	5
	pushl	4
	pushc	1
	add
	popl	4
__87:
	pushl	5
	pushc	1
	ne
	dup
	brf	__90
	drop	1
	pushl	5
	pushl	-3
	pushc	1
	sub
	ne
__90:
	dup
	brf	__89
	drop	1
	pushl	4
	pushl	1
	pushc	2
	sub
	le
__89:
	brt	__86
__88:
	pushl	5
	pushl	-3
	pushc	1
	sub
	ne
	brf	__91
	pushc	1
	popr
	jmp	__77
__91:
__85:
	pushl	2
	pushc	1
	add
	popl	2
__82:
	pushl	2
	pushc	20
	lt
	brt	__81
__83:
	pushc	0
	popr
	jmp	__77
__77:
	rsf
	ret

//
// void testIsComposite()
//
_testIsComposite:
	asf	2
	pushc	14
	newa
	dup
	pushc	0
	pushc	105
	putfa
	dup
	pushc	1
	pushc	115
	putfa
	dup
	pushc	2
	pushc	67
	putfa
	dup
	pushc	3
	pushc	111
	putfa
	dup
	pushc	4
	pushc	109
	putfa
	dup
	pushc	5
	pushc	112
	putfa
	dup
	pushc	6
	pushc	111
	putfa
	dup
	pushc	7
	pushc	115
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	40
	putfa
	dup
	pushc	12
	pushc	41
	putfa
	dup
	pushc	13
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	14
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	49
	newa
	dup
	pushc	0
	pushc	111
	putfa
	dup
	pushc	1
	pushc	100
	putfa
	dup
	pushc	2
	pushc	100
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	110
	putfa
	dup
	pushc	5
	pushc	117
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	98
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	115
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	110
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	91
	putfa
	dup
	pushc	16
	pushc	51
	putfa
	dup
	pushc	17
	pushc	46
	putfa
	dup
	pushc	18
	pushc	46
	putfa
	dup
	pushc	19
	pushc	57
	putfa
	dup
	pushc	20
	pushc	57
	putfa
	dup
	pushc	21
	pushc	93
	putfa
	dup
	pushc	22
	pushc	32
	putfa
	dup
	pushc	23
	pushc	119
	putfa
	dup
	pushc	24
	pushc	104
	putfa
	dup
	pushc	25
	pushc	105
	putfa
	dup
	pushc	26
	pushc	99
	putfa
	dup
	pushc	27
	pushc	104
	putfa
	dup
	pushc	28
	pushc	32
	putfa
	dup
	pushc	29
	pushc	97
	putfa
	dup
	pushc	30
	pushc	114
	putfa
	dup
	pushc	31
	pushc	101
	putfa
	dup
	pushc	32
	pushc	32
	putfa
	dup
	pushc	33
	pushc	112
	putfa
	dup
	pushc	34
	pushc	114
	putfa
	dup
	pushc	35
	pushc	111
	putfa
	dup
	pushc	36
	pushc	98
	putfa
	dup
	pushc	37
	pushc	97
	putfa
	dup
	pushc	38
	pushc	98
	putfa
	dup
	pushc	39
	pushc	108
	putfa
	dup
	pushc	40
	pushc	121
	putfa
	dup
	pushc	41
	pushc	32
	putfa
	dup
	pushc	42
	pushc	112
	putfa
	dup
	pushc	43
	pushc	114
	putfa
	dup
	pushc	44
	pushc	105
	putfa
	dup
	pushc	45
	pushc	109
	putfa
	dup
	pushc	46
	pushc	101
	putfa
	dup
	pushc	47
	pushc	58
	putfa
	dup
	pushc	48
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	3
	popl	0
	pushc	0
	popl	1
	jmp	__94
__93:
	pushc	1
	pushl	0
	call	_isComposite
	drop	1
	pushr
	sub
	brf	__96
	pushl	0
	call	_writeInteger
	drop	1
	pushc	2
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	1
	pushc	1
	add
	popl	1
	pushl	1
	pushc	8
	eq
	brf	__97
	pushc	0
	popl	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__97:
__96:
	pushl	0
	pushc	2
	add
	popl	0
__94:
	pushl	0
	pushc	100
	lt
	brt	__93
__95:
	pushl	1
	pushc	0
	ne
	brf	__98
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__98:
	pushc	123456
	pushc	10
	mul
	pushc	7
	add
	popl	0
	jmp	__100
__99:
	pushl	0
	call	_writeInteger
	drop	1
	pushc	4
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	105
	putfa
	dup
	pushc	2
	pushc	115
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	0
	call	_isComposite
	drop	1
	pushr
	brf	__102
	pushc	21
	newa
	dup
	pushc	0
	pushc	100
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	102
	putfa
	dup
	pushc	3
	pushc	105
	putfa
	dup
	pushc	4
	pushc	110
	putfa
	dup
	pushc	5
	pushc	105
	putfa
	dup
	pushc	6
	pushc	116
	putfa
	dup
	pushc	7
	pushc	101
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	121
	putfa
	dup
	pushc	10
	pushc	32
	putfa
	dup
	pushc	11
	pushc	99
	putfa
	dup
	pushc	12
	pushc	111
	putfa
	dup
	pushc	13
	pushc	109
	putfa
	dup
	pushc	14
	pushc	112
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	115
	putfa
	dup
	pushc	17
	pushc	105
	putfa
	dup
	pushc	18
	pushc	116
	putfa
	dup
	pushc	19
	pushc	101
	putfa
	dup
	pushc	20
	pushc	10
	putfa
	call	_writeString
	drop	1
	jmp	__103
__102:
	pushc	15
	newa
	dup
	pushc	0
	pushc	112
	putfa
	dup
	pushc	1
	pushc	114
	putfa
	dup
	pushc	2
	pushc	111
	putfa
	dup
	pushc	3
	pushc	98
	putfa
	dup
	pushc	4
	pushc	97
	putfa
	dup
	pushc	5
	pushc	98
	putfa
	dup
	pushc	6
	pushc	108
	putfa
	dup
	pushc	7
	pushc	121
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	112
	putfa
	dup
	pushc	10
	pushc	114
	putfa
	dup
	pushc	11
	pushc	105
	putfa
	dup
	pushc	12
	pushc	109
	putfa
	dup
	pushc	13
	pushc	101
	putfa
	dup
	pushc	14
	pushc	10
	putfa
	call	_writeString
	drop	1
__103:
	pushl	0
	pushc	2
	add
	popl	0
__100:
	pushl	0
	pushc	123460
	pushc	10
	mul
	pushc	7
	add
	lt
	brt	__99
__101:
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__92:
	rsf
	ret

//
// Boolean provePrime(Integer)
//
_provePrime:
	asf	0
	pushc	0
	popr
	jmp	__104
__104:
	rsf
	ret

//
// void testProvePrime()
//
_testProvePrime:
	asf	0
	pushc	13
	newa
	dup
	pushc	0
	pushc	112
	putfa
	dup
	pushc	1
	pushc	114
	putfa
	dup
	pushc	2
	pushc	111
	putfa
	dup
	pushc	3
	pushc	118
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	80
	putfa
	dup
	pushc	6
	pushc	114
	putfa
	dup
	pushc	7
	pushc	105
	putfa
	dup
	pushc	8
	pushc	109
	putfa
	dup
	pushc	9
	pushc	101
	putfa
	dup
	pushc	10
	pushc	40
	putfa
	dup
	pushc	11
	pushc	41
	putfa
	dup
	pushc	12
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	13
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	22
	newa
	dup
	pushc	0
	pushc	60
	putfa
	dup
	pushc	1
	pushc	110
	putfa
	dup
	pushc	2
	pushc	111
	putfa
	dup
	pushc	3
	pushc	116
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	105
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	112
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	101
	putfa
	dup
	pushc	10
	pushc	109
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	110
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	100
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	121
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	116
	putfa
	dup
	pushc	20
	pushc	62
	putfa
	dup
	pushc	21
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__105:
	rsf
	ret

//
// Integer findFactor1(Integer)
//
_findFactor1:
	asf	9
	pushc	2
	popl	0
	pushc	2
	popl	1
	pushc	2
	popl	2
	pushc	1
	popl	3
	pushc	1
	popl	4
	pushc	1
	popl	5
	pushc	0
	popl	6
	jmp	__108
__107:
	pushl	1
	pushl	1
	mul
	pushc	1
	add
	pushl	-3
	mod
	popl	1
	pushl	5
	pushl	2
	pushl	1
	sub
	mul
	pushl	-3
	mod
	popl	5
	pushl	6
	pushc	1
	add
	popl	6
	pushl	6
	pushc	20
	eq
	brf	__110
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__111
	jmp	__109
__111:
	pushl	1
	popl	0
	pushc	0
	popl	6
__110:
	pushl	3
	pushc	1
	sub
	popl	3
	pushl	3
	pushc	0
	eq
	brf	__112
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__113
	jmp	__109
__113:
	pushl	1
	popl	2
	pushl	4
	popl	3
	pushc	2
	pushl	4
	mul
	popl	4
	pushc	0
	popl	8
	jmp	__115
__114:
	pushl	1
	pushl	1
	mul
	pushc	1
	add
	pushl	-3
	mod
	popl	1
	pushl	8
	pushc	1
	add
	popl	8
__115:
	pushl	8
	pushl	3
	lt
	brt	__114
__116:
	pushl	1
	popl	0
	pushc	0
	popl	6
__112:
__108:
	pushc	1
	brt	__107
__109:
__117:
	pushl	0
	pushl	0
	mul
	pushc	1
	add
	pushl	-3
	mod
	popl	0
	pushl	2
	pushl	0
	sub
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	eq
	brt	__117
__118:
	pushl	7
	pushl	-3
	lt
	brf	__119
	pushl	7
	popr
	jmp	__106
	jmp	__120
__119:
	pushc	0
	popr
	jmp	__106
__120:
__106:
	rsf
	ret

//
// Integer findFactor2(Integer)
//
_findFactor2:
	asf	9
	pushc	2
	popl	0
	pushc	2
	popl	1
	pushc	2
	popl	2
	pushc	1
	popl	3
	pushc	1
	popl	4
	pushc	1
	popl	5
	pushc	0
	popl	6
	jmp	__123
__122:
	pushl	1
	pushl	1
	mul
	pushc	1
	sub
	pushl	-3
	mod
	popl	1
	pushl	5
	pushl	2
	pushl	1
	sub
	mul
	pushl	-3
	mod
	popl	5
	pushl	6
	pushc	1
	add
	popl	6
	pushl	6
	pushc	20
	eq
	brf	__125
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__126
	jmp	__124
__126:
	pushl	1
	popl	0
	pushc	0
	popl	6
__125:
	pushl	3
	pushc	1
	sub
	popl	3
	pushl	3
	pushc	0
	eq
	brf	__127
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__128
	jmp	__124
__128:
	pushl	1
	popl	2
	pushl	4
	popl	3
	pushc	2
	pushl	4
	mul
	popl	4
	pushc	0
	popl	8
	jmp	__130
__129:
	pushl	1
	pushl	1
	mul
	pushc	1
	sub
	pushl	-3
	mod
	popl	1
	pushl	8
	pushc	1
	add
	popl	8
__130:
	pushl	8
	pushl	3
	lt
	brt	__129
__131:
	pushl	1
	popl	0
	pushc	0
	popl	6
__127:
__123:
	pushc	1
	brt	__122
__124:
__132:
	pushl	0
	pushl	0
	mul
	pushc	1
	sub
	pushl	-3
	mod
	popl	0
	pushl	2
	pushl	0
	sub
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	eq
	brt	__132
__133:
	pushl	7
	pushl	-3
	lt
	brf	__134
	pushl	7
	popr
	jmp	__121
	jmp	__135
__134:
	pushc	0
	popr
	jmp	__121
__135:
__121:
	rsf
	ret

//
// Integer findFactor3(Integer)
//
_findFactor3:
	asf	9
	pushc	2
	popl	0
	pushc	2
	popl	1
	pushc	2
	popl	2
	pushc	1
	popl	3
	pushc	1
	popl	4
	pushc	1
	popl	5
	pushc	0
	popl	6
	jmp	__138
__137:
	pushl	1
	pushl	1
	mul
	pushc	3
	add
	pushl	-3
	mod
	popl	1
	pushl	5
	pushl	2
	pushl	1
	sub
	mul
	pushl	-3
	mod
	popl	5
	pushl	6
	pushc	1
	add
	popl	6
	pushl	6
	pushc	20
	eq
	brf	__140
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__141
	jmp	__139
__141:
	pushl	1
	popl	0
	pushc	0
	popl	6
__140:
	pushl	3
	pushc	1
	sub
	popl	3
	pushl	3
	pushc	0
	eq
	brf	__142
	pushl	5
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	gt
	brf	__143
	jmp	__139
__143:
	pushl	1
	popl	2
	pushl	4
	popl	3
	pushc	2
	pushl	4
	mul
	popl	4
	pushc	0
	popl	8
	jmp	__145
__144:
	pushl	1
	pushl	1
	mul
	pushc	3
	add
	pushl	-3
	mod
	popl	1
	pushl	8
	pushc	1
	add
	popl	8
__145:
	pushl	8
	pushl	3
	lt
	brt	__144
__146:
	pushl	1
	popl	0
	pushc	0
	popl	6
__142:
__138:
	pushc	1
	brt	__137
__139:
__147:
	pushl	0
	pushl	0
	mul
	pushc	3
	add
	pushl	-3
	mod
	popl	0
	pushl	2
	pushl	0
	sub
	pushl	-3
	call	_GCD
	drop	2
	pushr
	popl	7
	pushl	7
	pushc	1
	eq
	brt	__147
__148:
	pushl	7
	pushl	-3
	lt
	brf	__149
	pushl	7
	popr
	jmp	__136
	jmp	__150
__149:
	pushc	0
	popr
	jmp	__136
__150:
__136:
	rsf
	ret

//
// Integer findFactor(Integer)
//
_findFactor:
	asf	1
	pushl	-3
	call	_findFactor1
	drop	1
	pushr
	popl	0
	pushl	0
	pushc	0
	ne
	brf	__152
	pushl	0
	popr
	jmp	__151
__152:
	pushl	-3
	call	_findFactor2
	drop	1
	pushr
	popl	0
	pushl	0
	pushc	0
	ne
	brf	__153
	pushl	0
	popr
	jmp	__151
__153:
	pushl	-3
	call	_findFactor3
	drop	1
	pushr
	popl	0
	pushl	0
	popr
	jmp	__151
__151:
	rsf
	ret

//
// void testFindFactor()
//
_testFindFactor:
	asf	0
	pushc	13
	newa
	dup
	pushc	0
	pushc	102
	putfa
	dup
	pushc	1
	pushc	105
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	100
	putfa
	dup
	pushc	4
	pushc	70
	putfa
	dup
	pushc	5
	pushc	97
	putfa
	dup
	pushc	6
	pushc	99
	putfa
	dup
	pushc	7
	pushc	116
	putfa
	dup
	pushc	8
	pushc	111
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	40
	putfa
	dup
	pushc	11
	pushc	41
	putfa
	dup
	pushc	12
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	13
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	8
	newa
	dup
	pushc	0
	pushc	53
	putfa
	dup
	pushc	1
	pushc	42
	putfa
	dup
	pushc	2
	pushc	53
	putfa
	dup
	pushc	3
	pushc	42
	putfa
	dup
	pushc	4
	pushc	53
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	61
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	5
	pushc	5
	mul
	pushc	5
	mul
	call	_writeInteger
	drop	1
	pushc	18
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	105
	putfa
	dup
	pushc	2
	pushc	115
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	97
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	117
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	105
	putfa
	dup
	pushc	11
	pushc	112
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	101
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	102
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	5
	pushc	5
	mul
	pushc	5
	mul
	call	_findFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	17
	newa
	dup
	pushc	0
	pushc	52
	putfa
	dup
	pushc	1
	pushc	52
	putfa
	dup
	pushc	2
	pushc	50
	putfa
	dup
	pushc	3
	pushc	49
	putfa
	dup
	pushc	4
	pushc	42
	putfa
	dup
	pushc	5
	pushc	53
	putfa
	dup
	pushc	6
	pushc	55
	putfa
	dup
	pushc	7
	pushc	52
	putfa
	dup
	pushc	8
	pushc	51
	putfa
	dup
	pushc	9
	pushc	42
	putfa
	dup
	pushc	10
	pushc	55
	putfa
	dup
	pushc	11
	pushc	54
	putfa
	dup
	pushc	12
	pushc	57
	putfa
	dup
	pushc	13
	pushc	57
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	61
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	4421
	pushc	5743
	mul
	pushc	7699
	mul
	call	_writeInteger
	drop	1
	pushc	18
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	105
	putfa
	dup
	pushc	2
	pushc	115
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	97
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	117
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	105
	putfa
	dup
	pushc	11
	pushc	112
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	101
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	102
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	4421
	pushc	5743
	mul
	pushc	7699
	mul
	call	_findFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	999900
	pushc	1000000
	mul
	pushc	9999
	add
	pushc	10000
	mul
	pushc	1
	add
	call	_writeInteger
	drop	1
	pushc	18
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	105
	putfa
	dup
	pushc	2
	pushc	115
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	97
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	117
	putfa
	dup
	pushc	8
	pushc	108
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	105
	putfa
	dup
	pushc	11
	pushc	112
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	101
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	102
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	999900
	pushc	1000000
	mul
	pushc	9999
	add
	pushc	10000
	mul
	pushc	1
	add
	call	_findFactor
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__154:
	rsf
	ret

//
// record { Integer value; List next; } factorize(Integer, Boolean)
//
_factorize:
	asf	5
	pushl	-3
	brf	__156
	pushc	10
	newa
	dup
	pushc	0
	pushc	102
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	99
	putfa
	dup
	pushc	3
	pushc	116
	putfa
	dup
	pushc	4
	pushc	111
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	105
	putfa
	dup
	pushc	7
	pushc	122
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	40
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeInteger
	drop	1
	pushc	2
	newa
	dup
	pushc	0
	pushc	41
	putfa
	dup
	pushc	1
	pushc	10
	putfa
	call	_writeString
	drop	1
__156:
	pushn
	popl	0
	jmp	__158
__157:
	pushl	-4
	call	_smallPrimeFactor
	drop	1
	pushr
	popl	1
	pushl	1
	pushc	0
	eq
	brf	__160
	pushl	-4
	pushg	0
	pushg	0
	mul
	lt
	brf	__161
	pushl	-4
	popl	1
	jmp	__162
__161:
	jmp	__159
__162:
__160:
	pushl	-3
	brf	__163
	pushc	28
	newa
	dup
	pushc	0
	pushc	100
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	116
	putfa
	dup
	pushc	3
	pushc	101
	putfa
	dup
	pushc	4
	pushc	99
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	101
	putfa
	dup
	pushc	7
	pushc	100
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	115
	putfa
	dup
	pushc	10
	pushc	109
	putfa
	dup
	pushc	11
	pushc	97
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	108
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	112
	putfa
	dup
	pushc	16
	pushc	114
	putfa
	dup
	pushc	17
	pushc	105
	putfa
	dup
	pushc	18
	pushc	109
	putfa
	dup
	pushc	19
	pushc	101
	putfa
	dup
	pushc	20
	pushc	32
	putfa
	dup
	pushc	21
	pushc	102
	putfa
	dup
	pushc	22
	pushc	97
	putfa
	dup
	pushc	23
	pushc	99
	putfa
	dup
	pushc	24
	pushc	116
	putfa
	dup
	pushc	25
	pushc	111
	putfa
	dup
	pushc	26
	pushc	114
	putfa
	dup
	pushc	27
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	1
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__163:
	pushl	1
	pushl	0
	call	_addToList
	drop	2
	pushr
	popl	0
	pushl	-4
	pushl	1
	div
	popl	-4
__158:
	pushl	-4
	pushc	1
	gt
	brt	__157
__159:
	pushl	-4
	pushc	1
	eq
	brf	__164
	pushl	-3
	brf	__165
	pushc	42
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	104
	putfa
	dup
	pushc	2
	pushc	101
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	110
	putfa
	dup
	pushc	5
	pushc	117
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	98
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	32
	putfa
	dup
	pushc	11
	pushc	104
	putfa
	dup
	pushc	12
	pushc	97
	putfa
	dup
	pushc	13
	pushc	115
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	98
	putfa
	dup
	pushc	16
	pushc	101
	putfa
	dup
	pushc	17
	pushc	101
	putfa
	dup
	pushc	18
	pushc	110
	putfa
	dup
	pushc	19
	pushc	32
	putfa
	dup
	pushc	20
	pushc	99
	putfa
	dup
	pushc	21
	pushc	111
	putfa
	dup
	pushc	22
	pushc	109
	putfa
	dup
	pushc	23
	pushc	112
	putfa
	dup
	pushc	24
	pushc	108
	putfa
	dup
	pushc	25
	pushc	101
	putfa
	dup
	pushc	26
	pushc	116
	putfa
	dup
	pushc	27
	pushc	101
	putfa
	dup
	pushc	28
	pushc	108
	putfa
	dup
	pushc	29
	pushc	121
	putfa
	dup
	pushc	30
	pushc	32
	putfa
	dup
	pushc	31
	pushc	102
	putfa
	dup
	pushc	32
	pushc	97
	putfa
	dup
	pushc	33
	pushc	99
	putfa
	dup
	pushc	34
	pushc	116
	putfa
	dup
	pushc	35
	pushc	111
	putfa
	dup
	pushc	36
	pushc	114
	putfa
	dup
	pushc	37
	pushc	105
	putfa
	dup
	pushc	38
	pushc	122
	putfa
	dup
	pushc	39
	pushc	101
	putfa
	dup
	pushc	40
	pushc	100
	putfa
	dup
	pushc	41
	pushc	10
	putfa
	call	_writeString
	drop	1
__165:
	pushl	0
	popr
	jmp	__155
__164:
	pushl	-3
	brf	__166
	pushc	41
	newa
	dup
	pushc	0
	pushc	105
	putfa
	dup
	pushc	1
	pushc	110
	putfa
	dup
	pushc	2
	pushc	116
	putfa
	dup
	pushc	3
	pushc	101
	putfa
	dup
	pushc	4
	pushc	114
	putfa
	dup
	pushc	5
	pushc	105
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	dup
	pushc	8
	pushc	114
	putfa
	dup
	pushc	9
	pushc	101
	putfa
	dup
	pushc	10
	pushc	115
	putfa
	dup
	pushc	11
	pushc	117
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	58
	putfa
	dup
	pushc	15
	pushc	10
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	32
	putfa
	dup
	pushc	20
	pushc	116
	putfa
	dup
	pushc	21
	pushc	104
	putfa
	dup
	pushc	22
	pushc	101
	putfa
	dup
	pushc	23
	pushc	32
	putfa
	dup
	pushc	24
	pushc	114
	putfa
	dup
	pushc	25
	pushc	101
	putfa
	dup
	pushc	26
	pushc	109
	putfa
	dup
	pushc	27
	pushc	97
	putfa
	dup
	pushc	28
	pushc	105
	putfa
	dup
	pushc	29
	pushc	110
	putfa
	dup
	pushc	30
	pushc	105
	putfa
	dup
	pushc	31
	pushc	110
	putfa
	dup
	pushc	32
	pushc	103
	putfa
	dup
	pushc	33
	pushc	32
	putfa
	dup
	pushc	34
	pushc	102
	putfa
	dup
	pushc	35
	pushc	97
	putfa
	dup
	pushc	36
	pushc	99
	putfa
	dup
	pushc	37
	pushc	116
	putfa
	dup
	pushc	38
	pushc	111
	putfa
	dup
	pushc	39
	pushc	114
	putfa
	dup
	pushc	40
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeInteger
	drop	1
	pushc	38
	newa
	dup
	pushc	0
	pushc	10
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	100
	putfa
	dup
	pushc	6
	pushc	111
	putfa
	dup
	pushc	7
	pushc	101
	putfa
	dup
	pushc	8
	pushc	115
	putfa
	dup
	pushc	9
	pushc	110
	putfa
	dup
	pushc	10
	pushc	39
	putfa
	dup
	pushc	11
	pushc	116
	putfa
	dup
	pushc	12
	pushc	32
	putfa
	dup
	pushc	13
	pushc	104
	putfa
	dup
	pushc	14
	pushc	97
	putfa
	dup
	pushc	15
	pushc	118
	putfa
	dup
	pushc	16
	pushc	101
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	97
	putfa
	dup
	pushc	19
	pushc	110
	putfa
	dup
	pushc	20
	pushc	121
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	112
	putfa
	dup
	pushc	23
	pushc	114
	putfa
	dup
	pushc	24
	pushc	105
	putfa
	dup
	pushc	25
	pushc	109
	putfa
	dup
	pushc	26
	pushc	101
	putfa
	dup
	pushc	27
	pushc	32
	putfa
	dup
	pushc	28
	pushc	102
	putfa
	dup
	pushc	29
	pushc	97
	putfa
	dup
	pushc	30
	pushc	99
	putfa
	dup
	pushc	31
	pushc	116
	putfa
	dup
	pushc	32
	pushc	111
	putfa
	dup
	pushc	33
	pushc	114
	putfa
	dup
	pushc	34
	pushc	115
	putfa
	dup
	pushc	35
	pushc	32
	putfa
	dup
	pushc	36
	pushc	60
	putfa
	dup
	pushc	37
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushg	0
	call	_writeInteger
	drop	1
	pushc	5
	newa
	dup
	pushc	0
	pushc	10
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	call	_writeString
	drop	1
__166:
	pushl	-4
	call	_isComposite
	drop	1
	pushr
	brf	__167
	pushl	-3
	brf	__169
	pushc	28
	newa
	dup
	pushc	0
	pushc	98
	putfa
	dup
	pushc	1
	pushc	117
	putfa
	dup
	pushc	2
	pushc	116
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	105
	putfa
	dup
	pushc	5
	pushc	115
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	100
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	102
	putfa
	dup
	pushc	10
	pushc	105
	putfa
	dup
	pushc	11
	pushc	110
	putfa
	dup
	pushc	12
	pushc	105
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	108
	putfa
	dup
	pushc	16
	pushc	121
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	99
	putfa
	dup
	pushc	19
	pushc	111
	putfa
	dup
	pushc	20
	pushc	109
	putfa
	dup
	pushc	21
	pushc	112
	putfa
	dup
	pushc	22
	pushc	111
	putfa
	dup
	pushc	23
	pushc	115
	putfa
	dup
	pushc	24
	pushc	105
	putfa
	dup
	pushc	25
	pushc	116
	putfa
	dup
	pushc	26
	pushc	101
	putfa
	dup
	pushc	27
	pushc	10
	putfa
	call	_writeString
	drop	1
__169:
	pushl	-4
	call	_findFactor
	drop	1
	pushr
	popl	2
	pushl	2
	pushc	0
	eq
	brf	__170
	pushc	17
	newa
	dup
	pushc	0
	pushc	99
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	110
	putfa
	dup
	pushc	4
	pushc	111
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	102
	putfa
	dup
	pushc	8
	pushc	97
	putfa
	dup
	pushc	9
	pushc	99
	putfa
	dup
	pushc	10
	pushc	116
	putfa
	dup
	pushc	11
	pushc	111
	putfa
	dup
	pushc	12
	pushc	114
	putfa
	dup
	pushc	13
	pushc	105
	putfa
	dup
	pushc	14
	pushc	122
	putfa
	dup
	pushc	15
	pushc	101
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeInteger
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	44
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	dup
	pushc	2
	pushc	103
	putfa
	dup
	pushc	3
	pushc	105
	putfa
	dup
	pushc	4
	pushc	118
	putfa
	dup
	pushc	5
	pushc	105
	putfa
	dup
	pushc	6
	pushc	110
	putfa
	dup
	pushc	7
	pushc	103
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	117
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushl	-4
	pushl	0
	call	_addToList
	drop	2
	pushr
	popl	0
	jmp	__171
__170:
	pushl	-4
	pushl	2
	div
	popl	3
	pushl	-3
	brf	__172
	pushc	30
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	104
	putfa
	dup
	pushc	2
	pushc	105
	putfa
	dup
	pushc	3
	pushc	115
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	110
	putfa
	dup
	pushc	6
	pushc	117
	putfa
	dup
	pushc	7
	pushc	109
	putfa
	dup
	pushc	8
	pushc	98
	putfa
	dup
	pushc	9
	pushc	101
	putfa
	dup
	pushc	10
	pushc	114
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	99
	putfa
	dup
	pushc	13
	pushc	97
	putfa
	dup
	pushc	14
	pushc	110
	putfa
	dup
	pushc	15
	pushc	32
	putfa
	dup
	pushc	16
	pushc	98
	putfa
	dup
	pushc	17
	pushc	101
	putfa
	dup
	pushc	18
	pushc	32
	putfa
	dup
	pushc	19
	pushc	115
	putfa
	dup
	pushc	20
	pushc	112
	putfa
	dup
	pushc	21
	pushc	108
	putfa
	dup
	pushc	22
	pushc	105
	putfa
	dup
	pushc	23
	pushc	116
	putfa
	dup
	pushc	24
	pushc	32
	putfa
	dup
	pushc	25
	pushc	105
	putfa
	dup
	pushc	26
	pushc	110
	putfa
	dup
	pushc	27
	pushc	116
	putfa
	dup
	pushc	28
	pushc	111
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	2
	call	_writeInteger
	drop	1
	pushc	5
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	100
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	3
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__172:
	pushl	2
	pushl	-3
	call	_factorize
	drop	2
	pushr
	popl	4
	pushl	4
	pushl	0
	call	_fuseLists
	drop	2
	pushr
	popl	0
	pushl	3
	pushl	-3
	call	_factorize
	drop	2
	pushr
	popl	4
	pushl	4
	pushl	0
	call	_fuseLists
	drop	2
	pushr
	popl	0
__171:
	jmp	__168
__167:
	pushl	-3
	brf	__173
	pushc	27
	newa
	dup
	pushc	0
	pushc	97
	putfa
	dup
	pushc	1
	pushc	110
	putfa
	dup
	pushc	2
	pushc	100
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	105
	putfa
	dup
	pushc	5
	pushc	115
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	118
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	121
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	112
	putfa
	dup
	pushc	13
	pushc	114
	putfa
	dup
	pushc	14
	pushc	111
	putfa
	dup
	pushc	15
	pushc	98
	putfa
	dup
	pushc	16
	pushc	97
	putfa
	dup
	pushc	17
	pushc	98
	putfa
	dup
	pushc	18
	pushc	108
	putfa
	dup
	pushc	19
	pushc	121
	putfa
	dup
	pushc	20
	pushc	32
	putfa
	dup
	pushc	21
	pushc	112
	putfa
	dup
	pushc	22
	pushc	114
	putfa
	dup
	pushc	23
	pushc	105
	putfa
	dup
	pushc	24
	pushc	109
	putfa
	dup
	pushc	25
	pushc	101
	putfa
	dup
	pushc	26
	pushc	10
	putfa
	call	_writeString
	drop	1
__173:
	pushl	-4
	call	_provePrime
	drop	1
	pushr
	brf	__174
	pushl	-3
	brf	__176
	pushc	17
	newa
	dup
	pushc	0
	pushc	116
	putfa
	dup
	pushc	1
	pushc	104
	putfa
	dup
	pushc	2
	pushc	101
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	112
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	105
	putfa
	dup
	pushc	7
	pushc	109
	putfa
	dup
	pushc	8
	pushc	97
	putfa
	dup
	pushc	9
	pushc	108
	putfa
	dup
	pushc	10
	pushc	105
	putfa
	dup
	pushc	11
	pushc	116
	putfa
	dup
	pushc	12
	pushc	121
	putfa
	dup
	pushc	13
	pushc	32
	putfa
	dup
	pushc	14
	pushc	111
	putfa
	dup
	pushc	15
	pushc	102
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeInteger
	drop	1
	pushc	17
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	104
	putfa
	dup
	pushc	2
	pushc	97
	putfa
	dup
	pushc	3
	pushc	115
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	98
	putfa
	dup
	pushc	6
	pushc	101
	putfa
	dup
	pushc	7
	pushc	101
	putfa
	dup
	pushc	8
	pushc	110
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	111
	putfa
	dup
	pushc	13
	pushc	118
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	110
	putfa
	dup
	pushc	16
	pushc	10
	putfa
	call	_writeString
	drop	1
__176:
	jmp	__175
__174:
	pushc	30
	newa
	dup
	pushc	0
	pushc	99
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	110
	putfa
	dup
	pushc	4
	pushc	111
	putfa
	dup
	pushc	5
	pushc	116
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	112
	putfa
	dup
	pushc	8
	pushc	114
	putfa
	dup
	pushc	9
	pushc	111
	putfa
	dup
	pushc	10
	pushc	118
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	32
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	104
	putfa
	dup
	pushc	15
	pushc	101
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	112
	putfa
	dup
	pushc	18
	pushc	114
	putfa
	dup
	pushc	19
	pushc	105
	putfa
	dup
	pushc	20
	pushc	109
	putfa
	dup
	pushc	21
	pushc	97
	putfa
	dup
	pushc	22
	pushc	108
	putfa
	dup
	pushc	23
	pushc	105
	putfa
	dup
	pushc	24
	pushc	116
	putfa
	dup
	pushc	25
	pushc	121
	putfa
	dup
	pushc	26
	pushc	32
	putfa
	dup
	pushc	27
	pushc	111
	putfa
	dup
	pushc	28
	pushc	102
	putfa
	dup
	pushc	29
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeInteger
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	44
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	dup
	pushc	2
	pushc	103
	putfa
	dup
	pushc	3
	pushc	105
	putfa
	dup
	pushc	4
	pushc	118
	putfa
	dup
	pushc	5
	pushc	105
	putfa
	dup
	pushc	6
	pushc	110
	putfa
	dup
	pushc	7
	pushc	103
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	117
	putfa
	dup
	pushc	10
	pushc	112
	putfa
	dup
	pushc	11
	pushc	10
	putfa
	call	_writeString
	drop	1
__175:
	pushl	-4
	pushl	0
	call	_addToList
	drop	2
	pushr
	popl	0
__168:
	pushl	0
	popr
	jmp	__155
__155:
	rsf
	ret

//
// void testFactorize(Boolean)
//
_testFactorize:
	asf	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	102
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	99
	putfa
	dup
	pushc	3
	pushc	116
	putfa
	dup
	pushc	4
	pushc	111
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	105
	putfa
	dup
	pushc	7
	pushc	122
	putfa
	dup
	pushc	8
	pushc	101
	putfa
	dup
	pushc	9
	pushc	40
	putfa
	dup
	pushc	10
	pushc	41
	putfa
	dup
	pushc	11
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	12
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	7
	call	_calcSmallPrimes
	drop	1
	call	_showSmallPrimes
	pushc	18
	newa
	dup
	pushc	0
	pushc	51
	putfa
	dup
	pushc	1
	pushc	42
	putfa
	dup
	pushc	2
	pushc	53
	putfa
	dup
	pushc	3
	pushc	42
	putfa
	dup
	pushc	4
	pushc	55
	putfa
	dup
	pushc	5
	pushc	42
	putfa
	dup
	pushc	6
	pushc	55
	putfa
	dup
	pushc	7
	pushc	42
	putfa
	dup
	pushc	8
	pushc	49
	putfa
	dup
	pushc	9
	pushc	52
	putfa
	dup
	pushc	10
	pushc	49
	putfa
	dup
	pushc	11
	pushc	42
	putfa
	dup
	pushc	12
	pushc	52
	putfa
	dup
	pushc	13
	pushc	57
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	61
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	dup
	pushc	17
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	3
	pushc	5
	mul
	pushc	7
	mul
	pushc	7
	mul
	pushc	141
	mul
	pushc	49
	mul
	pushl	-3
	call	_factorize
	drop	2
	pushr
	popl	0
	pushl	0
	call	_sortList
	drop	1
	pushr
	call	_showList
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
__177:
	rsf
	ret

//
// void showBar()
//
_showBar:
	asf	0
	pushc	33
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	45
	putfa
	dup
	pushc	14
	pushc	45
	putfa
	dup
	pushc	15
	pushc	45
	putfa
	dup
	pushc	16
	pushc	45
	putfa
	dup
	pushc	17
	pushc	45
	putfa
	dup
	pushc	18
	pushc	45
	putfa
	dup
	pushc	19
	pushc	45
	putfa
	dup
	pushc	20
	pushc	45
	putfa
	dup
	pushc	21
	pushc	45
	putfa
	dup
	pushc	22
	pushc	45
	putfa
	dup
	pushc	23
	pushc	45
	putfa
	dup
	pushc	24
	pushc	45
	putfa
	dup
	pushc	25
	pushc	45
	putfa
	dup
	pushc	26
	pushc	45
	putfa
	dup
	pushc	27
	pushc	45
	putfa
	dup
	pushc	28
	pushc	45
	putfa
	dup
	pushc	29
	pushc	45
	putfa
	dup
	pushc	30
	pushc	45
	putfa
	dup
	pushc	31
	pushc	45
	putfa
	dup
	pushc	32
	pushc	45
	putfa
	call	_writeString
	drop	1
	pushc	32
	newa
	dup
	pushc	0
	pushc	45
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	45
	putfa
	dup
	pushc	3
	pushc	45
	putfa
	dup
	pushc	4
	pushc	45
	putfa
	dup
	pushc	5
	pushc	45
	putfa
	dup
	pushc	6
	pushc	45
	putfa
	dup
	pushc	7
	pushc	45
	putfa
	dup
	pushc	8
	pushc	45
	putfa
	dup
	pushc	9
	pushc	45
	putfa
	dup
	pushc	10
	pushc	45
	putfa
	dup
	pushc	11
	pushc	45
	putfa
	dup
	pushc	12
	pushc	45
	putfa
	dup
	pushc	13
	pushc	45
	putfa
	dup
	pushc	14
	pushc	45
	putfa
	dup
	pushc	15
	pushc	45
	putfa
	dup
	pushc	16
	pushc	45
	putfa
	dup
	pushc	17
	pushc	45
	putfa
	dup
	pushc	18
	pushc	45
	putfa
	dup
	pushc	19
	pushc	45
	putfa
	dup
	pushc	20
	pushc	45
	putfa
	dup
	pushc	21
	pushc	45
	putfa
	dup
	pushc	22
	pushc	45
	putfa
	dup
	pushc	23
	pushc	45
	putfa
	dup
	pushc	24
	pushc	45
	putfa
	dup
	pushc	25
	pushc	45
	putfa
	dup
	pushc	26
	pushc	45
	putfa
	dup
	pushc	27
	pushc	45
	putfa
	dup
	pushc	28
	pushc	45
	putfa
	dup
	pushc	29
	pushc	45
	putfa
	dup
	pushc	30
	pushc	45
	putfa
	dup
	pushc	31
	pushc	10
	putfa
	call	_writeString
	drop	1
__178:
	rsf
	ret

//
// void run(Boolean)
//
_run:
	asf	4
	pushc	10000
	call	_calcSmallPrimes
	drop	1
	call	_showBar
	pushc	1
	popl	0
	jmp	__181
__180:
	pushc	3
	newa
	dup
	pushc	0
	pushc	49
	putfa
	dup
	pushc	1
	pushc	48
	putfa
	dup
	pushc	2
	pushc	94
	putfa
	call	_writeString
	drop	1
	pushl	0
	call	_writeInteger
	drop	1
	pushc	5
	newa
	dup
	pushc	0
	pushc	43
	putfa
	dup
	pushc	1
	pushc	49
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	dup
	pushc	3
	pushc	61
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	0
	call	_computeTarget
	drop	1
	pushr
	popl	1
	pushl	1
	call	_writeInteger
	drop	1
	pushc	4
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	61
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	dup
	pushc	3
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushl	1
	pushl	-3
	call	_factorize
	drop	2
	pushr
	popl	2
	pushl	2
	call	_sortList
	drop	1
	pushr
	popl	2
	pushl	2
	call	_showList
	drop	1
	pushc	17
	newa
	dup
	pushc	0
	pushc	99
	putfa
	dup
	pushc	1
	pushc	104
	putfa
	dup
	pushc	2
	pushc	101
	putfa
	dup
	pushc	3
	pushc	99
	putfa
	dup
	pushc	4
	pushc	107
	putfa
	dup
	pushc	5
	pushc	58
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	dup
	pushc	7
	pushc	112
	putfa
	dup
	pushc	8
	pushc	114
	putfa
	dup
	pushc	9
	pushc	111
	putfa
	dup
	pushc	10
	pushc	100
	putfa
	dup
	pushc	11
	pushc	117
	putfa
	dup
	pushc	12
	pushc	99
	putfa
	dup
	pushc	13
	pushc	116
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	61
	putfa
	dup
	pushc	16
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	2
	call	_evalList
	drop	1
	pushr
	popl	3
	pushl	3
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	call	_showBar
	pushl	0
	pushc	1
	add
	popl	0
__181:
	pushl	0
	pushc	30
	le
	brt	__180
__182:
__179:
	rsf
	ret

//
// void tests(Boolean)
//
_tests:
	asf	0
	pushc	7
	newa
	dup
	pushc	0
	pushc	10
	putfa
	dup
	pushc	1
	pushc	84
	putfa
	dup
	pushc	2
	pushc	101
	putfa
	dup
	pushc	3
	pushc	115
	putfa
	dup
	pushc	4
	pushc	116
	putfa
	dup
	pushc	5
	pushc	115
	putfa
	dup
	pushc	6
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	7
	newa
	dup
	pushc	0
	pushc	61
	putfa
	dup
	pushc	1
	pushc	61
	putfa
	dup
	pushc	2
	pushc	61
	putfa
	dup
	pushc	3
	pushc	61
	putfa
	dup
	pushc	4
	pushc	61
	putfa
	dup
	pushc	5
	pushc	10
	putfa
	dup
	pushc	6
	pushc	10
	putfa
	call	_writeString
	drop	1
	call	_testComputeTarget
	call	_testCalcSmallPrimes
	call	_testSmallPrimeFactor
	call	_testPowerMod
	call	_testGCD
	call	_testIsComposite
	call	_testProvePrime
	call	_testFindFactor
	pushl	-3
	call	_testFactorize
	drop	1
__183:
	rsf
	ret

//
// void main()
//
_main:
	asf	0
	pushc	1
	call	_run
	drop	1
__184:
	rsf
	ret
