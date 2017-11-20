        jmp __main
__ack:  
        asf 0
        pushl -4
        pushc 0
        eq
        brf __0
        pushl -3
        pushc 1
        add
        popr
        rsf
        ret
__0:    
        pushl -3
        pushc 0
        eq
        brf __1
        pushl -4
        pushc 1
        sub
        pushc 1
        call __ack
        rsf
        ret
__1:    
        pushl -4
        pushl -3
        pushc 1
        sub
        call __ack
        pushl -4
        pushc 1
        sub
        pushr
        call __ack
        rsf
        ret
__main: 
        asf 2
        rdint
        popl 0
        rdint
        popl 1
        call __ack
        pushr
        wrint
        pushc 10
        wrchr
        halt
