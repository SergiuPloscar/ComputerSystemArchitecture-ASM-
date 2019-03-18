bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 0Eh    ;14
	b  dw 10Fh    ;271
    c  dd 10001h ;65537
    d  dq 9E84h  ;40580
    ;(c-b+a)-(d+a)  / (65537-271+14)-(40580+14)=65280-40594=24686 = 606Eh
segment  code use32 class=code ; code segment
start: 
mov EAX,[c]         ;EAX = 00010001
mov ECX,0h          ;ECX = 00000000
mov CX,[b]          ;ECX = 0000010F
sub EAX,ECX         ;EAX = 0000FEF2  / EAX = c-b
mov ECX,0h          ;ECX = 00000000
mov CL,[a]          ;ECX = 0000000E
add EAX,ECX         ;EAX = 0000FF00  / EAX = c-b+a
mov EDX,0h
jnc here ; We turn our double from EAX into a quad on EDX:EAX and in case we have a carry we add that to EDX 
inc EDX
clc
here:
mov ECX,0h          ;ECX = 00000000
mov CL,[a]          ;ECX = 0000000E
add ECX,dword [d]   ;ECX = 00009E92    We split the quad in d into EBX:ECX
mov EBX,dword [d+4] ;EBX = 00000000
jnc here2 ; In case we have a carry from the add above we add it to EBX
inc EBX
clc
here2:
sub EAX,ECX        ;EAX = 0000606E   In case this sub needs a borrow we make the next sub a sbb 
sbb EDX,EBX        ;EDX = 00000000
; So our result is the quad on EDX:EAX  