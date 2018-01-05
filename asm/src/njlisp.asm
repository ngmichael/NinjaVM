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
// void debug(Integer)
//
_debug:
	asf	0
	pushc	7
	newa
	dup
	pushc	0
	pushc	68
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	66
	putfa
	dup
	pushc	3
	pushc	85
	putfa
	dup
	pushc	4
	pushc	71
	putfa
	dup
	pushc	5
	pushc	58
	putfa
	dup
	pushc	6
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
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
__0:
	rsf
	ret

//
// Boolean isAlpha(Character)
//
_isAlpha:
	asf	0
	pushl	-3
	pushc	65
	ge
	dup
	brf	__3
	drop	1
	pushl	-3
	pushc	90
	le
__3:
	dup
	brt	__2
	drop	1
	pushl	-3
	pushc	97
	ge
	dup
	brf	__4
	drop	1
	pushl	-3
	pushc	122
	le
__4:
__2:
	popr
	jmp	__1
__1:
	rsf
	ret

//
// Boolean isDigit(Character)
//
_isDigit:
	asf	0
	pushl	-3
	pushc	48
	ge
	dup
	brf	__6
	drop	1
	pushl	-3
	pushc	57
	le
__6:
	popr
	jmp	__5
__5:
	rsf
	ret

//
// Character toLower(Character)
//
_toLower:
	asf	0
	pushl	-3
	pushc	65
	ge
	dup
	brf	__9
	drop	1
	pushl	-3
	pushc	90
	le
__9:
	brf	__8
	pushl	-3
	call	_char2int
	drop	1
	pushr
	pushc	32
	add
	call	_int2char
	drop	1
	pushr
	popl	-3
__8:
	pushl	-3
	popr
	jmp	__7
__7:
	rsf
	ret

//
// Character toUpper(Character)
//
_toUpper:
	asf	0
	pushl	-3
	pushc	97
	ge
	dup
	brf	__12
	drop	1
	pushl	-3
	pushc	122
	le
__12:
	brf	__11
	pushl	-3
	call	_char2int
	drop	1
	pushr
	pushc	32
	sub
	call	_int2char
	drop	1
	pushr
	popl	-3
__11:
	pushl	-3
	popr
	jmp	__10
__10:
	rsf
	ret

//
// Character[] toString(Character)
//
_toString:
	asf	1
	pushc	1
	newa
	popl	0
	pushl	0
	pushc	0
	pushl	-3
	putfa
	pushl	0
	popr
	jmp	__13
__13:
	rsf
	ret

//
// Integer stringCompare(Character[], Character[])
//
_stringCompare:
	asf	3
	pushl	-4
	getsz
	popl	0
	pushl	-3
	getsz
	popl	1
	pushc	0
	popl	2
	jmp	__16
__15:
	pushl	-4
	pushl	2
	getfa
	pushl	-3
	pushl	2
	getfa
	ne
	brf	__18
	pushl	-4
	pushl	2
	getfa
	call	_char2int
	drop	1
	pushr
	pushl	-3
	pushl	2
	getfa
	call	_char2int
	drop	1
	pushr
	sub
	popr
	jmp	__14
__18:
	pushl	2
	pushc	1
	add
	popl	2
__16:
	pushl	2
	pushl	0
	lt
	dup
	brf	__19
	drop	1
	pushl	2
	pushl	1
	lt
__19:
	brt	__15
__17:
	pushl	0
	pushl	1
	sub
	popr
	jmp	__14
__14:
	rsf
	ret

//
// record { String str; Integer len; } newStringBuffer(Integer)
//
_newStringBuffer:
	asf	1
	new	2
	popl	0
	pushl	0
	pushl	-3
	newa
	putf	0
	pushl	0
	pushc	0
	putf	1
	pushl	0
	popr
	jmp	__20
__20:
	rsf
	ret

//
// void addCharToStringBuffer(record { String str; Integer len; }, Character)
//
_addCharToStringBuffer:
	asf	2
	pushl	-4
	getf	1
	pushc	1
	add
	pushl	-4
	getf	0
	getsz
	gt
	brf	__22
	pushc	2
	pushl	-4
	getf	0
	getsz
	mul
	newa
	popl	0
	pushc	0
	popl	1
	jmp	__24
__23:
	pushl	0
	pushl	1
	pushl	-4
	getf	0
	pushl	1
	getfa
	putfa
	pushl	1
	pushc	1
	add
	popl	1
__24:
	pushl	1
	pushl	-4
	getf	1
	lt
	brt	__23
__25:
	pushl	-4
	pushl	0
	putf	0
__22:
	pushl	-4
	getf	0
	pushl	-4
	getf	1
	pushl	-3
	putfa
	pushl	-4
	pushl	-4
	getf	1
	pushc	1
	add
	putf	1
__21:
	rsf
	ret

//
// void addStringToStringBuffer(record { String str; Integer len; }, Character[])
//
_addStringToStringBuffer:
	asf	2
	pushl	-3
	getsz
	popl	0
	pushc	0
	popl	1
	jmp	__28
__27:
	pushl	-4
	pushl	-3
	pushl	1
	getfa
	call	_addCharToStringBuffer
	drop	2
	pushl	1
	pushc	1
	add
	popl	1
__28:
	pushl	1
	pushl	0
	lt
	brt	__27
__29:
__26:
	rsf
	ret

//
// Character[] stringBufferToString(record { String str; Integer len; })
//
_stringBufferToString:
	asf	2
	pushl	-3
	getf	1
	newa
	popl	0
	pushc	0
	popl	1
	jmp	__32
__31:
	pushl	0
	pushl	1
	pushl	-3
	getf	0
	pushl	1
	getfa
	putfa
	pushl	1
	pushc	1
	add
	popl	1
__32:
	pushl	1
	pushl	-3
	getf	1
	lt
	brt	__31
__33:
	pushl	0
	popr
	jmp	__30
__30:
	rsf
	ret

//
// void error(Character[], Boolean)
//
_error:
	asf	0
	pushc	1
	newa
	dup
	pushc	0
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushl	-4
	call	_writeString
	drop	1
	pushc	2
	newa
	dup
	pushc	0
	pushc	10
	putfa
	dup
	pushc	1
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushl	-3
	brf	__35
	call	_exit
__35:
__34:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeNil()
//
_makeNil:
	asf	1
	new	6
	popl	0
	pushl	0
	pushg	0
	putf	0
	pushl	0
	pushl	0
	putf	1
	pushl	0
	pushl	0
	putf	2
	pushl	0
	pushl	0
	putf	3
	pushl	0
	pushc	3
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	76
	putfa
	putf	4
	pushl	0
	popr
	jmp	__36
__36:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeName(Character[])
//
_makeName:
	asf	1
	new	6
	popl	0
	pushl	0
	pushg	0
	putf	0
	pushl	0
	pushl	0
	putf	1
	pushl	0
	pushg	10
	putf	2
	pushl	0
	pushg	10
	putf	3
	pushl	0
	pushl	-3
	putf	4
	pushl	0
	popr
	jmp	__37
__37:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeNumber(Integer)
//
_makeNumber:
	asf	1
	new	6
	popl	0
	pushl	0
	pushg	1
	putf	0
	pushl	0
	pushl	0
	putf	1
	pushl	-3
	pushc	0
	lt
	brf	__39
	pushl	0
	pushg	11
	putf	2
	jmp	__40
__39:
	pushl	0
	pushg	10
	putf	2
__40:
	pushl	0
	pushl	-3
	putf	5
	pushl	0
	popr
	jmp	__38
__38:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeNode(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_makeNode:
	asf	1
	new	6
	popl	0
	pushl	0
	pushg	2
	putf	0
	pushl	0
	pushl	-4
	putf	1
	pushl	0
	pushl	-3
	putf	2
	pushl	0
	popr
	jmp	__41
__41:
	rsf
	ret

//
// void addOblist(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_addOblist:
	asf	0
	pushl	-3
	pushg	8
	call	_makeNode
	drop	2
	pushr
	popg	8
__42:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeObject(Character[])
//
_makeObject:
	asf	1
	pushl	-3
	call	_makeName
	drop	1
	pushr
	popl	0
	pushl	0
	call	_addOblist
	drop	1
	pushl	0
	popr
	jmp	__43
__43:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } makeBuiltin(Character[], record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, Integer)
//
_makeBuiltin:
	asf	1
	pushl	-5
	call	_makeObject
	drop	1
	pushr
	popl	0
	pushl	0
	pushl	-4
	pushl	-3
	call	_makeNumber
	drop	1
	pushr
	call	_makeNode
	drop	2
	pushr
	putf	3
	pushl	0
	popr
	jmp	__44
__44:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } searchOblist(Character[])
//
_searchOblist:
	asf	1
	pushg	8
	popl	0
	jmp	__47
__46:
	pushl	0
	getf	1
	getf	4
	pushl	-3
	call	_stringCompare
	drop	2
	pushr
	pushc	0
	eq
	brf	__49
	pushl	0
	getf	1
	popr
	jmp	__45
__49:
	pushl	0
	getf	2
	popl	0
__47:
	pushl	0
	getf	0
	pushg	2
	eq
	brt	__46
__48:
	pushl	-3
	call	_makeObject
	drop	1
	pushr
	popr
	jmp	__45
__45:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } copyTree(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_copyTree:
	asf	2
	pushg	10
	pushg	10
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	0
	pushl	0
	putf	1
	jmp	__52
__51:
	pushl	-3
	getf	1
	call	_copyTree
	drop	1
	pushr
	popl	1
	pushl	0
	getf	1
	pushl	1
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	0
	pushl	0
	getf	1
	getf	2
	putf	1
	pushl	-3
	getf	2
	popl	-3
__52:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__51
__53:
	pushl	0
	getf	1
	pushl	-3
	putf	2
	pushl	0
	getf	2
	popr
	jmp	__50
__50:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } execErr(Integer)
//
_execErr:
	asf	0
	pushc	15
	newa
	dup
	pushc	0
	pushc	101
	putfa
	dup
	pushc	1
	pushc	120
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
	pushc	58
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	102
	putfa
	dup
	pushc	7
	pushc	117
	putfa
	dup
	pushc	8
	pushc	110
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
	pushc	105
	putfa
	dup
	pushc	12
	pushc	111
	putfa
	dup
	pushc	13
	pushc	110
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
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
	pushc	10
	putfa
	call	_writeString
	drop	1
	call	_exit
	pushg	10
	popr
	jmp	__54
