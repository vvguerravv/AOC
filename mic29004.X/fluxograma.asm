.include "m328Pdef.inc"

; Definição dos bits
.equ LED     = 0    ; Bit 0 do GPIOR0 representa o LED
.equ BUTTON  = 1    ; Bit 1 do GPIOR0 representa o botão

; Configuração inicial
.org 0x00
    rjmp main  ; Pula para o início do programa

main:
    ldi r16, 0x00  ; Limpa o registrador
    out GPIOR0, r16  ; Garante que o LED está apagado inicialmente

loop:
    sbis GPIOR0, BUTTON  ; Verifica se o botão está pressionado
    rjmp apagar_led      ; Se não estiver pressionado, apaga o LED

    ; Se o botão estiver pressionado, pisca o LED a cada 1s
    sbi GPIOR0, LED      ; Liga o LED
    call atraso_1s       ; Aguarda 1s
    cbi GPIOR0, LED      ; Desliga o LED
    call atraso_1s       ; Aguarda 1s
    rjmp loop            ; Repete o processo

apagar_led:
    cbi GPIOR0, LED      ; Garante que o LED está apagado
    rjmp loop            ; Volta para verificar o botão

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



