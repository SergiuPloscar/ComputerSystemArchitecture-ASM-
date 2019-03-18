bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 9     ; 0009h
	b  dw 43    ; 002Bh
    c  dd -215  ; FF29h
    d  dq -307  ; FECDh
    ;(c-d-a)+(b+b)-(c+a)  / (-215- -307 -9)+(43+43)-(-215+9)= 83 + 86 - -206  = 375 = 0177h
segment  code use32 class=code ; code segment
start: 
mov EAX,[c]             ; EAX = FFFF FF29
cdq                     ; EDX = FFFF FFFF   EAX = FFFF FF29
mov ECX,dword [d]       ; ECX = FFFF FECD 
mov EBX,dword [d+4]     ; EBX = FFFF FFFF
sub EAX,ECX             ; EAX = 0000 005C
sbb EDX,EBX             ; EDX = 0000 0000   EDX:EAX = c-d                 
mov ECX,EAX             ; ECX = 0000 005C
mov EBX,EDX             ; EBX = 0000 0000   EBX:ECX = c-d
mov AL,[a]              ; EAX = 0000 0009
cbw                     ; EAX = 0000 0009
cwde                    ; EAX = 0000 0009
cdq                     ; EDX = 0000 0000   EAX = 0000 0009
sub ECX,EAX             ; ECX = 0000 0053
sbb EBX,EDX             ; EBX = 0000 0000   EBX:ECX = c-d-a
mov AX,[b]              ; EAX = 0000 002B
add AX,[b]              ; EAX = 0000 0056   EAX = b+b
cwde                    ; EAX = 0000 0000
cdq                     ; EDX = 0000 0000   EAX = 0000 0056    EDX:EAX = b+b
adc ECX,EAX             ; ECX = 0000 00A9
adc EBX,EDX             ; EBX = 0000 0000   EBX:ECX = (c-d-a) + (b+b)
mov AL,[a]              ; EAX = 0000 0009
cbw                     ; EAX = 0000 0009
cwde                    ; EAX = 0000 0009
add EAX,[c]             ; EAX = FFFF FF32
cdq                     ; EDX = FFFF FFFF   EAX = FFFF FF32     EDX:EAX = c+a
sbb ECX,EAX             ; ECX = 0000 0177
sbb EBX,EDX             ; EBX = 0000 0000
;Our result is given by EBX:ECX which holds (c-d-a) + (b+b) - (c+a)