__54:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } exec(Integer, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_exec:
	asf	0
	pushl	-6
	pushc	0
	lt
	dup
	brt	__57
	drop	1
	pushl	-6
	pushc	128
	ge
__57:
	brf	__56
	pushc	19
	newa
	dup
	pushc	0
	pushc	73
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
	pushc	110
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
	pushc	32
	putfa
	dup
	pushc	9
	pushc	69
	putfa
	dup
	pushc	10
	pushc	120
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	99
	putfa
	dup
	pushc	13
	pushc	32
	putfa
	dup
	pushc	14
	pushc	69
	putfa
	dup
	pushc	15
	pushc	114
	putfa
	dup
	pushc	16
	pushc	114
	putfa
	dup
	pushc	17
	pushc	111
	putfa
	dup
	pushc	18
	pushc	114
	putfa
	pushc	0
	call	_error
	drop	2
	pushg	10
	popr
	jmp	__55
__56:
	pushl	-6
	pushc	64
	lt
	brf	__58
	pushl	-6
	pushc	32
	lt
	brf	__60
	pushl	-6
	pushc	16
	lt
	brf	__62
	pushl	-6
	pushc	8
	lt
	brf	__64
	pushl	-6
	pushc	4
	lt
	brf	__66
	pushl	-6
	pushc	2
	lt
	brf	__68
	pushl	-6
	pushc	1
	lt
	brf	__70
	pushl	-5
	call	_car
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__71
__70:
	pushl	-5
	call	_cdr
	drop	1
	pushr
	popr
	jmp	__55
__71:
	jmp	__69
__68:
	pushl	-6
	pushc	3
	lt
	brf	__72
	pushl	-5
	call	_caar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__73
__72:
	pushl	-5
	call	_cadr
	drop	1
	pushr
	popr
	jmp	__55
__73:
__69:
	jmp	__67
__66:
	pushl	-6
	pushc	6
	lt
	brf	__74
	pushl	-6
	pushc	5
	lt
	brf	__76
	pushl	-5
	call	_cdar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__77
__76:
	pushl	-5
	call	_cddr
	drop	1
	pushr
	popr
	jmp	__55
__77:
	jmp	__75
__74:
	pushl	-6
	pushc	7
	lt
	brf	__78
	pushl	-5
	call	_caaar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__79
__78:
	pushl	-5
	call	_caadr
	drop	1
	pushr
	popr
	jmp	__55
__79:
__75:
__67:
	jmp	__65
__64:
	pushl	-6
	pushc	12
	lt
	brf	__80
	pushl	-6
	pushc	10
	lt
	brf	__82
	pushl	-6
	pushc	9
	lt
	brf	__84
	pushl	-5
	call	_cadar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__85
__84:
	pushl	-5
	call	_caddr
	drop	1
	pushr
	popr
	jmp	__55
__85:
	jmp	__83
__82:
	pushl	-6
	pushc	11
	lt
	brf	__86
	pushl	-5
	call	_cdaar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__87
__86:
	pushl	-5
	call	_cdadr
	drop	1
	pushr
	popr
	jmp	__55
__87:
__83:
	jmp	__81
__80:
	pushl	-6
	pushc	14
	lt
	brf	__88
	pushl	-6
	pushc	13
	lt
	brf	__90
	pushl	-5
	call	_cddar
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__91
__90:
	pushl	-5
	call	_cdddr
	drop	1
	pushr
	popr
	jmp	__55
__91:
	jmp	__89
__88:
	pushl	-6
	pushc	15
	lt
	brf	__92
	pushl	-5
	pushl	-4
	call	_cons
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__93
__92:
	pushl	-5
	call	_list
	drop	1
	pushr
	popr
	jmp	__55
__93:
__89:
__81:
__65:
	jmp	__63
__62:
	pushl	-6
	pushc	24
	lt
	brf	__94
	pushl	-6
	pushc	20
	lt
	brf	__96
	pushl	-6
	pushc	18
	lt
	brf	__98
	pushl	-6
	pushc	17
	lt
	brf	__100
	pushl	-5
	pushl	-4
	call	_reverse
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__101
__100:
	call	_oblist
	pushr
	popr
	jmp	__55
__101:
	jmp	__99
__98:
	pushl	-6
	pushc	19
	lt
	brf	__102
	pushl	-5
	pushl	-4
	call	_rplaca
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__103
__102:
	pushl	-5
	pushl	-4
	call	_rplacd
	drop	2
	pushr
	popr
	jmp	__55
__103:
__99:
	jmp	__97
__96:
	pushl	-6
	pushc	22
	lt
	brf	__104
	pushl	-6
	pushc	21
	lt
	brf	__106
	pushl	-5
	pushl	-4
	call	_nconc
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__107
__106:
	pushl	-5
	call	_name
	drop	1
	pushr
	popr
	jmp	__55
__107:
	jmp	__105
__104:
	pushl	-6
	pushc	23
	lt
	brf	__108
	pushl	-5
	call	_numberp
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__109
__108:
	pushl	-5
	call	_atom
	drop	1
	pushr
	popr
	jmp	__55
__109:
__105:
__97:
	jmp	__95
__94:
	pushl	-6
	pushc	28
	lt
	brf	__110
	pushl	-6
	pushc	26
	lt
	brf	__112
	pushl	-6
	pushc	25
	lt
	brf	__114
	pushl	-5
	call	_null
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__115
__114:
	pushl	-5
	call	_plusp
	drop	1
	pushr
	popr
	jmp	__55
__115:
	jmp	__113
__112:
	pushl	-6
	pushc	27
	lt
	brf	__116
	pushl	-5
	call	_minusp
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__117
__116:
	pushl	-5
	call	_zerop
	drop	1
	pushr
	popr
	jmp	__55
__117:
__113:
	jmp	__111
__110:
	pushl	-6
	pushc	30
	lt
	brf	__118
	pushl	-6
	pushc	29
	lt
	brf	__120
	pushl	-5
	call	_even
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__121
__120:
	pushl	-5
	pushl	-4
	call	_eq
	drop	2
	pushr
	popr
	jmp	__55
__121:
	jmp	__119
__118:
	pushl	-6
	pushc	31
	lt
	brf	__122
	pushl	-5
	pushl	-4
	call	_equal
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__123
__122:
	pushl	-5
	pushl	-4
	call	_member
	drop	2
	pushr
	popr
	jmp	__55
__123:
__119:
__111:
__95:
__63:
	jmp	__61
__60:
	pushl	-6
	pushc	48
	lt
	brf	__124
	pushl	-6
	pushc	40
	lt
	brf	__126
	pushl	-6
	pushc	36
	lt
	brf	__128
	pushl	-6
	pushc	34
	lt
	brf	__130
	pushl	-6
	pushc	33
	lt
	brf	__132
	pushl	-5
	pushl	-4
	call	_greaterp
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__133
__132:
	pushl	-5
	pushl	-4
	call	_lessp
	drop	2
	pushr
	popr
	jmp	__55
__133:
	jmp	__131
__130:
	pushl	-6
	pushc	35
	lt
	brf	__134
	pushl	-5
	pushl	-4
	call	_orderp
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__135
__134:
	pushl	-5
	call	_not
	drop	1
	pushr
	popr
	jmp	__55
__135:
__131:
	jmp	__129
__128:
	pushl	-6
	pushc	38
	lt
	brf	__136
	pushl	-6
	pushc	37
	lt
	brf	__138
	pushl	-5
	call	_and
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__139
__138:
	pushl	-5
	call	_or
	drop	1
	pushr
	popr
	jmp	__55
__139:
	jmp	__137
__136:
	pushl	-6
	pushc	39
	lt
	brf	__140
	pushl	-5
	pushl	-4
	call	_set
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__141
__140:
	pushl	-5
	call	_setq
	drop	1
	pushr
	popr
	jmp	__55
__141:
__137:
__129:
	jmp	__127
__126:
	pushl	-6
	pushc	44
	lt
	brf	__142
	pushl	-6
	pushc	42
	lt
	brf	__144
	pushl	-6
	pushc	41
	lt
	brf	__146
	pushl	-5
	call	_pop
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__147
__146:
	pushl	-5
	call	_push
	drop	1
	pushr
	popr
	jmp	__55
__147:
	jmp	__145
__144:
	pushl	-6
	pushc	43
	lt
	brf	__148
	pushl	-5
	pushl	-4
	call	_assoc
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__149
__148:
	pushl	-5
	pushl	-4
	call	_get
	drop	2
	pushr
	popr
	jmp	__55
__149:
__145:
	jmp	__143
__142:
	pushl	-6
	pushc	46
	lt
	brf	__150
	pushl	-6
	pushc	45
	lt
	brf	__152
	pushl	-5
	pushl	-4
	pushl	-3
	call	_put
	drop	3
	pushr
	popr
	jmp	__55
	jmp	__153
__152:
	pushl	-5
	pushl	-4
	call	_remprop
	drop	2
	pushr
	popr
	jmp	__55
__153:
	jmp	__151
__150:
	pushl	-6
	pushc	47
	lt
	brf	__154
	pushl	-5
	pushl	-4
	call	_flagp
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__155
__154:
	pushl	-5
	pushl	-4
	call	_flag
	drop	2
	pushr
	popr
	jmp	__55
__155:
__151:
__143:
__127:
	jmp	__125
__124:
	pushl	-6
	pushc	56
	lt
	brf	__156
	pushl	-6
	pushc	52
	lt
	brf	__158
	pushl	-6
	pushc	50
	lt
	brf	__160
	pushl	-6
	pushc	49
	lt
	brf	__162
	pushl	-5
	pushl	-4
	call	_remflag
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__163
__162:
	pushl	-5
	call	_getd
	drop	1
	pushr
	popr
	jmp	__55
__163:
	jmp	__161
__160:
	pushl	-6
	pushc	51
	lt
	brf	__164
	pushl	-5
	pushl	-4
	call	_putd
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__165
__164:
	pushl	-5
	pushl	-4
	call	_movd
	drop	2
	pushr
	popr
	jmp	__55
__165:
__161:
	jmp	__159
__158:
	pushl	-6
	pushc	54
	lt
	brf	__166
	pushl	-6
	pushc	53
	lt
	brf	__168
	pushl	-5
	call	_pack
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__169
__168:
	pushl	-5
	call	_unpack
	drop	1
	pushr
	popr
	jmp	__55
__169:
	jmp	__167
__166:
	pushl	-6
	pushc	55
	lt
	brf	__170
	pushl	-5
	call	_length
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__171
__170:
	pushl	-5
	call	_minus
	drop	1
	pushr
	popr
	jmp	__55
__171:
__167:
__159:
	jmp	__157
__156:
	pushl	-6
	pushc	60
	lt
	brf	__172
	pushl	-6
	pushc	58
	lt
	brf	__174
	pushl	-6
	pushc	57
	lt
	brf	__176
	pushl	-5
	pushl	-4
	call	_plus
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__177
__176:
	pushl	-5
	pushl	-4
	call	_difference
	drop	2
	pushr
	popr
	jmp	__55
__177:
	jmp	__175
__174:
	pushl	-6
	pushc	59
	lt
	brf	__178
	pushl	-5
	pushl	-4
	call	_times
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__179
__178:
	pushl	-5
	pushl	-4
	call	_quotient
	drop	2
	pushr
	popr
	jmp	__55
__179:
__175:
	jmp	__173
__172:
	pushl	-6
	pushc	62
	lt
	brf	__180
	pushl	-6
	pushc	61
	lt
	brf	__182
	pushl	-5
	pushl	-4
	call	_remainder
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__183
__182:
	pushl	-5
	pushl	-4
	call	_divide
	drop	2
	pushr
	popr
	jmp	__55
__183:
	jmp	__181
__180:
	pushl	-6
	pushc	63
	lt
	brf	__184
	pushl	-5
	pushl	-4
	pushl	-3
	call	_rds
	drop	3
	pushr
	popr
	jmp	__55
	jmp	__185
__184:
	call	_ratom
	pushr
	popr
	jmp	__55
__185:
__181:
__173:
__157:
__125:
__61:
	jmp	__59
__58:
	pushl	-6
	pushc	96
	lt
	brf	__186
	pushl	-6
	pushc	80
	lt
	brf	__188
	pushl	-6
	pushc	72
	lt
	brf	__190
	pushl	-6
	pushc	68
	lt
	brf	__192
	pushl	-6
	pushc	66
	lt
	brf	__194
	pushl	-6
	pushc	65
	lt
	brf	__196
	call	_read
	pushr
	popr
	jmp	__55
	jmp	__197
__196:
	call	_readch
	pushr
	popr
	jmp	__55
__197:
	jmp	__195
__194:
	pushl	-6
	pushc	67
	lt
	brf	__198
	pushl	-5
	pushl	-4
	pushl	-3
	call	_wrs
	drop	3
	pushr
	popr
	jmp	__55
	jmp	__199
__198:
	pushl	-5
	call	_print
	drop	1
	pushr
	popr
	jmp	__55
__199:
__195:
	jmp	__193
__192:
	pushl	-6
	pushc	70
	lt
	brf	__200
	pushl	-6
	pushc	69
	lt
	brf	__202
	pushl	-5
	call	_prin1
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__203
__202:
	pushl	-5
	call	_terpri
	drop	1
	pushr
	popr
	jmp	__55
__203:
	jmp	__201
__200:
	pushl	-6
	pushc	71
	lt
	brf	__204
	pushl	-5
	call	_spaces
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__205
__204:
	pushl	-5
	call	_linelength
	drop	1
	pushr
	popr
	jmp	__55
__205:
__201:
__193:
	jmp	__191
__190:
	pushl	-6
	pushc	76
	lt
	brf	__206
	pushl	-6
	pushc	74
	lt
	brf	__208
	pushl	-6
	pushc	73
	lt
	brf	__210
	pushl	-5
	call	_radix
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__211
__210:
	pushl	-5
	call	_quote
	drop	1
	pushr
	popr
	jmp	__55
__211:
	jmp	__209
__208:
	pushl	-6
	pushc	75
	lt
	brf	__212
	pushl	-5
	call	_eval
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__213
__212:
	pushl	-5
	pushl	-4
	call	_apply
	drop	2
	pushr
	popr
	jmp	__55
__213:
__209:
	jmp	__207
__206:
	pushl	-6
	pushc	78
	lt
	brf	__214
	pushl	-6
	pushc	77
	lt
	brf	__216
	pushl	-5
	call	_cond
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__217
__216:
	pushl	-5
	call	_loop
	drop	1
	pushr
	popr
	jmp	__55
__217:
	jmp	__215
__214:
	pushl	-6
	pushc	79
	lt
	brf	__218
	pushl	-5
	call	_prog1
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__219
__218:
	call	_driver
	pushr
	popr
	jmp	__55
__219:
__215:
__207:
__191:
	jmp	__189
__188:
	pushl	-6
	pushc	88
	lt
	brf	__220
	pushl	-6
	pushc	84
	lt
	brf	__222
	pushl	-6
	pushc	82
	lt
	brf	__224
	pushl	-6
	pushc	81
	lt
	brf	__226
	call	_reclaim
	pushr
	popr
	jmp	__55
	jmp	__227
__226:
	pushl	-5
	pushl	-4
	call	_save
	drop	2
	pushr
	popr
	jmp	__55
__227:
	jmp	__225
__224:
	pushl	-6
	pushc	83
	lt
	brf	__228
	pushl	-5
	pushl	-4
	call	_load
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__229
__228:
	call	_system
	pushr
	popr
	jmp	__55
__229:
__225:
	jmp	__223
__222:
	pushl	-6
	pushc	86
	lt
	brf	__230
	pushl	-6
	pushc	85
	lt
	brf	__232
	pushl	-5
	pushl	-4
	call	_xchgpname
	drop	2
	pushr
	popr
	jmp	__55
	jmp	__233
__232:
	pushl	-5
	call	_purgename
	drop	1
	pushr
	popr
	jmp	__55
__233:
	jmp	__231
__230:
	pushl	-6
	pushc	87
	lt
	brf	__234
	pushc	86
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__235
__234:
	pushc	87
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
__235:
__231:
__223:
	jmp	__221
__220:
	pushl	-6
	pushc	92
	lt
	brf	__236
	pushl	-6
	pushc	90
	lt
	brf	__238
	pushl	-6
	pushc	89
	lt
	brf	__240
	pushc	88
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__241
__240:
	pushc	89
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
__241:
	jmp	__239
__238:
	pushl	-6
	pushc	91
	lt
	brf	__242
	pushc	90
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__243
__242:
	pushc	91
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
__243:
__239:
	jmp	__237
__236:
	pushl	-6
	pushc	94
	lt
	brf	__244
	pushl	-6
	pushc	93
	lt
	brf	__246
	pushc	92
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__247
__246:
	pushc	93
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
__247:
	jmp	__245
__244:
	pushl	-6
	pushc	95
	lt
	brf	__248
	pushc	94
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
	jmp	__249
__248:
	pushc	95
	call	_execErr
	drop	1
	pushr
	popr
	jmp	__55
__249:
__245:
__237:
__221:
__189:
	jmp	__187
__186:
	pushl	-6
	call	_execErr
	drop	1
__187:
__59:
__55:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } car(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_car:
	asf	0
	pushl	-3
	getf	1
	popr
	jmp	__250
__250:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cdr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cdr:
	asf	0
	pushl	-3
	getf	2
	popr
	jmp	__251
__251:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } caar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_caar:
	asf	0
	pushl	-3
	getf	1
	getf	1
	popr
	jmp	__252
__252:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cadr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cadr:
	asf	0
	pushl	-3
	getf	2
	getf	1
	popr
	jmp	__253
__253:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cdar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cdar:
	asf	0
	pushl	-3
	getf	1
	getf	2
	popr
	jmp	__254
__254:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cddr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cddr:
	asf	0
	pushl	-3
	getf	2
	getf	2
	popr
	jmp	__255
__255:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } caaar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_caaar:
	asf	0
	pushl	-3
	getf	1
	getf	1
	getf	1
	popr
	jmp	__256
__256:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } caadr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_caadr:
	asf	0
	pushl	-3
	getf	2
	getf	1
	getf	1
	popr
	jmp	__257
__257:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cadar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cadar:
	asf	0
	pushl	-3
	getf	1
	getf	2
	getf	1
	popr
	jmp	__258
__258:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } caddr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_caddr:
	asf	0
	pushl	-3
	getf	2
	getf	2
	getf	1
	popr
	jmp	__259
__259:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cdaar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cdaar:
	asf	0
	pushl	-3
	getf	1
	getf	1
	getf	2
	popr
	jmp	__260
__260:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cdadr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cdadr:
	asf	0
	pushl	-3
	getf	2
	getf	1
	getf	2
	popr
	jmp	__261
