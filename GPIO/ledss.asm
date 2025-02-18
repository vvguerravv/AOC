.INCLUDE <m328Pdef.inc>

setup:
    ; Configura PB2 (2) e PB3 (3) como entrada
    cbi DDRB, 2  ; Bot�o SELE��O como entrada
    cbi DDRB, 3  ; Bot�o AJUSTE como entrada
    
    ; Habilita pull-up interno nos bot�es
    sbi PORTB, 2
    sbi PORTB, 3

    ; Configura todos os pinos do PORTD como sa�da (LEDs)
    ldi r16, 0xFF
    out DDRD, r16  

    ; Liga todos os LEDs no in�cio
    out PORTD, r16  

main:
    in r17, PINB  ; L� o estado dos bot�es

    sbis PINB, 2  ; Se PB2 (SELE��O) pressionado (LOW)
    rjmp apaga_MSB

    sbis PINB, 3  ; Se PB3 (AJUSTE) pressionado (LOW)
    rjmp apaga_LSB

    ; Nenhum bot�o pressionado ? Liga todos os LEDs
    ldi r16, 0xFF
    out PORTD, r16
    rjmp main

apaga_LSB:
    ; Apaga os 4 LEDs menos significativos (0b11110000)
    ldi r16, 0xF0
    out PORTD, r16
    rjmp main

apaga_MSB:
    ; Apaga os 4 LEDs mais significativos (0b00001111)
    ldi r16, 0x0F
    out PORTD, r16
    rjmp main
