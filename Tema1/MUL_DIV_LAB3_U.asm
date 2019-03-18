bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  dw 10   ; Ah
	b  db 20   ; 14h
    c  dw 2    ; 2h
    d  dd 314  ; 13Ah
    x  dq 264  ; 108h
    ;(a*a+b/c-1)/(b+c)+d-x /  (10*10+20/2-1)/(20+2)+314-264 = (100+10-1)/(22) + 50 = 109/22 + 50 = 4+50 = 54
segment  code use32 class=code ; code segment
start: 
mov AX,[a]              ;AX=000A
mul AX                  ;DX=0000 AX=0064      DX:AX = a*a
mov EBX,0h              ;EBX = 0000 0000
mov ECX,0h              ;ECX = 0000 0000
mov BX,DX               ;EBX = 0000 0000
mov CX,AX               ;ECX = 0000 0064      EBX:ECX = a*a
mov EDX,0h              ;EDX = 0000 0000
mov EAX,0h              ;EAX = 0000 0000
mov AL,[b]              ;EAX = 0000 0014
mov SI,[c]              ;SI = 0002
div SI                  ;AX=000A              AX = b/c
dec AX                  ;AX=0009              AX = b/c - 1
add ECX,EAX             ;ECX = 0000 006D
adc EBX,EDX             ;EBX = 0000 0000      EBX:ECX = (a*a + b/c - 1)
mov EDX,EBX             ;EDX = 0000 0000
mov EAX,ECX             ;EAX = 0000 006D      EDX:EAX = (a*a + b/c - 1)
mov EBX,0h              ;EBX = 0000 0000
mov BL,[b]              ;EBX = 0000 0014
add BX,[c]              ;EBX = 0000 0016      EBX = b+c
div EBX                 ;EAX = 0000 0004      EAX = (a*a + b/c - 1)/(b+c)
mov EDX,0h              ;EDX = 0000 0000
mov EBX,0h              ;EBX = 0000 0000
mov ECX,[d]             ;ECX = 0000 013A
add EAX,ECX             ;EAX = 0000 013E
adc EDX,EBX             ;EDX = 0000 0000      EDX:EAX = (a*a + b/c - 1)/(b+c)+d
mov ECX,dword [x]       ;ECX = 0000 0108
mov EBX,dword [x+4]     ;EBX = 0000 0000
sub EAX,ECX             ;EAX = 0000 0036
sbb EDX,EBX             ;EDX = 0000 0000      EDX:EAX = (a*a + b/c - 1)/(b+c)+d-x