__261:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cddar(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cddar:
	asf	0
	pushl	-3
	getf	1
	getf	2
	getf	2
	popr
	jmp	__262
__262:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cdddr(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cdddr:
	asf	0
	pushl	-3
	getf	2
	getf	2
	getf	2
	popr
	jmp	__263
__263:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cons(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cons:
	asf	0
	pushl	-4
	pushl	-3
	call	_makeNode
	drop	2
	pushr
	popr
	jmp	__264
__264:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } list(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_list:
	asf	2
	pushg	10
	pushg	10
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	0
	pushl	0
	putf	1
	jmp	__267
__266:
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	1
	pushl	0
	getf	1
	pushl	1
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	0
	pushl	0
	getf	1
	getf	2
	putf	1
	pushl	-3
	getf	2
	popl	-3
__267:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__266
__268:
	pushl	0
	getf	1
	pushl	-3
	putf	2
	pushl	0
	getf	2
	popr
	jmp	__265
__265:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } reverse(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_reverse:
	asf	1
	pushl	-3
	popl	0
	jmp	__271
__270:
	pushl	-4
	getf	1
	pushl	0
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	-4
	getf	2
	popl	-4
__271:
	pushl	-4
	getf	0
	pushg	2
	eq
	brt	__270
__272:
	pushl	0
	popr
	jmp	__269
__269:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } oblist()
//
_oblist:
	asf	0
	pushg	8
	call	_copyTree
	drop	1
	pushr
	popr
	jmp	__273
__273:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } rplaca(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_rplaca:
	asf	0
	pushl	-4
	pushl	-3
	putf	1
	pushl	-4
	popr
	jmp	__274
__274:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } rplacd(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_rplacd:
	asf	0
	pushl	-4
	pushl	-3
	putf	2
	pushl	-4
	popr
	jmp	__275
__275:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } nconc(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_nconc:
	asf	1
	pushl	-4
	getf	0
	pushg	2
	ne
	brf	__277
	pushl	-3
	popr
	jmp	__276
__277:
	pushl	-4
	popl	0
	jmp	__279
__278:
	pushl	0
	getf	2
	popl	0
__279:
	pushl	0
	getf	2
	getf	0
	pushg	2
	eq
	brt	__278
__280:
	pushl	0
	pushl	-3
	putf	2
	pushl	-4
	popr
	jmp	__276
__276:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } name(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_name:
	asf	0
	pushl	-3
	getf	0
	pushg	0
	eq
	brf	__282
	pushg	11
	popr
	jmp	__281
__282:
	pushg	10
	popr
	jmp	__281
__281:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } numberp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_numberp:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__284
	pushg	11
	popr
	jmp	__283
__284:
	pushg	10
	popr
	jmp	__283
__283:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } atom(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_atom:
	asf	0
	pushl	-3
	getf	0
	pushg	2
	ne
	brf	__286
	pushg	11
	popr
	jmp	__285
__286:
	pushg	10
	popr
	jmp	__285
__285:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } null(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_null:
	asf	0
	pushl	-3
	pushg	10
	refeq
	brf	__288
	pushg	11
	popr
	jmp	__287
__288:
	pushg	10
	popr
	jmp	__287
__287:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } plusp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_plusp:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	eq
	dup
	brf	__291
	drop	1
	pushl	-3
	getf	5
	pushc	0
	gt
__291:
	brf	__290
	pushg	11
	popr
	jmp	__289
__290:
	pushg	10
	popr
	jmp	__289
__289:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } minusp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_minusp:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	eq
	dup
	brf	__294
	drop	1
	pushl	-3
	getf	5
	pushc	0
	lt
__294:
	brf	__293
	pushg	11
	popr
	jmp	__292
__293:
	pushg	10
	popr
	jmp	__292
__292:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } zerop(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_zerop:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	eq
	dup
	brf	__297
	drop	1
	pushl	-3
	getf	5
	pushc	0
	eq
__297:
	brf	__296
	pushg	11
	popr
	jmp	__295
__296:
	pushg	10
	popr
	jmp	__295
__295:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } even(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_even:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	eq
	dup
	brf	__300
	drop	1
	pushl	-3
	getf	5
	pushc	2
	mod
	pushc	0
	eq
__300:
	brf	__299
	pushg	11
	popr
	jmp	__298
__299:
	pushg	10
	popr
	jmp	__298
__298:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } eq(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_eq:
	asf	0
	pushl	-4
	pushl	-3
	refeq
	brf	__302
	pushg	11
	popr
	jmp	__301
__302:
	pushl	-4
	getf	0
	pushg	1
	eq
	dup
	brf	__305
	drop	1
	pushl	-3
	getf	0
	pushg	1
	eq
__305:
	dup
	brf	__304
	drop	1
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	eq
__304:
	brf	__303
	pushg	11
	popr
	jmp	__301
__303:
	pushg	10
	popr
	jmp	__301
__301:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } equal(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_equal:
	asf	0
	jmp	__308
__307:
	pushl	-4
	getf	1
	pushl	-3
	getf	1
	call	_equal
	drop	2
	pushr
	pushg	10
	refeq
	brf	__310
	pushg	10
	popr
	jmp	__306
__310:
	pushl	-4
	getf	2
	popl	-4
	pushl	-3
	getf	2
	popl	-3
__308:
	pushl	-4
	getf	0
	pushg	2
	eq
	dup
	brf	__311
	drop	1
	pushl	-3
	getf	0
	pushg	2
	eq
__311:
	brt	__307
__309:
	pushl	-4
	pushl	-3
	call	_eq
	drop	2
	pushr
	popr
	jmp	__306
__306:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } member(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_member:
	asf	0
	jmp	__314
__313:
	pushl	-4
	pushl	-3
	getf	1
	call	_equal
	drop	2
	pushr
	pushg	11
	refeq
	brf	__316
	pushg	11
	popr
	jmp	__312
__316:
	pushl	-3
	getf	2
	popl	-3
__314:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__313
__315:
	pushl	-3
	popr
	jmp	__312
__312:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } greaterp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_greaterp:
	asf	0
	pushl	-4
	getf	0
	pushg	1
	eq
	dup
	brf	__320
	drop	1
	pushl	-3
	getf	0
	pushg	1
	eq
__320:
	dup
	brf	__319
	drop	1
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	gt
__319:
	brf	__318
	pushg	11
	popr
	jmp	__317
__318:
	pushg	10
	popr
	jmp	__317
__317:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } lessp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_lessp:
	asf	0
	pushl	-4
	getf	0
	pushg	1
	eq
	dup
	brf	__324
	drop	1
	pushl	-3
	getf	0
	pushg	1
	eq
__324:
	dup
	brf	__323
	drop	1
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	lt
__323:
	brf	__322
	pushg	11
	popr
	jmp	__321
__322:
	pushg	10
	popr
	jmp	__321
__321:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } orderp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_orderp:
	asf	1
	pushl	-4
	getf	0
	pushg	2
	eq
	brf	__326
	pushg	10
	popr
	jmp	__325
__326:
	pushl	-3
	getf	0
	pushg	2
	eq
	brf	__327
	pushg	11
	popr
	jmp	__325
__327:
	pushl	-4
	getf	0
	pushg	1
	eq
	dup
	brf	__329
	drop	1
	pushl	-3
	getf	0
	pushg	1
	eq
__329:
	brf	__328
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	lt
	brf	__330
	pushg	11
	popr
	jmp	__325
__330:
	pushg	10
	popr
	jmp	__325
__328:
	pushl	-4
	getf	0
	pushg	1
	eq
	brf	__331
	pushg	11
	popr
	jmp	__325
__331:
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__332
	pushg	10
	popr
	jmp	__325
__332:
	pushg	8
	popl	0
	jmp	__334
__333:
	pushl	0
	getf	1
	pushl	-4
	refeq
	brf	__336
	pushg	10
	popr
	jmp	__325
__336:
	pushl	0
	getf	1
	pushl	-3
	refeq
	brf	__337
	pushg	11
	popr
	jmp	__325
__337:
	pushl	0
	getf	2
	popl	0
__334:
	pushl	0
	getf	0
	pushg	2
	eq
	brt	__333
__335:
	pushg	10
	popr
	jmp	__325
