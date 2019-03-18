bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 9h    ;9
	b  dw 139h  ;313
    c  dd 3E8h  ;1000
    d  dq 24Eh  ;590
    ;(c-d-a)+(b+b)-(c+a)  / (1000-590-9)+(313+313)-(1000+9)= 401 + 626 - 1009 = 18 = 0012h
segment  code use32 class=code ; code segment
start: 
mov EDX,0h              ;EDX = 0000 0000
mov EAX,[c]             ;EAX = 0000 03E8
mov ECX,dword [d]       ;ECX = 0000 024E   
mov EBX,dword [d+4]     ;EBX = 0000 0000
sub EAX,ECX             ;EAX = 0000 019A
sbb EDX,EBX             ;EDX = 0000 0000   / EDX:EAX = c-d 
clc                     ;just to make sure
mov ECX,0h              ;ECX = 0000 0000
mov CL,[a]              ;ECX = 0000 0009
sub EAX,ECX             ;EAX = 0000 0191   / EDX:EAX = c-d-a
jnc here                ;We take away any remaining borrow 
dec EDX
here:
clc
mov ECX,0h              ;ECX = 0000 0000
mov EBX,0h              ;EBX = 0000 0000
mov CX,[b]              ;ECX = 0000 0139
add CX,[b]              ;ECX = 0000 0272  / ECX = b+b
jnc here2               ;We add any remaining carry
inc EBX
here2:
clc                     ;After all this EBX:ECX = b+b
add EAX,ECX             ;EAX = 0000 0403
adc EDX,EBX             ;EDX = 0000 0000  / EDX:EAX = (c-d-a)+(b+b)
mov ECX,[c]             ;ECX = 0000 03E8
mov EBX,0h              ;EBX = 0000 0000
mov BL,[a]              ;EBX = 0000 0009
add ECX,EBX             ;ECX = 0000 03F1  / ECX = c+a
mov EBX,0h              ;EBX = 0000 0000
jnc here3               ;We add any remaining carry
inc EBX                 
here3:
clc                     ;After all this EBX:ECX = c+a
sub EAX,ECX             ;EAX = 0000 0012 
sbb EDX,EBX             ;EDX = 0000 0000
                        ;Our result is given by EDX:EAX which holds (c-d-a) + (b+b) - (c+a)
