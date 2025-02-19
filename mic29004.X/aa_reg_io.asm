
    .EQU BOTAO = 3
    .EQU LED1 = 7
    .DEF COUNT = R17


start:
    ;SETUP
    
    
wait_press:
    sbis GPIOR0, BOTAO
    rjmp wait_press
    
    clr COUNT  ; LDI R17,0
    
pisca_led:
    
    sbi GPIOR0, LED1
    LDI R19,40
    CALL delay
    
    cbi GPIOR0,LED1
    LDI R19,40
    call delay
    
    inc COUNT
    cpi COUNT,5
    BRNE pisca_led1
    
    rjmp wait_press
    
    
    ; ==============================================================
;                 SUB-ROTINA DE ATRASO PROGRAMÁVEL
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