__325:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } not(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_not:
	asf	0
	pushl	-3
	pushg	10
	refeq
	brf	__339
	pushg	11
	popr
	jmp	__338
__339:
	pushg	10
	popr
	jmp	__338
__338:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } and(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_and:
	asf	0
	jmp	__342
__341:
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushg	10
	refeq
	brf	__344
	pushg	10
	popr
	jmp	__340
__344:
	pushl	-3
	getf	2
	popl	-3
__342:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__341
__343:
	pushg	11
	popr
	jmp	__340
__340:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } or(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_or:
	asf	0
	jmp	__347
__346:
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushg	10
	refne
	brf	__349
	pushg	11
	popr
	jmp	__345
__349:
	pushl	-3
	getf	2
	popl	-3
__347:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__346
__348:
	pushg	10
	popr
	jmp	__345
__345:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } set(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_set:
	asf	0
	pushl	-4
	pushl	-3
	putf	1
	pushl	-3
	popr
	jmp	__350
__350:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } setq(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_setq:
	asf	1
	pushl	-3
	getf	2
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	1
	pushl	0
	putf	1
	pushl	0
	popr
	jmp	__351
__351:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } pop(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_pop:
	asf	1
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	1
	pushl	0
	getf	2
	putf	1
	pushl	0
	getf	1
	popr
	jmp	__352
__352:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } push(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_push:
	asf	3
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	2
	getf	1
	call	_eval
	drop	1
	pushr
	popl	1
	pushl	0
	pushl	1
	call	_makeNode
	drop	2
	pushr
	popl	2
	pushl	-3
	getf	2
	getf	1
	pushl	2
	putf	1
	pushl	2
	popr
	jmp	__353
__353:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } assoc(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_assoc:
	asf	0
	jmp	__356
__355:
	pushl	-3
	getf	1
	getf	0
	pushg	2
	eq
	dup
	brf	__359
	drop	1
	pushl	-3
	getf	1
	getf	1
	pushl	-4
	call	_equal
	drop	2
	pushr
	pushg	11
	refeq
__359:
	brf	__358
	pushl	-3
	getf	1
	popr
	jmp	__354
__358:
	pushl	-3
	getf	2
	popl	-3
__356:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__355
__357:
	pushl	-3
	popr
	jmp	__354
__354:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } get(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_get:
	asf	1
	pushl	-3
	pushl	-4
	getf	2
	call	_assoc
	drop	2
	pushr
	popl	0
	pushl	0
	getf	0
	pushg	2
	ne
	brf	__361
	pushg	10
	popr
	jmp	__360
__361:
	pushl	0
	getf	2
	popr
	jmp	__360
__360:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } put(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_put:
	asf	1
	pushl	-4
	pushl	-5
	getf	2
	call	_assoc
	drop	2
	pushr
	popl	0
	pushl	0
	getf	0
	pushg	2
	ne
	brf	__363
	pushl	-4
	pushl	-3
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	-5
	pushl	0
	pushl	-5
	getf	2
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	-3
	popr
	jmp	__362
__363:
	pushl	0
	pushl	-3
	putf	2
	pushl	-3
	popr
	jmp	__362
__362:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } remprop(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_remprop:
	asf	0
	jmp	__366
__365:
	pushl	-4
	getf	2
	getf	1
	getf	1
	pushl	-3
	call	_equal
	drop	2
	pushr
	pushg	11
	refeq
	brf	__368
	pushl	-4
	getf	2
	getf	1
	getf	2
	popl	-3
	pushl	-4
	pushl	-4
	getf	2
	getf	2
	putf	2
	pushl	-3
	popr
	jmp	__364
__368:
	pushl	-4
	getf	2
	popl	-4
__366:
	pushl	-4
	getf	2
	getf	0
	pushg	2
	eq
	brt	__365
__367:
	pushl	-4
	getf	2
	popr
	jmp	__364
__364:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } flagp(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_flagp:
	asf	0
	pushl	-3
	pushl	-4
	getf	2
	call	_member
	drop	2
	pushr
	popr
	jmp	__369
__369:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } flag(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_flag:
	asf	0
	pushl	-3
	pushl	-4
	getf	2
	call	_member
	drop	2
	pushr
	pushg	11
	refeq
	brf	__371
	pushl	-3
	popr
	jmp	__370
__371:
	pushl	-4
	pushl	-3
	pushl	-4
	getf	2
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	-3
	popr
	jmp	__370
__370:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } remflag(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_remflag:
	asf	0
	jmp	__374
__373:
	pushl	-3
	pushl	-4
	getf	2
	getf	1
	call	_equal
	drop	2
	pushr
	pushg	11
	refeq
	brf	__376
	pushl	-4
	pushl	-4
	getf	2
	getf	2
	putf	2
	pushl	-3
	popr
	jmp	__372
__376:
	pushl	-4
	getf	2
	popl	-4
__374:
	pushl	-4
	getf	2
	getf	0
	pushg	2
	eq
	brt	__373
__375:
	pushg	10
	popr
	jmp	__372
__372:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } getd(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_getd:
	asf	0
	pushl	-3
	getf	0
	pushg	0
	ne
	brf	__378
	pushg	10
	popr
	jmp	__377
__378:
	pushl	-3
	getf	3
	call	_copyTree
	drop	1
	pushr
	popr
	jmp	__377
__377:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } putd(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_putd:
	asf	0
	pushl	-4
	getf	0
	pushg	0
	ne
	brf	__380
	pushg	10
	popr
	jmp	__379
__380:
	pushl	-4
	pushl	-3
	call	_copyTree
	drop	1
	pushr
	putf	3
	pushl	-3
	popr
	jmp	__379
__379:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } movd(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_movd:
	asf	0
	pushl	-4
	getf	0
	pushg	0
	ne
	dup
	brt	__383
	drop	1
	pushl	-3
	getf	0
	pushg	0
	ne
__383:
	brf	__382
	pushg	10
	popr
	jmp	__381
__382:
	pushl	-3
	pushl	-4
	getf	3
	putf	3
	pushl	-3
	getf	3
	call	_copyTree
	drop	1
	pushr
	popr
	jmp	__381
__381:
	rsf
	ret

//
// void addNumberToStringBuffer(record { String str; Integer len; }, Integer)
//
_addNumberToStringBuffer:
	asf	2
	pushl	-3
	pushc	0
	lt
	brf	__385
	pushl	-4
	pushc	45
	call	_addCharToStringBuffer
	drop	2
	pushc	0
	pushl	-3
	sub
	popl	-3
__385:
	pushl	-3
	pushg	106
	div
	popl	0
	pushl	0
	pushc	0
	ne
	brf	__386
	pushl	-4
	pushl	0
	call	_addNumberToStringBuffer
	drop	2
__386:
	pushl	-3
	pushg	106
	mod
	popl	1
	pushl	1
	pushc	10
	lt
	brf	__387
	pushl	-4
	pushc	48
	call	_char2int
	drop	1
	pushr
	pushl	1
	add
	call	_int2char
	drop	1
	pushr
	call	_addCharToStringBuffer
	drop	2
	jmp	__388
__387:
	pushl	0
	pushc	0
	eq
	brf	__389
	pushl	-4
	pushc	48
	call	_addCharToStringBuffer
	drop	2
__389:
	pushl	-4
	pushc	65
	call	_char2int
	drop	1
	pushr
	pushl	1
	pushc	10
	sub
	add
	call	_int2char
	drop	1
	pushr
	call	_addCharToStringBuffer
	drop	2
__388:
__384:
	rsf
	ret

//
// Integer countName(Character[])
//
_countName:
	asf	5
	pushc	0
	popl	0
	pushl	-3
	getsz
	popl	1
	pushc	0
	popl	2
	pushc	0
	popl	4
	jmp	__392
__391:
	pushl	-3
	pushl	2
	getfa
	popl	3
	pushg	86
	getf	1
	pushg	10
	refeq
	dup
	brf	__396
	drop	1
	pushl	3
	call	_isSpecial
	drop	1
	pushr
__396:
	dup
	brf	__395
	drop	1
	pushc	1
	pushl	4
	sub
__395:
	brf	__394
	pushc	1
	popl	4
	pushl	0
	pushc	1
	add
	popl	0
__394:
	pushl	0
	pushc	1
	add
	popl	0
	pushl	3
	pushc	34
	eq
	dup
	brf	__398
	drop	1
	pushl	4
__398:
	brf	__397
	pushl	0
	pushc	1
	add
	popl	0
__397:
	pushl	2
	pushc	1
	add
	popl	2
__392:
	pushl	2
	pushl	1
	lt
	brt	__391
__393:
	pushl	4
	brf	__399
	pushl	0
	pushc	1
	add
	popl	0
__399:
	pushl	0
	popr
	jmp	__390
__390:
	rsf
	ret

//
// Integer countNumber(Integer)
//
_countNumber:
	asf	3
	pushc	0
	popl	0
	pushl	-3
	pushc	0
	lt
	brf	__401
	pushl	0
	pushc	1
	add
	popl	0
	pushc	0
	pushl	-3
	sub
	popl	-3
__401:
	pushl	-3
	pushg	106
	div
	popl	1
	pushl	1
	pushc	0
	ne
	brf	__402
	pushl	0
	pushl	1
	call	_countNumber
	drop	1
	pushr
	add
	popl	0
__402:
	pushl	-3
	pushg	106
	mod
	popl	2
	pushl	1
	pushc	0
	eq
	dup
	brf	__404
	drop	1
	pushl	2
	pushc	10
	ge
__404:
	brf	__403
	pushl	0
	pushc	1
	add
	popl	0
__403:
	pushl	0
	pushc	1
	add
	popl	0
	pushl	0
	popr
	jmp	__400
__400:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } pack(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_pack:
	asf	2
	pushc	20
	call	_newStringBuffer
	drop	1
	pushr
	popl	0
	jmp	__407
__406:
	pushl	-3
	getf	1
	getf	0
	pushg	0
	eq
	brf	__409
	pushl	0
	pushl	-3
	getf	1
	getf	4
	call	_addStringToStringBuffer
	drop	2
	jmp	__410
__409:
	pushl	-3
	getf	1
	getf	0
	pushg	1
	eq
	brf	__411
	pushl	0
	pushl	-3
	getf	1
	getf	5
	call	_addNumberToStringBuffer
	drop	2
__411:
__410:
	pushl	-3
	getf	2
	popl	-3
__407:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__406
__408:
	pushl	0
	call	_stringBufferToString
	drop	1
	pushr
	popl	1
	pushl	1
	call	_searchOblist
	drop	1
	pushr
	popr
	jmp	__405
__405:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } unpack(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_unpack:
	asf	5
	pushc	20
	call	_newStringBuffer
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	0
	pushg	0
	eq
	brf	__413
	pushl	0
	pushl	-3
	getf	4
	call	_addStringToStringBuffer
	drop	2
	jmp	__414
__413:
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__415
	pushl	0
	pushl	-3
	getf	5
	call	_addNumberToStringBuffer
	drop	2
	jmp	__416
__415:
	pushg	10
	popr
	jmp	__412
__416:
__414:
	pushl	0
	call	_stringBufferToString
	drop	1
	pushr
	popl	1
	pushg	10
	pushg	10
	call	_makeNode
	drop	2
	pushr
	popl	3
	pushl	3
	pushl	3
	putf	1
	pushc	0
	popl	2
	jmp	__418
__417:
	pushl	1
	pushl	2
	getfa
	call	_toString
	drop	1
	pushr
	call	_searchOblist
	drop	1
	pushr
	popl	4
	pushl	3
	getf	1
	pushl	4
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	3
	pushl	3
	getf	1
	getf	2
	putf	1
	pushl	2
	pushc	1
	add
	popl	2
__418:
	pushl	2
	pushl	1
	getsz
	lt
	brt	__417
__419:
	pushl	3
	getf	2
	popr
	jmp	__412
__412:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } length(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_length:
	asf	1
	pushl	-3
	getf	0
	pushg	0
	eq
	brf	__421
	pushl	-3
	getf	4
	call	_countName
	drop	1
	pushr
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__420
__421:
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__422
	pushl	-3
	getf	5
	call	_countNumber
	drop	1
	pushr
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__420
__422:
	pushc	0
	popl	0
	jmp	__424
__423:
	pushl	0
	pushc	1
	add
	popl	0
	pushl	-3
	getf	2
	popl	-3
__424:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__423
__425:
	pushl	0
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__420
__420:
	rsf
	ret

//
// void zeroDivideError()
//
_zeroDivideError:
	asf	0
	pushc	17
	newa
	dup
	pushc	0
	pushc	90
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	dup
	pushc	3
	pushc	79
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	68
	putfa
	dup
	pushc	6
	pushc	105
	putfa
	dup
	pushc	7
	pushc	118
	putfa
	dup
	pushc	8
	pushc	105
	putfa
	dup
	pushc	9
	pushc	100
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
	pushc	69
	putfa
	dup
	pushc	13
	pushc	114
	putfa
	dup
	pushc	14
	pushc	114
	putfa
	dup
	pushc	15
	pushc	111
	putfa
	dup
	pushc	16
	pushc	114
	putfa
	pushc	0
	call	_error
	drop	2
__426:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } minus(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_minus:
	asf	0
	pushl	-3
	getf	0
	pushg	1
	ne
	brf	__428
	pushg	10
	popr
	jmp	__427
__428:
	pushc	0
	pushl	-3
	getf	5
	sub
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__427
__427:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } plus(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_plus:
	asf	0
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__431
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__431:
	brf	__430
	pushg	10
	popr
	jmp	__429
__430:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	add
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__429
__429:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } difference(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_difference:
	asf	0
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__434
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__434:
	brf	__433
	pushg	10
	popr
	jmp	__432
__433:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	sub
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__432
__432:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } times(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_times:
	asf	0
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__437
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__437:
	brf	__436
	pushg	10
	popr
	jmp	__435
__436:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	mul
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__435
__435:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } quotient(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_quotient:
	asf	2
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__440
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__440:
	brf	__439
	pushg	10
	popr
	jmp	__438
__439:
	pushl	-3
	getf	5
	pushc	0
	eq
	brf	__441
	call	_zeroDivideError
	pushg	10
	popr
	jmp	__438
__441:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	div
	popl	0
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	mod
	popl	1
	pushl	1
	pushc	0
	lt
	brf	__442
	pushl	0
	pushc	0
	lt
	brf	__443
	pushl	0
	pushc	1
	sub
	popl	0
	jmp	__444
__443:
	pushl	0
	pushc	1
	add
	popl	0
__444:
__442:
	pushl	0
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__438
__438:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } remainder(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_remainder:
	asf	2
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__447
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__447:
	brf	__446
	pushg	10
	popr
	jmp	__445
__446:
	pushl	-3
	getf	5
	pushc	0
	eq
	brf	__448
	call	_zeroDivideError
	pushg	10
	popr
	jmp	__445
__448:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	div
	popl	0
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	mod
	popl	1
	pushl	1
	pushc	0
	lt
	brf	__449
	pushl	0
	pushc	0
	lt
	brf	__450
	pushl	1
	pushl	-3
	getf	5
	add
	popl	1
	jmp	__451
__450:
	pushl	1
	pushl	-3
	getf	5
	sub
	popl	1
__451:
__449:
	pushl	1
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__445
__445:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } divide(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_divide:
	asf	2
	pushl	-4
	getf	0
	pushg	1
	ne
	dup
	brt	__454
	drop	1
	pushl	-3
	getf	0
	pushg	1
	ne
__454:
	brf	__453
	pushg	10
	popr
	jmp	__452
__453:
	pushl	-3
	getf	5
	pushc	0
	eq
	brf	__455
	call	_zeroDivideError
	pushg	10
	popr
	jmp	__452
__455:
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	div
	popl	0
	pushl	-4
	getf	5
	pushl	-3
	getf	5
	mod
	popl	1
	pushl	1
	pushc	0
	lt
	brf	__456
	pushl	0
	pushc	0
	lt
	brf	__457
	pushl	0
	pushc	1
	sub
	popl	0
	pushl	1
	pushl	-3
	getf	5
	add
	popl	1
	jmp	__458
__457:
	pushl	0
	pushc	1
	add
	popl	0
	pushl	1
	pushl	-3
	getf	5
	sub
	popl	1
__458:
__456:
	pushl	0
	call	_makeNumber
	drop	1
	pushr
	pushl	1
	call	_makeNumber
	drop	1
	pushr
	call	_makeNode
	drop	2
	pushr
	popr
	jmp	__452
__452:
	rsf
	ret

//
// void unread(Character)
//
_unread:
	asf	0
	pushc	1
	popg	108
	pushl	-3
	popg	109
__459:
	rsf
	ret

//
// Character readChar()
//
_readChar:
	asf	1
	pushg	108
	brf	__461
	pushc	0
	popg	108
	pushg	109
	popr
	jmp	__460
__461:
	pushg	79
	getf	1
	pushg	10
	refeq
	brf	__462
	pushg	82
	getf	1
	pushg	10
	refeq
	brf	__464
	call	_readCharacter
	pushr
	popl	0
	jmp	__465
__464:
	call	_readCharacter
	pushr
	popl	0
__465:
	jmp	__463
__462:
	pushc	32
	popl	0
	pushg	83
	getf	1
	pushg	10
	refne
	brf	__466
	pushl	0
	call	_printChar
	drop	1
__466:
__463:
	pushg	81
	getf	1
	pushg	10
	refeq
	brf	__467
	pushl	0
	call	_toUpper
	drop	1
	pushr
	popl	0
__467:
	pushl	0
	popr
	jmp	__460
__460:
	rsf
	ret

//
// Character[] readToken(Boolean[], Boolean[])
//
_readToken:
	asf	3
	pushc	0
	popl	0
	call	_readChar
	pushr
	popl	1
	jmp	__470
__469:
	pushl	1
	pushc	37
	eq
	brf	__472
	jmp	__474
__473:
__474:
	call	_readChar
	pushr
	pushc	37
	ne
	brt	__473
__475:
__472:
	call	_readChar
	pushr
	popl	1
__470:
	pushl	1
	pushc	37
	eq
	dup
	brt	__476
	drop	1
	pushl	-4
	pushl	1
	call	_char2int
	drop	1
	pushr
	getfa
__476:
	brt	__469
__471:
	pushl	-3
	pushl	1
	call	_char2int
	drop	1
	pushr
	getfa
	brf	__477
	pushc	1
	popg	107
	pushl	1
	call	_toString
	drop	1
	pushr
	popr
	jmp	__468
__477:
	pushc	20
	call	_newStringBuffer
	drop	1
	pushr
	popl	2
	jmp	__479
__478:
	pushl	0
	brf	__481
	pushl	1
	pushc	34
	eq
	brf	__483
	call	_readChar
	pushr
	popl	1
	pushl	1
	pushc	34
	eq
	brf	__485
	pushl	2
	pushl	1
	call	_addCharToStringBuffer
	drop	2
	call	_readChar
	pushr
	popl	1
	jmp	__486
__485:
	pushc	0
	popl	0
__486:
	jmp	__484
__483:
	pushl	2
	pushl	1
	call	_addCharToStringBuffer
	drop	2
	call	_readChar
	pushr
	popl	1
__484:
	jmp	__482
__481:
	pushl	1
	pushc	34
	eq
	brf	__487
	pushc	1
	popl	0
	call	_readChar
	pushr
	popl	1
	jmp	__488
__487:
	pushl	1
	pushc	37
	eq
	brf	__489
	jmp	__492
__491:
__492:
	call	_readChar
	pushr
	pushc	37
	ne
	brt	__491
__493:
	call	_readChar
	pushr
	popl	1
	jmp	__490
__489:
	pushl	-4
	pushl	1
	call	_char2int
	drop	1
	pushr
	getfa
	dup
	brt	__496
	drop	1
	pushl	-3
	pushl	1
	call	_char2int
	drop	1
	pushr
	getfa
__496:
	brf	__494
	pushl	1
	call	_unread
	drop	1
	pushc	0
	popg	107
	pushl	2
	call	_stringBufferToString
	drop	1
	pushr
	popr
	jmp	__468
	jmp	__495
__494:
	pushl	2
	pushl	1
	call	_addCharToStringBuffer
	drop	2
	call	_readChar
	pushr
	popl	1
__495:
__490:
__488:
__482:
__479:
	pushc	1
	brt	__478
__480:
__468:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } tokenToAtom(Character[])
//
_tokenToAtom:
	asf	7
	pushc	1
	popl	0
	pushc	0
	popl	1
	pushc	0
	popl	2
	pushc	0
	popl	3
	pushl	3
	pushl	-3
	getsz
	lt
	dup
	brf	__499
	drop	1
	pushl	-3
	pushl	3
	getfa
	pushc	45
	eq
__499:
	brf	__498
	pushc	1
	popl	1
	pushl	3
	pushc	1
	add
	popl	3
__498:
	pushl	3
	pushl	-3
	getsz
	lt
	dup
	brf	__502
	drop	1
	pushl	-3
	pushl	3
	getfa
	call	_isDigit
	drop	1
	pushr
__502:
	brf	__500
	jmp	__504
