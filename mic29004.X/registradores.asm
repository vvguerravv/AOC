
start:
    ldi R16,0x14 //opcode = 1110 0001 0000 0100
    ldi R17,25
    ldi R18,0b0010_0011
    subi r19,-50
    inc r0
    clr r0
    rjmp start