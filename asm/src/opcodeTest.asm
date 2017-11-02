
asf 2
pushc 20
pushc 21 
popl 1
popl 0

// How the stack should look after:
// 8: 0
// 7: 1
// 6: 0
// 5: 0
// 4: 1
// 3: 0
// 2: 21
// 1: 20
// 0: 0

// eq test
pushl 0
pushl 1
eq

// ne test
pushl 0
pushl 1
ne

// gt test
pushl 0
pushl 1
gt

// ge test
pushl 0
pushl 1
ge

// lt test
pushl 0
pushl 1
lt

// le test
pushl 0
pushl 1
le

halt