__503:
	pushl	-3
	pushl	3
	getfa
	popl	4
	pushl	3
	pushc	1
	add
	popl	3
	pushl	4
	call	_isDigit
	drop	1
	pushr
	brf	__506
	pushl	4
	call	_char2int
	drop	1
	pushr
	pushc	48
	call	_char2int
	drop	1
	pushr
	sub
	popl	5
	pushl	5
	pushg	106
	lt
	brf	__508
	pushl	2
	pushg	106
	mul
	pushl	5
	add
	popl	2
	jmp	__509
__508:
	pushc	0
	popl	0
	jmp	__505
__509:
	jmp	__507
__506:
	pushl	4
	call	_isAlpha
	drop	1
	pushr
	brf	__510
	pushl	4
	call	_toUpper
	drop	1
	pushr
	popl	4
	pushl	4
	call	_char2int
	drop	1
	pushr
	pushc	65
	call	_char2int
	drop	1
	pushr
	sub
	popl	5
	pushl	5
	pushg	106
	lt
	brf	__512
	pushl	2
	pushg	106
	mul
	pushl	5
	add
	popl	2
	jmp	__513
__512:
	pushc	0
	popl	0
	jmp	__505
__513:
	jmp	__511
__510:
	pushc	0
	popl	0
	jmp	__505
__511:
__507:
__504:
	pushl	3
	pushl	-3
	getsz
	lt
	brt	__503
__505:
	jmp	__501
__500:
	pushc	0
	popl	0
__501:
	pushl	0
	brf	__514
	pushl	1
	brf	__516
	pushc	0
	pushl	2
	sub
	popl	2
__516:
	pushl	2
	call	_makeNumber
	drop	1
	pushr
	popl	6
	jmp	__515
__514:
	pushl	-3
	call	_searchOblist
	drop	1
	pushr
	popl	6
__515:
	pushg	80
	pushl	6
	putf	1
	pushl	6
	popr
	jmp	__497
__497:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } read0(Character[])
//
_read0:
	asf	1
	jmp	__519
__518:
	pushc	1
	pushg	107
	sub
	brf	__521
	pushl	-3
	call	_tokenToAtom
	drop	1
	pushr
	popr
	jmp	__517
__521:
	pushl	-3
	pushc	0
	getfa
	popl	0
	pushl	0
	pushc	40
	eq
	brf	__522
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	pushl	-3
	call	_readList
	drop	1
	pushr
	popr
	jmp	__517
	jmp	__523
__522:
	pushl	0
	pushc	91
	eq
	brf	__524
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	pushl	-3
	call	_readBracket
	drop	1
	pushr
	popr
	jmp	__517
	jmp	__525
__524:
	pushl	0
	pushc	41
	eq
	dup
	brt	__529
	drop	1
	pushl	0
	pushc	93
	eq
__529:
	dup
	brt	__528
	drop	1
	pushl	0
	pushc	46
	eq
__528:
	brf	__526
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	jmp	__527
__526:
	pushc	20
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
	pushc	110
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
	pushc	32
	putfa
	dup
	pushc	9
	pushc	114
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	97
	putfa
	dup
	pushc	12
	pushc	100
	putfa
	dup
	pushc	13
	pushc	48
	putfa
	dup
	pushc	14
	pushc	32
	putfa
	dup
	pushc	15
	pushc	101
	putfa
	dup
	pushc	16
	pushc	114
	putfa
	dup
	pushc	17
	pushc	114
	putfa
	dup
	pushc	18
	pushc	111
	putfa
	dup
	pushc	19
	pushc	114
	putfa
	pushc	1
	call	_error
	drop	2
__527:
__525:
__523:
__519:
	pushc	1
	brt	__518
__520:
__517:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } readList(Character[])
//
_readList:
	asf	2
	pushg	10
	pushg	10
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	0
	pushl	0
	putf	1
	jmp	__532
__531:
	pushg	107
	dup
	brf	__536
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	41
	eq
__536:
	brf	__534
	pushl	0
	getf	2
	popr
	jmp	__530
	jmp	__535
__534:
	pushg	107
	dup
	brf	__539
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	93
	eq
__539:
	brf	__537
	pushc	93
	call	_unread
	drop	1
	pushl	0
	getf	2
	popr
	jmp	__530
	jmp	__538
__537:
	pushg	107
	dup
	brf	__542
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	46
	eq
__542:
	brf	__540
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	pushl	-3
	call	_read0
	drop	1
	pushr
	popl	1
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	pushg	107
	dup
	brf	__545
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	41
	eq
__545:
	brf	__543
	pushl	0
	getf	1
	pushl	1
	putf	2
	pushl	0
	getf	2
	popr
	jmp	__530
	jmp	__544
__543:
	pushg	107
	dup
	brf	__548
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	93
	eq
__548:
	brf	__546
	pushc	93
	call	_unread
	drop	1
	pushl	0
	getf	1
	pushl	1
	putf	2
	pushl	0
	getf	2
	popr
	jmp	__530
	jmp	__547
__546:
	pushl	0
	getf	1
	pushl	1
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	0
	pushl	0
	getf	1
	getf	2
	putf	1
__547:
__544:
	jmp	__541
__540:
	pushl	-3
	call	_read0
	drop	1
	pushr
	popl	1
	pushl	0
	getf	1
	pushl	1
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	0
	pushl	0
	getf	1
	getf	2
	putf	1
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
__541:
__538:
__535:
__532:
	pushc	1
	brt	__531
__533:
__530:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } readBracket(Character[])
//
_readBracket:
	asf	2
	pushl	-3
	call	_readList
	drop	1
	pushr
	popl	0
	jmp	__551
__550:
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	-3
	pushg	107
	dup
	brf	__555
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	41
	eq
__555:
	brf	__553
	pushl	0
	popr
	jmp	__549
	jmp	__554
__553:
	pushg	107
	dup
	brf	__558
	drop	1
	pushl	-3
	pushc	0
	getfa
	pushc	93
	eq
__558:
	brf	__556
	pushl	0
	popr
	jmp	__549
	jmp	__557
__556:
	pushl	-3
	call	_readList
	drop	1
	pushr
	popl	1
	pushl	0
	pushl	1
	call	_makeNode
	drop	2
	pushr
	popl	0
__557:
__554:
__551:
	pushc	1
	brt	__550
__552:
__549:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } rds(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_rds:
	asf	0
	pushg	10
	popr
	jmp	__559
__559:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } ratom()
//
_ratom:
	asf	1
	pushg	3
	pushg	4
	call	_readToken
	drop	2
	pushr
	popl	0
	pushl	0
	call	_tokenToAtom
	drop	1
	pushr
	popr
	jmp	__560
__560:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } read()
//
_read:
	asf	1
	pushg	5
	pushg	6
	call	_readToken
	drop	2
	pushr
	popl	0
	pushl	0
	call	_read0
	drop	1
	pushr
	popr
	jmp	__561
__561:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } readch()
//
_readch:
	asf	4
	call	_readChar
	pushr
	popl	0
	pushl	0
	call	_isDigit
	drop	1
	pushr
	brf	__563
	pushl	0
	call	_char2int
	drop	1
	pushr
	pushc	48
	call	_char2int
	drop	1
	pushr
	sub
	popl	1
	pushl	1
	pushg	106
	lt
	brf	__565
	pushl	1
	call	_makeNumber
	drop	1
	pushr
	popl	3
	jmp	__566
__565:
	pushl	0
	call	_toString
	drop	1
	pushr
	popl	2
	pushl	2
	call	_searchOblist
	drop	1
	pushr
	popl	3
__566:
	jmp	__564
__563:
	pushl	0
	call	_toString
	drop	1
	pushr
	popl	2
	pushl	2
	call	_searchOblist
	drop	1
	pushr
	popl	3
__564:
	pushg	80
	pushl	3
	putf	1
	pushl	3
	popr
	jmp	__562
__562:
	rsf
	ret

//
// void putConsole(Character)
//
_putConsole:
	asf	0
	pushl	-3
	call	_writeCharacter
	drop	1
__567:
	rsf
	ret

//
// void printChar(Character)
//
_printChar:
	asf	1
	pushg	85
	getf	1
	pushg	10
	refeq
	brf	__569
	pushl	-3
	call	_toLower
	drop	1
	pushr
	popl	-3
__569:
	pushg	84
	getf	1
	pushg	10
	refeq
	brf	__570
	pushl	-3
	call	_putConsole
	drop	1
	jmp	__571
__570:
	pushg	83
	getf	1
	pushg	10
	refne
	brf	__572
	pushl	-3
	call	_putConsole
	drop	1
__572:
__571:
	pushl	-3
	call	_char2int
	drop	1
	pushr
	popl	0
	pushl	0
	pushc	8
	eq
	brf	__573
	pushg	104
	pushc	1
	sub
	popg	104
	jmp	__574
__573:
	pushl	0
	pushc	9
	eq
	brf	__575
	pushg	104
	pushc	8
	add
	pushc	8
	div
	pushc	8
	mul
	popg	104
	jmp	__576
__575:
	pushl	0
	pushc	10
	eq
	brf	__577
	pushc	0
	popg	104
	jmp	__578
__577:
	pushl	0
	pushc	11
	eq
	brf	__579
	pushc	0
	popg	104
	jmp	__580
__579:
	pushl	0
	pushc	12
	eq
	brf	__581
	pushc	0
	popg	104
	jmp	__582
__581:
	pushl	0
	pushc	13
	eq
	brf	__583
	pushc	0
	popg	104
	jmp	__584
__583:
	pushg	104
	pushc	1
	add
	popg	104
__584:
__582:
__580:
__578:
__576:
__574:
__568:
	rsf
	ret

//
// Boolean isSpecial(Character)
//
_isSpecial:
	asf	1
	pushl	-3
	call	_char2int
	drop	1
	pushr
	popl	0
	pushg	7
	pushl	0
	getfa
	dup
	brt	__587
	drop	1
	pushg	6
	pushl	0
	getfa
__587:
	dup
	brt	__586
	drop	1
	pushg	5
	pushl	0
	getfa
__586:
	popr
	jmp	__585
__585:
	rsf
	ret

//
// void printName(Character[])
//
_printName:
	asf	4
	pushl	-3
	getsz
	popl	0
	pushc	0
	popl	1
	pushc	0
	popl	3
	jmp	__590
__589:
	pushl	-3
	pushl	1
	getfa
	popl	2
	pushg	86
	getf	1
	pushg	10
	refeq
	dup
	brf	__594
	drop	1
	pushl	2
	call	_isSpecial
	drop	1
	pushr
__594:
	dup
	brf	__593
	drop	1
	pushc	1
	pushl	3
	sub
__593:
	brf	__592
	pushc	1
	popl	3
	pushc	34
	call	_printChar
	drop	1
__592:
	pushl	2
	call	_printChar
	drop	1
	pushl	2
	pushc	34
	eq
	dup
	brf	__596
	drop	1
	pushl	3
__596:
	brf	__595
	pushc	34
	call	_printChar
	drop	1
__595:
	pushl	1
	pushc	1
	add
	popl	1
__590:
	pushl	1
	pushl	0
	lt
	brt	__589
__591:
	pushl	3
	brf	__597
	pushc	34
	call	_printChar
	drop	1
__597:
__588:
	rsf
	ret

//
// void printNumber(Integer)
//
_printNumber:
	asf	2
	pushl	-3
	pushc	0
	lt
	brf	__599
	pushc	45
	call	_printChar
	drop	1
	pushc	0
	pushl	-3
	sub
	popl	-3
__599:
	pushl	-3
	pushg	106
	div
	popl	0
	pushl	0
	pushc	0
	ne
	brf	__600
	pushl	0
	call	_printNumber
	drop	1
__600:
	pushl	-3
	pushg	106
	mod
	popl	1
	pushl	1
	pushc	10
	lt
	brf	__601
	pushc	48
	call	_char2int
	drop	1
	pushr
	pushl	1
	add
	call	_int2char
	drop	1
	pushr
	call	_printChar
	drop	1
	jmp	__602
__601:
	pushl	0
	pushc	0
	eq
	brf	__603
	pushc	48
	call	_printChar
	drop	1
__603:
	pushc	65
	call	_char2int
	drop	1
	pushr
	pushl	1
	pushc	10
	sub
	add
	call	_int2char
	drop	1
	pushr
	call	_printChar
	drop	1
