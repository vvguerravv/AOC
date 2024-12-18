.DSEG
.ORG SRAM_START
    A: .BYTE 4
    B: .BYTE 4
    C: .BYTE 4
.CSEG
    
main:
    
    rcall start
    
start:
    
    LDI XH, HIGH(A)
    LDI XL, LOW(A)
    
    LDI YH, HIGH(B)
    LDI YL, LOW(B)
    
    LDI ZH, HIGH(C)
    LDI ZL, LOW(C)
    
    push r17
    push r18
    push r19
    
    
soma_loop:
    
    LD R17,X+
    LD R18,Y+
    ADD R17,R18
    ST Z+,R17
    
    pop r17
    pop  r18
    pop r19
    
    ret