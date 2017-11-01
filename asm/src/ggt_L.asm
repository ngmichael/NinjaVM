//
// prog2.asm -- an assembler example with local variables
//

//
// compute the gcd of two positive numbers
//
// local Integer x;
// local Integer y;
// x = readInteger();
// y = readInteger();
// while (x != y) {
//   if (x > y) {
//     x = x - y;
//   } else {
//     y = y - x;
//   }
// }
// writeInteger(x);
// writeCharacter('\n');

	asf	2
	// x = readInteger();
	rdint
	popl	0
	// y = readInteger();
	rdint
	popl	1
	// while ...
L1:
	// x != y
	pushl	0
	pushl	1
	ne
	brf	L2
	// if ...
	pushl	0
	pushl	1
	gt
	brf	L3
	// x = x - y
	pushl	0
	pushl	1
	sub
	popl	0
	jmp	L4
L3:
	// y = y - x
	pushl	1
	pushl	0
	sub
	popl	1
L4:
	jmp	L1
L2:
	// writeInteger(x);
	pushl	0
	wrint
	// writeCharacter('\n');
	pushc	'\n'
	wrchr
	rsf
	halt
    