__602:
__598:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } wrs(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_wrs:
	asf	0
	pushg	10
	popr
	jmp	__604
__604:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } print(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_print:
	asf	0
	pushl	-3
	call	_prin1
	drop	1
	pushc	10
	call	_printChar
	drop	1
	pushl	-3
	popr
	jmp	__605
__605:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } prin1(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_prin1:
	asf	0
	pushl	-3
	getf	0
	pushg	0
	eq
	brf	__607
	pushl	-3
	getf	4
	call	_printName
	drop	1
	pushl	-3
	popr
	jmp	__606
__607:
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__608
	pushl	-3
	getf	5
	call	_printNumber
	drop	1
	pushl	-3
	popr
	jmp	__606
__608:
	pushc	40
	call	_printChar
	drop	1
	pushl	-3
	getf	1
	call	_prin1
	drop	1
	pushl	-3
	getf	2
	popl	-3
	jmp	__610
__609:
	pushc	32
	call	_printChar
	drop	1
	pushl	-3
	getf	1
	call	_prin1
	drop	1
	pushl	-3
	getf	2
	popl	-3
__610:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__609
__611:
	pushl	-3
	pushg	10
	refne
	brf	__612
	pushc	32
	call	_printChar
	drop	1
	pushc	46
	call	_printChar
	drop	1
	pushc	32
	call	_printChar
	drop	1
	pushl	-3
	call	_prin1
	drop	1
__612:
	pushc	41
	call	_printChar
	drop	1
	pushl	-3
	popr
	jmp	__606
__606:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } terpri(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_terpri:
	asf	1
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__614
	pushl	-3
	getf	5
	popl	0
	pushl	0
	pushc	0
	lt
	dup
	brt	__616
	drop	1
	pushl	0
	pushc	255
	gt
__616:
	brf	__615
	pushc	10
	call	_printChar
	drop	1
	pushg	10
	popr
	jmp	__613
__615:
	jmp	__618
__617:
	pushc	10
	call	_printChar
	drop	1
	pushl	0
	pushc	1
	sub
	popl	0
__618:
	pushl	0
	pushc	0
	gt
	brt	__617
__619:
	pushg	10
	popr
	jmp	__613
__614:
	pushc	10
	call	_printChar
	drop	1
	pushg	10
	popr
	jmp	__613
__613:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } spaces(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_spaces:
	asf	1
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__621
	pushl	-3
	getf	5
	popl	0
	pushl	0
	pushc	0
	lt
	dup
	brt	__623
	drop	1
	pushl	0
	pushc	255
	gt
__623:
	brf	__622
	pushg	104
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__620
__622:
	jmp	__625
__624:
	pushc	32
	call	_printChar
	drop	1
	pushl	0
	pushc	1
	sub
	popl	0
__625:
	pushl	0
	pushc	0
	gt
	brt	__624
__626:
	pushg	104
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__620
__621:
	pushg	104
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__620
__620:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } linelength(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_linelength:
	asf	2
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__628
	pushl	-3
	getf	5
	popl	0
	pushl	0
	pushc	11
	gt
	dup
	brf	__630
	drop	1
	pushl	0
	pushc	256
	lt
__630:
	brf	__629
	pushg	105
	call	_makeNumber
	drop	1
	pushr
	popl	1
	pushl	0
	popg	105
	pushl	1
	popr
	jmp	__627
__629:
	pushg	105
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__627
__628:
	pushg	105
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__627
__627:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } radix(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_radix:
	asf	2
	pushl	-3
	getf	0
	pushg	1
	eq
	brf	__632
	pushl	-3
	getf	5
	popl	0
	pushl	0
	pushc	1
	gt
	dup
	brf	__634
	drop	1
	pushl	0
	pushc	37
	lt
__634:
	brf	__633
	pushg	106
	call	_makeNumber
	drop	1
	pushr
	popl	1
	pushl	0
	popg	106
	pushl	1
	popr
	jmp	__631
__633:
	pushg	106
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__631
__632:
	pushg	106
	call	_makeNumber
	drop	1
	pushr
	popr
	jmp	__631
__631:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } evlis(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_evlis:
	asf	2
	pushg	10
	pushg	10
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	0
	pushl	0
	putf	1
	jmp	__637
__636:
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	1
	pushl	0
	getf	1
	pushl	1
	pushg	10
	call	_makeNode
	drop	2
	pushr
	putf	2
	pushl	0
	pushl	0
	getf	1
	getf	2
	putf	1
	pushl	-3
	getf	2
	popl	-3
__637:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__636
__638:
	pushl	0
	getf	1
	pushl	-3
	putf	2
	pushl	0
	getf	2
	popr
	jmp	__635
__635:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } evalbody(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_evalbody:
	asf	1
	pushl	-4
	popl	0
	jmp	__641
__640:
	pushl	-3
	getf	1
	getf	0
	pushg	2
	ne
	dup
	brt	__645
	drop	1
	pushl	-3
	getf	1
	getf	1
	getf	0
	pushg	2
	ne
__645:
	brf	__643
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	2
	popl	-3
	jmp	__644
__643:
	pushl	-3
	getf	1
	getf	1
	getf	1
	getf	0
	pushg	2
	ne
	brf	__646
	pushl	-3
	getf	1
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	0
	pushg	10
	refeq
	brf	__648
	pushl	-3
	getf	2
	popl	-3
	jmp	__649
__648:
	pushl	-3
	getf	1
	getf	2
	popl	-3
__649:
	jmp	__647
__646:
	pushl	0
	pushl	-3
	getf	1
	call	_evalbody
	drop	2
	pushr
	popl	0
	pushl	-3
	getf	2
	popl	-3
__647:
__644:
__641:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__640
__642:
	pushl	0
	popr
	jmp	__639
__639:
	rsf
	ret

//
// void bind(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_bind:
	asf	0
	pushl	-4
	getf	0
	pushg	2
	ne
	brf	__651
	pushl	-4
	pushg	10
	refne
	brf	__652
	pushl	-4
	getf	1
	pushg	9
	call	_makeNode
	drop	2
	pushr
	popg	9
	pushl	-4
	pushl	-3
	putf	1
__652:
	jmp	__650
__651:
	jmp	__654
__653:
	pushl	-4
	getf	1
	getf	1
	pushg	9
	call	_makeNode
	drop	2
	pushr
	popg	9
	pushl	-4
	getf	1
	pushl	-3
	getf	1
	putf	1
	pushl	-4
	getf	2
	popl	-4
	pushl	-3
	getf	2
	popl	-3
__654:
	pushl	-4
	getf	0
	pushg	2
	eq
	dup
	brf	__656
	drop	1
	pushl	-3
	getf	0
	pushg	2
	eq
__656:
	brt	__653
__655:
	jmp	__658
__657:
	pushl	-4
	getf	1
	getf	1
	pushg	9
	call	_makeNode
	drop	2
	pushr
	popg	9
	pushl	-4
	getf	1
	pushg	10
	putf	1
	pushl	-4
	getf	2
	popl	-4
__658:
	pushl	-4
	getf	0
	pushg	2
	eq
	brt	__657
__659:
__650:
	rsf
	ret

//
// void unbind(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_unbind:
	asf	1
	pushl	-3
	getf	0
	pushg	2
	ne
	brf	__661
	pushl	-3
	pushg	10
	refne
	brf	__662
	pushl	-3
	pushg	9
	getf	1
	putf	1
	pushg	9
	getf	2
	popg	9
__662:
	jmp	__660
__661:
	pushg	10
	popl	0
	jmp	__664
__663:
	pushl	-3
	getf	1
	pushl	0
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	-3
	getf	2
	popl	-3
__664:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__663
__665:
	jmp	__667
__666:
	pushl	0
	getf	1
	pushg	9
	getf	1
	putf	1
	pushg	9
	getf	2
	popg	9
	pushl	0
	getf	2
	popl	0
__667:
	pushl	0
	getf	0
	pushg	2
	eq
	brt	__666
__668:
__660:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } quote(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_quote:
	asf	0
	pushl	-3
	getf	1
	popr
	jmp	__669
__669:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } eval(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_eval:
	asf	1
	pushl	-3
	getf	0
	pushg	2
	ne
	brf	__671
	pushl	-3
	getf	1
	popr
	jmp	__670
__671:
	pushl	-3
	getf	1
	getf	0
	pushg	0
	eq
	brf	__672
	pushl	-3
	getf	1
	getf	3
	pushg	10
	refeq
	brf	__673
	pushl	-3
	getf	1
	pushl	-3
	getf	1
	getf	1
	refeq
	brf	__674
	pushl	-3
	call	_evlis
	drop	1
	pushr
	popr
	jmp	__670
__674:
	pushl	-3
	getf	1
	getf	1
	pushl	-3
	getf	2
	call	_makeNode
	drop	2
	pushr
	popl	0
	pushl	0
	call	_eval
	drop	1
	pushr
	popr
	jmp	__670
__673:
	pushl	-3
	getf	1
	getf	3
	getf	1
	pushg	12
	refeq
	dup
	brt	__676
	drop	1
	pushl	-3
	getf	1
	getf	3
	getf	1
	pushg	14
	refeq
__676:
	brf	__675
	pushl	-3
	getf	2
	call	_evlis
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	1
	pushl	0
	call	_apply
	drop	2
	pushr
	popr
	jmp	__670
__675:
	pushl	-3
	getf	1
	getf	3
	getf	1
	pushg	13
	refeq
	dup
	brt	__678
	drop	1
	pushl	-3
	getf	1
	getf	3
	getf	1
	pushg	15
	refeq
__678:
	brf	__677
	pushl	-3
	getf	1
	pushl	-3
	getf	2
	call	_apply
	drop	2
	pushr
	popr
	jmp	__670
__677:
	pushl	-3
	call	_evlis
	drop	1
	pushr
	popr
	jmp	__670
__672:
	pushl	-3
	getf	1
	getf	1
	pushg	14
	refeq
	brf	__679
	pushl	-3
	getf	2
	call	_evlis
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	1
	pushl	0
	call	_apply
	drop	2
	pushr
	popr
	jmp	__670
__679:
	pushl	-3
	getf	1
	getf	1
	pushg	15
	refeq
	brf	__680
	pushl	-3
	getf	1
	pushl	-3
	getf	2
	call	_apply
	drop	2
	pushr
	popr
	jmp	__670
__680:
	pushl	-3
	call	_evlis
	drop	1
	pushr
	popr
	jmp	__670
__670:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } apply(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_apply:
	asf	1
	pushl	-4
	getf	0
	pushg	0
	eq
	brf	__682
	pushl	-4
	getf	3
	pushg	10
	refeq
	brf	__683
	pushl	-4
	pushl	-4
	getf	1
	refeq
	brf	__684
	pushg	10
	popr
	jmp	__681
__684:
	pushl	-4
	getf	1
	pushl	-3
	call	_apply
	drop	2
	pushr
	popr
	jmp	__681
__683:
	pushl	-4
	getf	3
	getf	1
	pushg	12
	refeq
	brf	__685
	pushl	-3
	getf	0
	pushg	2
	ne
	brf	__686
	pushl	-4
	getf	3
	getf	2
	getf	5
	pushg	10
	pushg	10
	pushg	10
	call	_exec
	drop	4
	pushr
	popr
	jmp	__681
__686:
	pushl	-3
	getf	2
	getf	0
	pushg	2
	ne
	brf	__687
	pushl	-4
	getf	3
	getf	2
	getf	5
	pushl	-3
	getf	1
	pushg	10
	pushg	10
	call	_exec
	drop	4
	pushr
	popr
	jmp	__681
__687:
	pushl	-3
	getf	2
	getf	2
	getf	0
	pushg	2
	ne
	brf	__688
	pushl	-4
	getf	3
	getf	2
	getf	5
	pushl	-3
	getf	1
	pushl	-3
	getf	2
	getf	1
	pushg	10
	call	_exec
	drop	4
	pushr
	popr
	jmp	__681
__688:
	pushl	-4
	getf	3
	getf	2
	getf	5
	pushl	-3
	getf	1
	pushl	-3
	getf	2
	getf	1
	pushl	-3
	getf	2
	getf	2
	getf	1
	call	_exec
	drop	4
	pushr
	popr
	jmp	__681
__685:
	pushl	-4
	getf	3
	getf	1
	pushg	13
	refeq
	brf	__689
	pushl	-4
	getf	3
	getf	2
	getf	5
	pushl	-3
	pushg	10
	pushg	10
	call	_exec
	drop	4
	pushr
	popr
	jmp	__681
__689:
	pushl	-4
	getf	3
	getf	1
	pushg	14
	refeq
	dup
	brt	__691
	drop	1
	pushl	-4
	getf	3
	getf	1
	pushg	15
	refeq
__691:
	brf	__690
	pushl	-4
	getf	3
	getf	2
	getf	1
	pushl	-3
	call	_bind
	drop	2
	pushg	10
	pushl	-4
	getf	3
	getf	2
	getf	2
	call	_evalbody
	drop	2
	pushr
	popl	0
	pushl	-4
	getf	3
	getf	2
	getf	1
	call	_unbind
	drop	1
	pushl	0
	popr
	jmp	__681
__690:
	pushg	10
	popr
	jmp	__681
__682:
	pushl	-4
	getf	1
	pushg	14
	refeq
	dup
	brt	__693
	drop	1
	pushl	-4
	getf	1
	pushg	15
	refeq
__693:
	brf	__692
	pushl	-4
	getf	2
	getf	1
	pushl	-3
	call	_bind
	drop	2
	pushg	10
	pushl	-4
	getf	2
	getf	2
	call	_evalbody
	drop	2
	pushr
	popl	0
	pushl	-4
	getf	2
	getf	1
	call	_unbind
	drop	1
	pushl	0
	popr
	jmp	__681
__692:
	pushg	10
	popr
	jmp	__681
__681:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } cond(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_cond:
	asf	1
	jmp	__696
__695:
	pushl	-3
	getf	1
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	0
	pushg	10
	refne
	brf	__698
	pushl	0
	pushl	-3
	getf	1
	getf	2
	call	_evalbody
	drop	2
	pushr
	popr
	jmp	__694
__698:
	pushl	-3
	getf	2
	popl	-3
__696:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__695
__697:
	pushg	10
	popr
	jmp	__694
__694:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } loop(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_loop:
	asf	2
	jmp	__701
__700:
	pushl	-3
	popl	0
	jmp	__704
__703:
	pushl	0
	getf	1
	getf	0
	pushg	2
	ne
	dup
	brt	__708
	drop	1
	pushl	0
	getf	1
	getf	1
	getf	0
	pushg	2
	ne
__708:
	brf	__706
	pushl	0
	getf	1
	call	_eval
	drop	1
	pushl	0
	getf	2
	popl	0
	jmp	__707
__706:
	pushl	0
	getf	1
	getf	1
	getf	1
	getf	0
	pushg	2
	ne
	brf	__709
	pushl	0
	getf	1
	getf	1
	call	_eval
	drop	1
	pushr
	popl	1
	pushl	1
	pushg	10
	refne
	brf	__711
	pushl	1
	pushl	0
	getf	1
	getf	2
	call	_evalbody
	drop	2
	pushr
	popr
	jmp	__699
__711:
	pushl	0
	getf	2
	popl	0
	jmp	__710
__709:
	pushg	10
	pushl	0
	getf	1
	call	_evalbody
	drop	2
	pushl	0
	getf	2
	popl	0
__710:
__707:
__704:
	pushl	0
	getf	0
	pushg	2
	eq
	brt	__703
__705:
__701:
	pushc	1
	brt	__700
__702:
__699:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } prog1(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_prog1:
	asf	1
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	popl	0
	pushl	-3
	getf	2
	popl	-3
	jmp	__714
__713:
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushl	-3
	getf	2
	popl	-3
__714:
	pushl	-3
	getf	0
	pushg	2
	eq
	brt	__713
__715:
	pushl	0
	popr
	jmp	__712
__712:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } driver()
//
_driver:
	asf	2
	pushg	79
	pushg	10
	putf	1
	pushg	84
	pushg	10
	putf	1
	pushg	83
	pushg	10
	putf	1
	pushg	82
	pushg	82
	putf	1
	jmp	__718
__717:
	pushc	10
	call	_printChar
	drop	1
	pushc	36
	call	_printChar
	drop	1
	pushc	10
	call	_printChar
	drop	1
	call	_read
	pushr
	popl	0
	pushl	0
	call	_eval
	drop	1
	pushr
	popl	1
	pushl	1
	call	_print
	drop	1
__718:
	pushc	1
	brt	__717
__719:
	pushg	10
	popr
	jmp	__716
__716:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } reclaim()
//
_reclaim:
	asf	0
	pushc	23
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	67
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	dup
	pushc	4
	pushc	65
	putfa
	dup
	pushc	5
	pushc	73
	putfa
	dup
	pushc	6
	pushc	77
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	dup
	pushc	8
	pushc	110
	putfa
	dup
	pushc	9
	pushc	111
	putfa
	dup
	pushc	10
	pushc	116
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
	pushc	109
	putfa
	dup
	pushc	14
	pushc	112
	putfa
	dup
	pushc	15
	pushc	108
	putfa
	dup
	pushc	16
	pushc	101
	putfa
	dup
	pushc	17
	pushc	109
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	110
	putfa
	dup
	pushc	20
	pushc	116
	putfa
	dup
	pushc	21
	pushc	101
	putfa
	dup
	pushc	22
	pushc	100
	putfa
	pushc	0
	call	_error
	drop	2
	pushg	10
	popr
	jmp	__720
