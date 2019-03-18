bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  dw 10    ; Ah
	b  db 20    ; 14h
    c  dw -2    ; FEh
    d  dd -314  ; FEC6h
    x  dq 264   ; 108h
    ;(a*a+b/c-1)/(b+c)+d-x /  (10*10+20/-2-1)/(20+ -2)+ -314-264 = (100-10-1)/(18) -578 = 89/18 - 578 = -574   FDC2h
segment  code use32 class=code ; code segment
start: 
mov AX,[a]      ;AX=000A
mov EDX,0h      ;EDX=0000 0000
cwde            ;EAX=0000 000A
imul AX         ;DX=0000 AX=0064
mov EBX,EDX     ;EBX=0000 0000
mov ECX,EAX     ;ECX=0000 0064    EBX:ECX = a*a
mov EAX,0h      ;EAX=0000 0000
mov EDX,0h      ;EDX=0000 0000
mov AL,[b]      ;EAX=0000 0014
cbw             ;EAX=0000 0014
cwd             ;EAX=0000 0014
mov SI,[c]      ;SI=FFFE
idiv SI         ;AX=FFF6 AX= b/c  
cwde            ;EAX=FFFF FFF6
cdq             ;EDX=FFFF FFFF
dec EAX         ;EAX=FFFF FFF5
add ECX,EAX     ;ECX=0000 0059
adc EBX,EDX     ;EBX=0000 0000    EBX:ECX = (a*a+b/c-1)  
mov EDX,0h      ;EDX=0000 0000
mov EAX,0h      ;EAX=0000 0000
mov AL,[b]      ;EAX=0000 0014
cbw             ;EAX=0000 0014
cwde            ;EAX=0000 0014
mov EDX,EAX     ;EDX=0000 0014
mov EAX,0h      ;EAX=0000 0000
mov AX,[c]      ;EAX=0000 FFFE
cwde            ;EAX=FFFF FFFE
add EDX,EAX     ;EDX=0000 0012    EDX = b+c   
mov EAX,ECX     ;EAX=0000 0059
mov ECX,EDX     ;ECX=0000 0012
mov EDX,EBX     ;EDX=0000 0000    EDX:EAX = (a*a+b/c-1)   ECX = b+c
idiv ECX        ;EAX=0000 0004    EAX = (a*a+b/c-1)/(b+c)
cdq             ;EDX=0000 0000
mov EBX,0h      ;EBX=0000 0000
mov ECX,0h      ;ECX=0000 0000
mov EBX,EDX     ;EBX=0000 0000
mov ECX,EAX     ;ECX=0000 0004    EBX:ECX = (a*a+b/c-1)/(b+c)
mov EAX,0h      ;EAX=0000 0000
mov EDX,0h      ;EDX=0000 0000
add ECX,[d]     ;ECX=FFFF FECA    
jnc here
inc EBX
here:
clc             ;EBX:ECX = (a*a+b/c-1)/(b+c)+d
mov EAX,dword[x];EAX=0000 0108
mov EDX,dword[x+4];EDX=0000 0000
sub ECX,EAX     ;ECX=FFFF FDC2
sbb EBX,EDX     ;EBX=0000 0000
