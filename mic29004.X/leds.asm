.INCLUDE <m328Pdef.inc>

    setup:
    cbi DDRB, PB2 ;configura o pino PB2 como entrada, que será usado para ser o botão seleção
    cbi DDRB, PB3; configra o pino PB3 como entrada, que será usado para ser o botão de ajuste
    
    ldi r16,0xff ; carrego r16 com 11111111
    out DDRD,R16 ; configura todos os pinos do PORTD como saídas
     
    main:
    in r17, PINB 
    sbic r17,PB2 ;Verifica se PB2 está pressionado
    rjmp apaga_MSB
    
    in r17, PINB
    sbic r17,PB3 ;Verifica se PB3 estpa pressionado
    rjmp apaga_LSB
    
    ldi r16,0xff
    out PORTB,r16
    rjmp main
    
    apaga_LSB:
    ; Apaga os 4 LEDs menos significativos (0b11110000)
    ldi r16, 0xF0
    out PORTB, r16
    rjmp main_loop
    
    apaga_MSB:
    ; Apaga os 4 LEDs mais significativos (0b00001111)
    ldi r16, 0x0F
    out PORTB, r16
    rjmp main_loop