__720:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } save(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_save:
	asf	0
	pushc	20
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	86
	putfa
	dup
	pushc	3
	pushc	69
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
	pushc	111
	putfa
	dup
	pushc	7
	pushc	116
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	105
	putfa
	dup
	pushc	10
	pushc	109
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
	pushc	109
	putfa
	dup
	pushc	15
	pushc	101
	putfa
	dup
	pushc	16
	pushc	110
	putfa
	dup
	pushc	17
	pushc	116
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	100
	putfa
	pushc	0
	call	_error
	drop	2
	pushg	10
	popr
	jmp	__721
__721:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } load(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_load:
	asf	0
	pushc	20
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
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
	pushc	111
	putfa
	dup
	pushc	7
	pushc	116
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	105
	putfa
	dup
	pushc	10
	pushc	109
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
	pushc	109
	putfa
	dup
	pushc	15
	pushc	101
	putfa
	dup
	pushc	16
	pushc	110
	putfa
	dup
	pushc	17
	pushc	116
	putfa
	dup
	pushc	18
	pushc	101
	putfa
	dup
	pushc	19
	pushc	100
	putfa
	pushc	0
	call	_error
	drop	2
	pushg	10
	popr
	jmp	__722
__722:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } system()
//
_system:
	asf	0
	pushc	31
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
	pushc	104
	putfa
	dup
	pushc	3
	pushc	97
	putfa
	dup
	pushc	4
	pushc	110
	putfa
	dup
	pushc	5
	pushc	107
	putfa
	dup
	pushc	6
	pushc	115
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	dup
	pushc	8
	pushc	102
	putfa
	dup
	pushc	9
	pushc	111
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
	pushc	117
	putfa
	dup
	pushc	13
	pushc	115
	putfa
	dup
	pushc	14
	pushc	105
	putfa
	dup
	pushc	15
	pushc	110
	putfa
	dup
	pushc	16
	pushc	103
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	78
	putfa
	dup
	pushc	19
	pushc	105
	putfa
	dup
	pushc	20
	pushc	110
	putfa
	dup
	pushc	21
	pushc	106
	putfa
	dup
	pushc	22
	pushc	97
	putfa
	dup
	pushc	23
	pushc	32
	putfa
	dup
	pushc	24
	pushc	76
	putfa
	dup
	pushc	25
	pushc	73
	putfa
	dup
	pushc	26
	pushc	83
	putfa
	dup
	pushc	27
	pushc	80
	putfa
	dup
	pushc	28
	pushc	33
	putfa
	dup
	pushc	29
	pushc	10
	putfa
	dup
	pushc	30
	pushc	10
	putfa
	call	_writeString
	drop	1
	call	_exit
	pushg	10
	popr
	jmp	__723
__723:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } xchgpname(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; }, record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_xchgpname:
	asf	1
	pushl	-4
	getf	0
	pushg	0
	ne
	dup
	brt	__726
	drop	1
	pushl	-3
	getf	0
	pushg	0
	ne
__726:
	brf	__725
	pushg	10
	popr
	jmp	__724
__725:
	pushl	-4
	getf	4
	popl	0
	pushl	-4
	pushl	-3
	getf	4
	putf	4
	pushl	-3
	pushl	0
	putf	4
	pushg	11
	popr
	jmp	__724
__724:
	rsf
	ret

//
// record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; } purgename(record { Integer typ; Cell car; Cell cdr; Cell func; String name; Integer val; })
//
_purgename:
	asf	1
	pushl	-3
	getf	0
	pushg	0
	ne
	brf	__728
	pushg	10
	popr
	jmp	__727
__728:
	pushg	8
	popl	0
	pushl	0
	getf	0
	pushg	2
	eq
	brf	__729
	pushl	0
	getf	1
	pushl	-3
	refeq
	brf	__730
	pushl	0
	getf	2
	popg	8
	pushg	11
	popr
	jmp	__727
__730:
	jmp	__732
__731:
	pushl	0
	getf	2
	getf	1
	pushl	-3
	refeq
	brf	__734
	pushl	0
	pushl	0
	getf	2
	getf	2
	putf	2
	pushg	11
	popr
	jmp	__727
__734:
	pushl	0
	getf	2
	popl	0
__732:
	pushl	0
	getf	2
	getf	0
	pushg	2
	eq
	brt	__731
__733:
__729:
	pushg	10
	popr
	jmp	__727
__727:
	rsf
	ret

//
// void initConstants()
//
_initConstants:
	asf	0
	pushc	0
	popg	0
	pushc	1
	popg	1
	pushc	2
	popg	2
__735:
	rsf
	ret

//
// void initCharTypes()
//
_initCharTypes:
	asf	1
	pushc	128
	newa
	popg	3
	pushc	128
	newa
	popg	4
	pushc	128
	newa
	popg	5
	pushc	128
	newa
	popg	6
	pushc	128
	newa
	popg	7
	pushc	0
	popl	0
	jmp	__738
__737:
	pushg	3
	pushl	0
	pushc	0
	putfa
	pushg	4
	pushl	0
	pushc	0
	putfa
	pushg	5
	pushl	0
	pushc	0
	putfa
	pushg	6
	pushl	0
	pushc	0
	putfa
	pushg	7
	pushl	0
	pushc	0
	putfa
	pushl	0
	pushc	1
	add
	popl	0
__738:
	pushl	0
	pushc	128
	lt
	brt	__737
__739:
	pushg	3
	pushc	32
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	3
	pushc	13
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	3
	pushc	10
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	3
	pushc	9
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	33
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	36
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	38
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	39
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	40
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	41
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	42
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	43
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	44
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	45
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	46
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	47
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	64
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	58
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	59
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	60
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	61
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	62
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	63
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	91
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	92
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	93
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	94
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	95
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	96
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	123
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	124
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	125
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	4
	pushc	126
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	5
	pushc	32
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	5
	pushc	44
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	5
	pushc	13
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	5
	pushc	10
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	5
	pushc	9
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	6
	pushc	40
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	6
	pushc	41
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	6
	pushc	46
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	6
	pushc	91
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	6
	pushc	93
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	7
	pushc	34
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
	pushg	7
	pushc	37
	call	_char2int
	drop	1
	pushr
	pushc	1
	putfa
__736:
	rsf
	ret

