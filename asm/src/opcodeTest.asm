    jmp __main

__calltest:

    pushc 10
    wrint
    ret

__main:
//pushc test
    pushc 10

//add test
    pushc 10
    add

//sub test
    pushc 10
    sub

//mul test
    pushc 10
    mul

//div test
    pushc 2
    div

//mod test
    pushc 5
    mod

//rdint test
    rdint

//wrint test
    wrint

//rdchr test
    rdchr

//wrchr test
    wrchr

    popg 0
    pushg 0

//test for asf, rsf, pushl & popl

    pushc 10
    asf 1
    popl 0
    pushl 0
    rsf

    asf 2
    pushc 10
    pushc 20
    popl 0
    popl 1

//eq test
    pushl 0
    pushl 1
    eq

//ne test
    pushl 0
    pushl 1
    ne

//gt test
    pushl 0
    pushl 1
    gt

//ge test
    pushl 0
    pushl 1
    ge

//lt test
    pushl 0
    pushl 1
    lt

//le test
    pushl 0
    pushl 1
    le

    rsf

// brt test
    pushc 1
    brt __testofbrt
    halt
__testofbrt:

    // brf test
    pushc 0
    brf __testbrf
    halt
__testbrf:

    call __calltest

    pushc 10
    pushc 20
    drop 2

    pushc 10

    popr

    pushr

    dup

    halt
