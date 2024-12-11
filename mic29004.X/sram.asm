.DSEG
.ORG SRAM_START
    A: .BYTE 2
    B: .BYTE 2
    C: .BYTE 2
 
.CSEG
 
 start:
    
    LDS r0, A
    LDS r1, A+1
    
    LDS r2,B
    LDS r3,B+1
    
    ADD r0,r2
    ADC r1,r3
    
    sts C,r0
    sts C+1,r1
    
    rjmp start
    
    
    
;    LDS r0,A
;    LDS r1,B
;    add r0,r1
;    sts C,r0
    
    