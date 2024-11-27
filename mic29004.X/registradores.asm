
;start:
;    ldi R16,0x14 //opcode = 1110 0001 0000 0100
;    ldi R17,25
;    ldi R18,0b0010_0011
;    subi r19,-50
;    inc r0
;    clr r0
;       rjmp start
    
;    inc r0
;    mov r1, r0
;    inc r0
;    movw r2,r0
    
    .DEF temp=r16
    .EQU valor=0x23+5
    start:
    ldi temp, valor ; inicialize o reg. temp com valor
    inc temp ; incrementa o reg. temp
    rjmp start
    