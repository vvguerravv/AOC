


.INCLUDE <m328Pdef.inc>

 start:
 ; Exemplo in/out
 inc R0
 out GPIOR0, R0
 in R1, GPIOR0

 ; Exemplo sbi/cbi
 sbi DDRB, 5
 cbi DDRB, 5

 ; Exemplo sbis/sbic
 waitUM:
 sbis PIND,7
 rjmp waitUM
 waitZERO:
 sbic PIND,7
 rjmp waitZERO
 nop

 rjmp start