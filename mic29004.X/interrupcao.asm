; ==============================================================
;               CONTROLE DE BOT�O COM PULL-UP (PORTD)
; ==============================================================
; -> Para ligar e desligar o bot�o, � necess�rio ativar/desativar o pull-up.

; ------------------------------
; DEFINI��ES
; ------------------------------
.equ ON  = PD2   ; Bot�o ON
.equ OFF = PD3   ; Bot�o OFF
.equ L0  = PB0   ; LED 0
.equ L1  = PB1   ; LED 1
.def AUX = R16   ; Registrador auxiliar

; ------------------------------
; VETORES DE INTERRUP��O
; ------------------------------
.ORG 0x0000         ; Vetor de Reset
  RJMP setup       

.ORG 0x0002         ; Vetor da INT0 (Bot�o ON)
  RJMP isr_on
  
.ORG 0x0004         ; Vetor da INT1 (Bot�o OFF)
  RJMP isr_off

; ==============================================================
;                           CONFIGURA��O
; ==============================================================
.ORG 0x0034         ; Primeira posi��o livre ap�s os vetores
setup:
  ldi AUX, 0x03     ; Configura PB3/2 como sa�da (0b00000011)
  out DDRB, AUX     
  out PORTB, AUX    ; Desliga os LEDs
  cbi DDRD, ON      ; Configura PD2 como entrada
  sbi PORTD, ON     ; Ativa pull-up no PD2
  cbi DDRD, OFF     ; Configura PD3 como entrada
  sbi PORTD, OFF    ; Ativa pull-up no PD3
  
  ldi AUX, 0b00001010  ; Configura interrup��es externas
  sts EICRA, AUX       ; INT0 sens�vel a borda de descida
  sbi EIMSK, INT0      ; Habilita INT0
  sbi EIMSK, INT1      ; Habilita INT1
                    
  sei                 ; Habilita interrup��es globais (bit I do SREG)

; ==============================================================
;                            LOOP PRINCIPAL
; ==============================================================
main:
  sbi PORTB, L0   ; Desliga LED L0
  ldi r19, 80     
  rcall delay 
  cbi PORTB, L0   ; Liga LED L0
  ldi r19, 80     
  rcall delay
  rjmp main

; ==============================================================
;                   ROTINA DE INTERRUP��O - BOT�O ON
; ==============================================================
isr_on:
  push R16        ; Salva contexto (SREG)
  in R16, SREG
  push R16
  
  cbi PORTB, L1   ; Liga LED L1

  pop R16         ; Restaura contexto (SREG)
  out SREG, R16
  pop R16
  reti            ; Retorna da interrup��o

; ==============================================================
;                   ROTINA DE INTERRUP��O - BOT�O OFF
; ==============================================================
isr_off:
  push R16        ; Salva contexto (SREG)
  in R16, SREG
  push R16
  
  sbi PORTB, L1   ; Desliga LED L1

  pop R16         ; Restaura contexto (SREG)
  out SREG, R16
  pop R16
  reti            ; Retorna da interrup��o

; ==============================================================
;                 SUB-ROTINA DE ATRASO PROGRAM�VEL
; ==============================================================
; -> Depende do valor de R19 carregado antes da chamada.
;    Exemplos:
;    - R19 = 16  --> 200ms
;    - R19 = 80  --> 1s
; --------------------------------------------------------------
delay:           
  push r17        ; Salva valores de r17,
  push r18        ; ... r18,
  in r17, SREG    ; ... e SREG na pilha.
  push r17       

  clr r17
  clr r18
loop:            
  dec  R17       ; Decrementa R17
  brne loop      ; Continua enquanto R17 > 0
  dec  R18       ; Decrementa R18
  brne loop      ; Continua enquanto R18 > 0
  dec  R19       ; Decrementa R19
  brne loop      ; Continua enquanto R19 > 0

  pop r17         
  out SREG, r17  ; Restaura valores de SREG,
  pop r18        ; ... r18,
  pop r17        ; ... r17 da pilha

  ret            ; Retorna da sub-rotina
