.DSEG
.ORG SRAM_START
    V0: .BYTE 10
    V1: .BYTE 10
    VR: .BYTE 10
.CSEG

start:
    LDI XH, HIGH(V0)
    LDI XL, LOW(V0)
    
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)
    
    LDI ZH, HIGH(VR)
    LDI ZL, LOW(VR)
    
    ldi r19, 0
    ldi r20, 10
    ldi r21, 20
    rcall init_array
    
    rcall copy_array
    
    rcall reverse_array
    

    
;-------------------------------------
;        SUB-ROTINA init_array
;-------------------------------------    
init_array:
   push r19 
   push r20
   push r21
  
   clr r19
loop_init_array:
    st x+, r21
    inc r21
    inc r19
    cp r20, r19 
    brne loop_init_array
      
    pop r19
    pop r20         
    pop r21         

    ret
    
;-------------------------------------
;        SUB-ROTINA copy_array
;-------------------------------------      
copy_array:
   push r19 
   push r20
   push r21
  
   clr r19
   clr r21
   clr r26
   
loop_copy_array:
    ld r21, x+
    st y+, r21
    inc r19
    cp r19, r20
    brne loop_copy_array
       
    pop r19          
    pop r20         
    pop r21    
    
    ret

;-------------------------------------
;        SUB-ROTINA reverse_array
;-------------------------------------
reverse_array:
   push r19 
   push r20
   push r21
  
   clr r21
   st y, r26
loop_reverse_array:
    ld r21, -y
    st z+, r21
    inc r19
    cp r19, r20
    brne loop_reverse_array
    
    pop r19          
    pop r20         
    pop r21    
    
    ret

   