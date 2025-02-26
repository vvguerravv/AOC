.INCLUDE <m328Pdef.inc>

.def temp = r16
.def led_ptr = r17
.def direction = r18

.equ LED_PORT = PORTB
.equ LED_DDR = DDRB
.equ BUTTON_PIN = PIND
.equ BUTTON_PLUS = PD2
.equ BUTTON_MINUS = PD3

.cseg
.org 0x0000
rjmp start
.org INT0addr
rjmp int0_isr
.org INT1addr
rjmp int1_isr

start:
ldi temp, 0xFF
out LED_DDR, temp ; Configura todos os pinos de PORTB como saída
ldi temp, 0xFF
out LED_PORT, temp ; Inicializa todos os LEDs acesos

ldi led_ptr, 0x01 ; Inicializa o ponteiro do LED
ldi direction, 0x00 ; Inicializa a direção (0 = mais significativo)

; Configura interrupções externas
ldi temp, (1 << ISC01) | (1 << ISC11) ; Configura INT0 e INT1 para borda de descida
sts EICRA, temp
ldi temp, (1 << INT0) | (1 << INT1) ; Habilita INT0 e INT1
out EIMSK, temp
sei ; Habilita interrupções globais

main_loop:
mov temp, led_ptr ; Copia o valor do ponteiro para um registrador temporário
com temp ; Inverte o valor (complemento de um)
out LED_PORT, temp ; Atualiza o PORTB com o valor invertido

;rcall delay ; Aguarda 200ms

cpi direction, 0x00
breq increment
rjmp decrement

increment:
lsl led_ptr ; Desloca para o próximo LED (mais significativo)
brne main_loop ; Se não for zero, continua
ldi led_ptr, 0x01 ; Se for zero, reinicia
rjmp main_loop

decrement:
lsr led_ptr ; Desloca para o próximo LED (menos significativo)
brne main_loop ; Se não for zero, continua
ldi led_ptr, 0x80 ; Se for zero, reinicia
rjmp main_loop

int0_isr:
ldi direction, 0x00 ; Define direção para mais significativo
reti

int1_isr:
ldi direction, 0x01 ; Define direção para menos significativo
reti

;--------------------------------------------------------------
;SUB-ROTINA DE ATRASO Programável 
; Depende do valor de R19 carregado antes da chamada.
; Ex.: - R19 = 16 --> 200ms 
;      - R19 = 80 --> 1s
;--------------------------------------------------------------
delay:           
  push r17	      ; Salva os valores de r17,
  push r18	      ; ... r18,
  in r17,SREG     ; ...
  push r17        ; ... e SREG na pilha.

  ; Executa sub-rotina :
  clr r17
  clr r18
loop:            
  dec  R17        ;decrementa R17, começa com 0x00
  brne loop       ;enquanto R17 > 0 fica decrementando R17
  dec  R18        ;decrementa R18, começa com 0x00
  brne loop       ;enquanto R18 > 0 volta decrementar R18
  dec  R19        ;decrementa R19
  brne loop       ;enquanto R19 > 0 vai para volta

  pop r17          
  out SREG, r17   ; Restaura os valores de SREG,
  pop r18         ; ... r18
  pop r17         ; ... r17 da pilha

  ret
    
 