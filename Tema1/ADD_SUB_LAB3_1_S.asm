bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 40    ; 0028
	b  dw -67   ; FFBD
    c  dd 348   ; 015C
    d  dq -102  ; FF9A
    ;(c-b+a)-(d+a)  /(348- -67 + 40 ) - (-102 + 40) =  455 -  -62 = 517 = 0205h
segment  code use32 class=code ; code segment
start: 
mov ECX,[c]         ; ECX = 0000 015C     
mov AX,[b]          ; AX = FFBD
cwde                ; EAX =FFFF FFBD
sub ECX,EAX         ; ECX = 0000 019F   / ECX = c-b       
mov AL,[a]          ; AL = 28
cbw                 ; AX = 0028
cwde                ; EAX = 0000 0028
add ECX,EAX         ; ECX = 0000 01C7   / ECX = c-b+a              
mov EBX,dword [d]   ; EBX = FFFF FF9A   
add EBX,EAX         ; EBX = FFFF FFC2   
mov EAX,ECX         ; EAX = 0000 01C7   
cdq                 ; EDX = 0000 0000 EAX=0000 01C7 /   EDX:EAX = c-b+a
mov ECX,dword [d+4] ; ECX = FFFF FFFF / ECX:EBX = d+a
sbb EAX,EBX         ; EAX = 0000 0205
sbb EDX,ECX         ; EDX = 0000 0000  / EDX:EAX contains the result of (c-b+a)-(d+a)
