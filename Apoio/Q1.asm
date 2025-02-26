; QUESTÃO 01 - GIPIO	
 .EQU MAIS  = PD2
 .EQU MENOS = PD3
 
 .DSEG
 .ORG SRAM_START
    V0: .BYTE 1
 .CSEG
 
 setup:
    ; CONFIGURAÇÃO DOS BOTÕES
    cbi DDRD , MAIS  ; botão +
    cbi DDRD , MENOS ; botão -
    sbi PORTD, PD2   ; pull up
    sbi PORTD, PD3   ; pull-up
    
    ; CONFIGURAÇÃO DOS LEDS
    out DDRB, r17
    
    ; CONFIGURAÇÃO DO PONTEIRO
    ldi XH, HIGH(V0)
    ldi XL, LOW(V0)
    
 carregaVetor:    
    ldi r16, 0b1111_1110
    st X+, r16
    ldi r16, 0b1111_1101
    st X+, r16
    ldi r16, 0b1111_1011
    st X+, r16
    ldi r16, 0b1111_0111
    st X+, r16
    ldi r16, 0b1110_1111
    st X+, r16
    ldi r16, 0b1101_1111
    st X+, r16
    ldi r16, 0b1011_1111
    st X+, r16
    ldi r16, 0b0111_1111
    st X+, r16
    ldi r26, 0
    
 main:
    ld r17, X+
    out PORTB, r17
    ;rcall delay
    sbis PORTD, PD2
    rjmp iniciaMaisPress
    sbis PORTD, PD3
    rjmp iniciaMenosPress
    cpi r26, 8
    brne main
    ldi r26, 0
    rjmp main

 iniciaMaisPress:
    ldi r26, 0
 maisPress:
    ld r17, X+
    out PORTB, r17
    ;rcall delay
    sbis PORTD, PD3
    rjmp menosPress
    cpi r26, 8
    brne maisPress
    ldi r26, 0
    rjmp maisPress
    
 iniciaMenosPress:   
    ldi r26, 8
    sbi PORTD, PD3
 menosPress:   
    ld r17, -X
    out PORTB, r17
    ;rcall delay
    sbis PORTD, PD2
    rjmp iniciaMaisPress
    cpi r26, 0
    brne menosPress
    ldi r26, 8
    rjmp menosPress
    
delay:           
  push r17	     ; Salva os valores de r17,
  push r18	     ; ... r18,
  in r17,SREG    ; ...
  push r17       ; ... e SREG na pilha.

  ; Executa sub-rotina :
  clr r17
  clr r18
loop:            
  dec  R17       ;decrementa R17, começa com 0x00
  brne loop      ;enquanto R17 > 0 fica decrementando R17
  dec  R18       ;decrementa R18, começa com 0x00
  brne loop      ;enquanto R18 > 0 volta decrementar R18
  dec  R19       ;decrementa R19
  brne loop      ;enquanto R19 > 0 vai para volta

  pop r17         
  out SREG, r17  ; Restaura os valores de SREG,
  pop r18        ; ... r18
  pop r17        ; ... r17 da pilha

  ret    