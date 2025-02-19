.INCLUDE <m328Pdef.inc>

    
    .EQU AJU = PB0
    .EQU SEL = PB1
    
   setup:
    LDI R16,0xFF
    OUT DDRD, R16
    
    ; Configura os pinos dos botões como entrada
    
    CBI DDRB, AJU
    CBI DDRB, SEL
    
    ; ... ativar o pull up
    
    SBI PORTB,AJU
    SBI PORTB,SEL
    
   main:
    
    sbic PINB, AJU
    RJMP aju_npress
    
  aju_press:
    sbi PORTD,PD0
    sbi PORTD,PD1
    sbi PORTD,PD2
    sbi PORTD,PD3
    
    rjmp aju_fim
    
  aju_npress:
    
    cbi PORTD,PD0
    cbi PORTD,PD1
    cbi PORTD,PD2
    cbi PORTD,PD3
    
  aju_fim:
    sbic PINB,SEL
    rjmp sel_npress
    
  sel_press:
    sbi PORTD,PD4
    sbi PORTD,PD5
    sbi PORTD,PD6
    sbi PORTD,PD7
    
    rjmp sel_fim
    
  sel_npress:
    
    cbi PORTD,PD4
    cbi PORTD,PD5
    cbi PORTD,PD6
    cbi PORTD,PD7
    
  sel_fim:
    
    rjmp start
    