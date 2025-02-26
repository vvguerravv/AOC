.include "m328Pdef.inc"

; Defini��o dos bits
.equ LED     = 0    ; Bit 0 do GPIOR0 representa o LED
.equ BUTTON  = 1    ; Bit 1 do GPIOR0 representa o bot�o

; Configura��o inicial
.org 0x00
    rjmp main  ; Pula para o in�cio do programa

main:
    ldi r16, 0x00  ; Limpa o registrador
    out GPIOR0, r16  ; Garante que o LED est� apagado inicialmente

loop:
    sbis GPIOR0, BUTTON  ; Verifica se o bot�o est� pressionado
    rjmp apagar_led      ; Se n�o estiver pressionado, apaga o LED

    ; Se o bot�o estiver pressionado, pisca o LED a cada 1s
    sbi GPIOR0, LED      ; Liga o LED
    call atraso_1s       ; Aguarda 1s
    cbi GPIOR0, LED      ; Desliga o LED
    call atraso_1s       ; Aguarda 1s
    rjmp loop            ; Repete o processo

apagar_led:
    cbi GPIOR0, LED      ; Garante que o LED est� apagado
    rjmp loop            ; Volta para verificar o bot�o

; Rotina de atraso de aproximadamente 1 segundo
atraso_1s:
    ldi r17, 100         ; Loop externo (ajustar para atingir 1s)
    outer_loop:
        ldi r18, 255     ; Loop interno
        inner_loop:
            nop
            dec r18
            brne inner_loop
        dec r17
        brne outer_loop
    ret



