.INCLUDE <m328Pdef.inc>
.DSEG
.ORG SRAM_START
    V0: .BYTE 10
    V1: .BYTE 10
    VR: .BYTE 10
.CSEG

start:
    ldi xl, low(v0)
    ldi xh, high(v0)
    ldi r20, low(v1); Tamanho do vetor
    ldi r21, 20 ; Valor inicial
    rcall init_array
    
    ldi xl, low(v0)
    ldi xh, high(v0)
    ldi yl, low(v1)
    ldi yh, high(v1)
    rcall copy_array
    
    ldi xl, low(v1)
    ldi xh, high(v1)
    ldi yl, low(vr+10)
    ldi yh, high(vr+10)
    rcall reverse_array
    
    rjmp start

; Inicializa um vetor de bytes de tamanho arbitrário com valores sequenciais.
; Parâmetros:
; Registrador X: Ponteiro para a posição inicial do vetor.
;
; R20 : Tamanho do vetor. Intervalo [0, 255].
; R21 : Valor inicial. Intervalo [0, 255]

init_array:
    st x+, r21
    inc r21
    cpi r21, 30
    brne init_array
    ret

; Copia os dados de um vetor para outro.
; Parâmetros:
; Registrador X : Ponteiro para a posição inicial do vetor origem.
; Registrador Y : Ponteiro para a posição inicial do vetor destino.
;
; R20 : Tamanho dos vetores. Intervalo [0, 255].

copy_array:
    push r16 ; Salva o contexto
    in r1, SREG
    push r1
    push r17
    
    ldi r16, 0
    rcall copy_loop
    
    pop r1 ; Restaura contexto
    out SREG, r1
    pop r16
    pop r17
    
    ret

copy_loop:
    ld r17, x+
    st y+, r17
    inc r16
    cp r16, r20
    brne copy_loop
    ret

; Copia os dados de um vetor para outro de forma reversa.
; Parâmetros:
; Registrador X : Ponteiro para a posição inicial do vetor origem.
; Registrador Y : Ponteiro para a última posição do vetor destino.
; R20 : Tamanho dos vetores. Intervalo [0, 255].

reverse_array:
    push r16 ; Salva o contexto
    in r1, SREG
    push r1
    push r17
    
    ldi r16, 0
    rcall copy_reverse_loop
    
    pop r1 ; Restaura contexto
    out SREG, r1
    pop r16
    pop r17
    
    ret

copy_reverse_loop:
    ld r17, x+
    st -y, r17
    inc r16
    cp r16, r20
    brne copy_reverse_loop
    ret