//
// void initObjects()
//
_initObjects:
	asf	0
	call	_makeNil
	pushr
	popg	10
	pushg	10
	popg	8
	pushg	10
	call	_addOblist
	drop	1
	pushg	10
	popg	9
	pushc	1
	newa
	dup
	pushc	0
	pushc	84
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	11
	pushc	4
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	66
	putfa
	dup
	pushc	3
	pushc	82
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	12
	pushc	5
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	83
	putfa
	dup
	pushc	2
	pushc	85
	putfa
	dup
	pushc	3
	pushc	66
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	13
	pushc	6
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	66
	putfa
	dup
	pushc	4
	pushc	68
	putfa
	dup
	pushc	5
	pushc	65
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	14
	pushc	7
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	76
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	77
	putfa
	dup
	pushc	4
	pushc	66
	putfa
	dup
	pushc	5
	pushc	68
	putfa
	dup
	pushc	6
	pushc	65
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	15
	pushc	4
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	67
	putfa
	dup
	pushc	2
	pushc	72
	putfa
	dup
	pushc	3
	pushc	79
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	83
	pushc	4
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	12
	pushc	64
	call	_makeBuiltin
	drop	3
	pushr
	popg	81
	pushc	5
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	dup
	pushc	3
	pushc	79
	putfa
	dup
	pushc	4
	pushc	77
	putfa
	pushg	12
	pushc	63
	call	_makeBuiltin
	drop	3
	pushr
	popg	80
	pushc	6
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	dup
	pushc	5
	pushc	72
	putfa
	pushg	12
	pushc	65
	call	_makeBuiltin
	drop	3
	pushr
	popg	82
	pushc	3
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	pushg	12
	pushc	62
	call	_makeBuiltin
	drop	3
	pushr
	popg	79
	pushc	5
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	73
	putfa
	dup
	pushc	3
	pushc	78
	putfa
	dup
	pushc	4
	pushc	84
	putfa
	pushg	12
	pushc	67
	call	_makeBuiltin
	drop	3
	pushr
	popg	85
	pushc	5
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	73
	putfa
	dup
	pushc	3
	pushc	78
	putfa
	dup
	pushc	4
	pushc	49
	putfa
	pushg	12
	pushc	68
	call	_makeBuiltin
	drop	3
	pushr
	popg	86
	pushc	3
	newa
	dup
	pushc	0
	pushc	87
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	pushg	12
	pushc	66
	call	_makeBuiltin
	drop	3
	pushr
	popg	84
	pushc	6
	newa
	dup
	pushc	0
	pushc	68
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	73
	putfa
	dup
	pushc	3
	pushc	86
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	82
	putfa
	pushg	12
	pushc	79
	call	_makeBuiltin
	drop	3
	pushr
	popg	97
	pushc	3
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	pushg	12
	pushc	0
	call	_makeBuiltin
	drop	3
	pushr
	popg	16
	pushc	3
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	pushg	12
	pushc	1
	call	_makeBuiltin
	drop	3
	pushr
	popg	17
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	82
	putfa
	pushg	12
	pushc	3
	call	_makeBuiltin
	drop	3
	pushr
	popg	19
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	82
	putfa
	pushg	12
	pushc	5
	call	_makeBuiltin
	drop	3
	pushr
	popg	21
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	9
	call	_makeBuiltin
	drop	3
	pushr
	popg	25
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	13
	call	_makeBuiltin
	drop	3
	pushr
	popg	29
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	82
	putfa
	pushg	12
	pushc	2
	call	_makeBuiltin
	drop	3
	pushr
	popg	18
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	82
	putfa
	pushg	12
	pushc	4
	call	_makeBuiltin
	drop	3
	pushr
	popg	20
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	6
	call	_makeBuiltin
	drop	3
	pushr
	popg	22
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	10
	call	_makeBuiltin
	drop	3
	pushr
	popg	26
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	8
	call	_makeBuiltin
	drop	3
	pushr
	popg	24
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	12
	call	_makeBuiltin
	drop	3
	pushr
	popg	28
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	7
	call	_makeBuiltin
	drop	3
	pushr
	popg	23
	pushc	5
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	68
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	pushg	12
	pushc	11
	call	_makeBuiltin
	drop	3
	pushr
	popg	27
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	83
	putfa
	pushg	12
	pushc	14
	call	_makeBuiltin
	drop	3
	pushr
	popg	30
	pushc	6
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	80
	putfa
	dup
	pushc	2
	pushc	76
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	dup
	pushc	5
	pushc	65
	putfa
	pushg	12
	pushc	18
	call	_makeBuiltin
	drop	3
	pushr
	popg	34
	pushc	6
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	80
	putfa
	dup
	pushc	2
	pushc	76
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	dup
	pushc	5
	pushc	68
	putfa
	pushg	12
	pushc	19
	call	_makeBuiltin
	drop	3
	pushr
	popg	35
	pushc	5
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	67
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	78
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	pushg	12
	pushc	20
	call	_makeBuiltin
	drop	3
	pushr
	popg	36
	pushc	3
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	pushg	12
	pushc	38
	call	_makeBuiltin
	drop	3
	pushr
	popg	55
	pushc	5
	newa
	dup
	pushc	0
	pushc	65
	putfa
	dup
	pushc	1
	pushc	83
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	dup
	pushc	3
	pushc	79
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	pushg	12
	pushc	42
	call	_makeBuiltin
	drop	3
	pushr
	popg	59
	pushc	3
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	pushg	12
	pushc	44
	call	_makeBuiltin
	drop	3
	pushr
	popg	61
	pushc	3
	newa
	dup
	pushc	0
	pushc	71
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	pushg	12
	pushc	43
	call	_makeBuiltin
	drop	3
	pushr
	popg	60
	pushc	6
	newa
	dup
	pushc	0
	pushc	77
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	66
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	82
	putfa
	pushg	12
	pushc	31
	call	_makeBuiltin
	drop	3
	pushr
	popg	47
	pushc	7
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	80
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	dup
	pushc	5
	pushc	79
	putfa
	dup
	pushc	6
	pushc	80
	putfa
	pushg	12
	pushc	45
	call	_makeBuiltin
	drop	3
	pushr
	popg	62
	pushc	5
	newa
	dup
	pushc	0
	pushc	70
	putfa
	dup
	pushc	1
	pushc	76
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	80
	putfa
	pushg	12
	pushc	46
	call	_makeBuiltin
	drop	3
	pushr
	popg	63
	pushc	4
	newa
	dup
	pushc	0
	pushc	70
	putfa
	dup
	pushc	1
	pushc	76
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	pushg	12
	pushc	47
	call	_makeBuiltin
	drop	3
	pushr
	popg	64
	pushc	7
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	70
	putfa
	dup
	pushc	4
	pushc	76
	putfa
	dup
	pushc	5
	pushc	65
	putfa
	dup
	pushc	6
	pushc	71
	putfa
	pushg	12
	pushc	48
	call	_makeBuiltin
	drop	3
	pushr
	popg	65
	pushc	4
	newa
	dup
	pushc	0
	pushc	77
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	86
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	12
	pushc	51
	call	_makeBuiltin
	drop	3
	pushr
	popg	68
	pushc	4
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	12
	pushc	50
	call	_makeBuiltin
	drop	3
	pushr
	popg	67
	pushc	4
	newa
	dup
	pushc	0
	pushc	71
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	12
	pushc	49
	call	_makeBuiltin
	drop	3
	pushr
	popg	66
	pushc	4
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	67
	putfa
	dup
	pushc	3
	pushc	75
	putfa
	pushg	12
	pushc	52
	call	_makeBuiltin
	drop	3
	pushr
	popg	69
	pushc	6
	newa
	dup
	pushc	0
	pushc	85
	putfa
	dup
	pushc	1
	pushc	78
	putfa
	dup
	pushc	2
	pushc	80
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	67
	putfa
	dup
	pushc	5
	pushc	75
	putfa
	pushg	12
	pushc	53
	call	_makeBuiltin
	drop	3
	pushr
	popg	70
	pushc	6
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	84
	putfa
	dup
	pushc	5
	pushc	72
	putfa
	pushg	12
	pushc	54
	call	_makeBuiltin
	drop	3
	pushr
	popg	71
	pushc	7
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	86
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	dup
	pushc	5
	pushc	83
	putfa
	dup
	pushc	6
	pushc	69
	putfa
	pushg	12
	pushc	16
	call	_makeBuiltin
	drop	3
	pushr
	popg	32
	pushc	6
	newa
	dup
	pushc	0
	pushc	79
	putfa
	dup
	pushc	1
	pushc	66
	putfa
	dup
	pushc	2
	pushc	76
	putfa
	dup
	pushc	3
	pushc	73
	putfa
	dup
	pushc	4
	pushc	83
	putfa
	dup
	pushc	5
	pushc	84
	putfa
	pushg	12
	pushc	17
	call	_makeBuiltin
	drop	3
	pushr
	popg	33
	pushc	4
	newa
	dup
	pushc	0
	pushc	65
	putfa
	dup
	pushc	1
	pushc	84
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	77
	putfa
	pushg	12
	pushc	23
	call	_makeBuiltin
	drop	3
	pushr
	popg	39
	pushc	4
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	pushg	12
	pushc	21
	call	_makeBuiltin
	drop	3
	pushr
	popg	37
	pushc	4
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	76
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	pushg	12
	pushc	24
	call	_makeBuiltin
	drop	3
	pushr
	popg	40
	pushc	3
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	pushg	12
	pushc	35
	call	_makeBuiltin
	drop	3
	pushr
	popg	52
	pushc	6
	newa
	dup
	pushc	0
	pushc	79
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	dup
	pushc	5
	pushc	80
	putfa
	pushg	12
	pushc	34
	call	_makeBuiltin
	drop	3
	pushr
	popg	50
	pushc	7
	newa
	dup
	pushc	0
	pushc	79
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	dup
	pushc	5
	pushc	69
	putfa
	dup
	pushc	6
	pushc	68
	putfa
	call	_makeObject
	drop	1
	pushr
	popg	51
	pushc	2
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	81
	putfa
	pushg	12
	pushc	29
	call	_makeBuiltin
	drop	3
	pushr
	popg	45
	pushc	5
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	81
	putfa
	dup
	pushc	2
	pushc	85
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	76
	putfa
	pushg	12
	pushc	30
	call	_makeBuiltin
	drop	3
	pushr
	popg	46
	pushc	5
	newa
	dup
	pushc	0
	pushc	65
	putfa
	dup
	pushc	1
	pushc	80
	putfa
	dup
	pushc	2
	pushc	80
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	dup
	pushc	4
	pushc	89
	putfa
	pushg	12
	pushc	75
	call	_makeBuiltin
	drop	3
	pushr
	popg	93
	pushc	4
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	86
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	pushg	12
	pushc	74
	call	_makeBuiltin
	drop	3
	pushr
	popg	92
	pushc	7
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	67
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	dup
	pushc	4
	pushc	65
	putfa
	dup
	pushc	5
	pushc	73
	putfa
	dup
	pushc	6
	pushc	77
	putfa
	pushg	12
	pushc	80
	call	_makeBuiltin
	drop	3
	pushr
	popg	98
	pushc	6
	newa
	dup
	pushc	0
	pushc	84
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	dup
	pushc	3
	pushc	80
	putfa
	dup
	pushc	4
	pushc	82
	putfa
	dup
	pushc	5
	pushc	73
	putfa
	pushg	12
	pushc	69
	call	_makeBuiltin
	drop	3
	pushr
	popg	87
	pushc	6
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	80
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	67
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	83
	putfa
	pushg	12
	pushc	70
	call	_makeBuiltin
	drop	3
	pushr
	popg	88
	pushc	10
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	dup
	pushc	4
	pushc	76
	putfa
	dup
	pushc	5
	pushc	69
	putfa
	dup
	pushc	6
	pushc	78
	putfa
	dup
	pushc	7
	pushc	71
	putfa
	dup
	pushc	8
	pushc	84
	putfa
	dup
	pushc	9
	pushc	72
	putfa
	pushg	12
	pushc	71
	call	_makeBuiltin
	drop	3
	pushr
	popg	89
	pushc	5
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	dup
	pushc	3
	pushc	73
	putfa
	dup
	pushc	4
	pushc	88
	putfa
	pushg	12
	pushc	72
	call	_makeBuiltin
	drop	3
	pushr
	popg	90
	pushc	4
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	65
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	12
	pushc	82
	call	_makeBuiltin
	drop	3
	pushr
	popg	100
	pushc	4
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	65
	putfa
	dup
	pushc	2
	pushc	86
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	pushg	12
	pushc	81
	call	_makeBuiltin
	drop	3
	pushr
	popg	99
	pushc	6
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	89
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	dup
	pushc	3
	pushc	84
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	77
	putfa
	pushg	12
	pushc	83
	call	_makeBuiltin
	drop	3
	pushr
	popg	101
	pushc	7
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	66
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	82
	putfa
	dup
	pushc	6
	pushc	80
	putfa
	pushg	12
	pushc	22
	call	_makeBuiltin
	drop	3
	pushr
	popg	38
	pushc	8
	newa
	dup
	pushc	0
	pushc	71
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	69
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	84
	putfa
	dup
	pushc	5
	pushc	69
	putfa
	dup
	pushc	6
	pushc	82
	putfa
	dup
	pushc	7
	pushc	80
	putfa
	pushg	12
	pushc	32
	call	_makeBuiltin
	drop	3
	pushr
	popg	48
	pushc	5
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	dup
	pushc	3
	pushc	83
	putfa
	dup
	pushc	4
	pushc	80
	putfa
	pushg	12
	pushc	33
	call	_makeBuiltin
	drop	3
	pushr
	popg	49
	pushc	5
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	76
	putfa
	dup
	pushc	2
	pushc	85
	putfa
	dup
	pushc	3
	pushc	83
	putfa
	dup
	pushc	4
	pushc	80
	putfa
	pushg	12
	pushc	25
	call	_makeBuiltin
	drop	3
	pushr
	popg	41
	pushc	6
	newa
	dup
	pushc	0
	pushc	77
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	85
	putfa
	dup
	pushc	4
	pushc	83
	putfa
	dup
	pushc	5
	pushc	80
	putfa
	pushg	12
	pushc	26
	call	_makeBuiltin
	drop	3
	pushr
	popg	42
	pushc	5
	newa
	dup
	pushc	0
	pushc	90
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	dup
	pushc	3
	pushc	79
	putfa
	dup
	pushc	4
	pushc	80
	putfa
	pushg	12
	pushc	27
	call	_makeBuiltin
	drop	3
	pushr
	popg	43
	pushc	4
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	86
	putfa
	dup
	pushc	2
	pushc	69
	putfa
	dup
	pushc	3
	pushc	78
	putfa
	pushg	12
	pushc	28
	call	_makeBuiltin
	drop	3
	pushr
	popg	44
	pushc	5
	newa
	dup
	pushc	0
	pushc	77
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	85
	putfa
	dup
	pushc	4
	pushc	83
	putfa
	pushg	12
	pushc	55
	call	_makeBuiltin
	drop	3
	pushr
	popg	72
	pushc	4
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	76
	putfa
	dup
	pushc	2
	pushc	85
	putfa
	dup
	pushc	3
	pushc	83
	putfa
	pushg	12
	pushc	56
	call	_makeBuiltin
	drop	3
	pushr
	popg	73
	pushc	10
	newa
	dup
	pushc	0
	pushc	68
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	70
	putfa
	dup
	pushc	3
	pushc	70
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	82
	putfa
	dup
	pushc	6
	pushc	69
	putfa
	dup
	pushc	7
	pushc	78
	putfa
	dup
	pushc	8
	pushc	67
	putfa
	dup
	pushc	9
	pushc	69
	putfa
	pushg	12
	pushc	57
	call	_makeBuiltin
	drop	3
	pushr
	popg	74
	pushc	5
	newa
	dup
	pushc	0
	pushc	84
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	69
	putfa
	dup
	pushc	4
	pushc	83
	putfa
	pushg	12
	pushc	58
	call	_makeBuiltin
	drop	3
	pushr
	popg	75
	pushc	6
	newa
	dup
	pushc	0
	pushc	68
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	86
	putfa
	dup
	pushc	3
	pushc	73
	putfa
	dup
	pushc	4
	pushc	68
	putfa
	dup
	pushc	5
	pushc	69
	putfa
	pushg	12
	pushc	61
	call	_makeBuiltin
	drop	3
	pushr
	popg	78
	pushc	8
	newa
	dup
	pushc	0
	pushc	81
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	84
	putfa
	dup
	pushc	4
	pushc	73
	putfa
	dup
	pushc	5
	pushc	69
	putfa
	dup
	pushc	6
	pushc	78
	putfa
	dup
	pushc	7
	pushc	84
	putfa
	pushg	12
	pushc	59
	call	_makeBuiltin
	drop	3
	pushr
	popg	76
	pushc	9
	newa
	dup
	pushc	0
	pushc	82
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	77
	putfa
	dup
	pushc	3
	pushc	65
	putfa
	dup
	pushc	4
	pushc	73
	putfa
	dup
	pushc	5
	pushc	78
	putfa
	dup
	pushc	6
	pushc	68
	putfa
	dup
	pushc	7
	pushc	69
	putfa
	dup
	pushc	8
	pushc	82
	putfa
	pushg	12
	pushc	60
	call	_makeBuiltin
	drop	3
	pushr
	popg	77
	pushc	4
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	73
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	dup
	pushc	3
	pushc	84
	putfa
	pushg	13
	pushc	15
	call	_makeBuiltin
	drop	3
	pushr
	popg	31
	pushc	5
	newa
	dup
	pushc	0
	pushc	81
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	84
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	pushg	13
	pushc	73
	call	_makeBuiltin
	drop	3
	pushr
	popg	91
	pushc	4
	newa
	dup
	pushc	0
	pushc	67
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	78
	putfa
	dup
	pushc	3
	pushc	68
	putfa
	pushg	13
	pushc	76
	call	_makeBuiltin
	drop	3
	pushr
	popg	94
	pushc	4
	newa
	dup
	pushc	0
	pushc	76
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	80
	putfa
	pushg	13
	pushc	77
	call	_makeBuiltin
	drop	3
	pushr
	popg	95
	pushc	5
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	dup
	pushc	2
	pushc	79
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	49
	putfa
	pushg	13
	pushc	78
	call	_makeBuiltin
	drop	3
	pushr
	popg	96
	pushc	3
	newa
	dup
	pushc	0
	pushc	65
	putfa
	dup
	pushc	1
	pushc	78
	putfa
	dup
	pushc	2
	pushc	68
	putfa
	pushg	13
	pushc	36
	call	_makeBuiltin
	drop	3
	pushr
	popg	53
	pushc	2
	newa
	dup
	pushc	0
	pushc	79
	putfa
	dup
	pushc	1
	pushc	82
	putfa
	pushg	13
	pushc	37
	call	_makeBuiltin
	drop	3
	pushr
	popg	54
	pushc	4
	newa
	dup
	pushc	0
	pushc	83
	putfa
	dup
	pushc	1
	pushc	69
	putfa
	dup
	pushc	2
	pushc	84
	putfa
	dup
	pushc	3
	pushc	81
	putfa
	pushg	13
	pushc	39
	call	_makeBuiltin
	drop	3
	pushr
	popg	56
	pushc	3
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	79
	putfa
	dup
	pushc	2
	pushc	80
	putfa
	pushg	13
	pushc	40
	call	_makeBuiltin
	drop	3
	pushr
	popg	57
	pushc	4
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	83
	putfa
	dup
	pushc	3
	pushc	72
	putfa
	pushg	13
	pushc	41
	call	_makeBuiltin
	drop	3
	pushr
	popg	58
	pushc	9
	newa
	dup
	pushc	0
	pushc	88
	putfa
	dup
	pushc	1
	pushc	67
	putfa
	dup
	pushc	2
	pushc	72
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	80
	putfa
	dup
	pushc	5
	pushc	78
	putfa
	dup
	pushc	6
	pushc	65
	putfa
	dup
	pushc	7
	pushc	77
	putfa
	dup
	pushc	8
	pushc	69
	putfa
	pushg	12
	pushc	84
	call	_makeBuiltin
	drop	3
	pushr
	popg	102
	pushc	9
	newa
	dup
	pushc	0
	pushc	80
	putfa
	dup
	pushc	1
	pushc	85
	putfa
	dup
	pushc	2
	pushc	82
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	69
	putfa
	dup
	pushc	5
	pushc	78
	putfa
	dup
	pushc	6
	pushc	65
	putfa
	dup
	pushc	7
	pushc	77
	putfa
	dup
	pushc	8
	pushc	69
	putfa
	pushg	12
	pushc	85
	call	_makeBuiltin
	drop	3
	pushr
	popg	103
__740:
	rsf
	ret

//
// void initCtlVars()
//
_initCtlVars:
	asf	0
	pushc	0
	popg	108
	pushg	79
	pushg	10
	putf	1
	pushg	81
	pushg	81
	putf	1
	pushg	82
	pushg	82
	putf	1
	pushg	83
	pushg	10
	putf	1
	pushg	84
	pushg	10
	putf	1
	pushg	85
	pushg	85
	putf	1
	pushg	86
	pushg	86
	putf	1
	pushc	0
	popg	104
	pushc	79
	popg	105
	pushc	10
	popg	106
__741:
	rsf
	ret

//
// void main()
//
_main:
	asf	0
	pushc	24
	newa
	dup
	pushc	0
	pushc	10
	putfa
	dup
	pushc	1
	pushc	87
	putfa
	dup
	pushc	2
	pushc	101
	putfa
	dup
	pushc	3
	pushc	108
	putfa
	dup
	pushc	4
	pushc	99
	putfa
	dup
	pushc	5
	pushc	111
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	101
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	111
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	78
	putfa
	dup
	pushc	13
	pushc	105
	putfa
	dup
	pushc	14
	pushc	110
	putfa
	dup
	pushc	15
	pushc	106
	putfa
	dup
	pushc	16
	pushc	97
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	76
	putfa
	dup
	pushc	19
	pushc	73
	putfa
	dup
	pushc	20
	pushc	83
	putfa
	dup
	pushc	21
	pushc	80
	putfa
	dup
	pushc	22
	pushc	33
	putfa
	dup
	pushc	23
	pushc	10
	putfa
	call	_writeString
	drop	1
	call	_initConstants
	call	_initCharTypes
	call	_initObjects
	call	_initCtlVars
	jmp	__744
__743:
	pushg	97
	pushg	10
	call	_apply
	drop	2
__744:
	pushc	1
	brt	__743
__745:
__742:
	rsf
	ret
