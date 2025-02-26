; QUESTÃO 2 - INTERRUPÇÃO
 
 .EQU MAIS  = PD2
 .EQU MENOS = PD3
 .def AUX = R18
 
 .DSEG
 .ORG SRAM_START
    V0: .BYTE 1
 .CSEG
 
 ; ------------------------------
; VETORES DE INTERRUPÇÃO
; ------------------------------
.ORG 0x0000         ; Vetor de Reset
  RJMP setup       

.ORG 0x0002         ; Vetor da INT0 (Botão ON)
  RJMP isr_Mais
  
.ORG 0x0004         ; Vetor da INT1 (Botão OFF)
  RJMP isr_Menos

; ==============================================================
;                           CONFIGURAÇÃO
; ==============================================================
.ORG 0x0034         ; Primeira posição livre após os vetores
  
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
    
    ldi AUX, 0b00001010  ; Configura interrupções externas
    sts EICRA, AUX       ; INT0 sensível a borda de descida
    sbi EIMSK, INT0      ; Habilita INT0
    sbi EIMSK, INT1      ; Habilita INT1
  
    sei
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
    cpi r26, 8
    brne main
    ldi r26, 0
    rjmp main


    
   
    ; ==============================================================
;                   ROTINA DE INTERRUPÇÃO - BOTÃO ON
; ==============================================================
  isr_Mais:
  push R16        ; Salva contexto (SREG)
  in R16, SREG
  push R16
  
 iniciaMaisPress:
    sbi PORTD, PD3
    ldi r26, 0
 maisPress:
    ld r17, X+
    out PORTB, r17
    ;rcall delay
    cpi r26, 8
    brne maisPress
    ldi r26, 0
    sbi PORTD, PD2
    sbis PORTD, PD3
    rjmp main
    rjmp maisPress

  pop R16         ; Restaura contexto (SREG)
  out SREG, R16
  pop R16
  reti            ; Retorna da interrupção

; ==============================================================
;                   ROTINA DE INTERRUPÇÃO - BOTÃO OFF
; ==============================================================
isr_Menos:
  push R16        ; Salva contexto (SREG)
  in R16, SREG
  push R16
  
   iniciaMenosPress:   
    sbi PORTD, PD2
    ldi r26, 8
 menosPress:   
    ld r17, -X
    out PORTB, r17
    ;rcall delay
    cpi r26, 0
    brne menosPress
    ldi r26, 8
    sbi PORTD, PD3
    sbis PORTD, PD2
    rjmp maisPress 
    rjmp menosPress
      pop R16         ; Restaura contexto (SREG)
  out SREG, R16
  pop R16
  reti      

      ; Retorna da interrupção
  
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