bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  dw 64h   ; 100
	b  dw 25h   ; 37
    c  dw 0C8h   ; 200
    d  dw 5Fh   ; 95
    ;(a+c) - (b+b+d)
segment  code use32 class=code ; code segment
start: 
mov EAX,0h ; EAX = 0000 0000
mov AX,[a] ; EAX = 0000 0064
add EAX,[c] ; EAX = 0000 012C  / EAX = a+c
mov EBX,0h ; EBX = 0000 0000
mov BX,[b] ; EBX = 0000 0025
add EBX,EBX; EBX = 0000 004A  / EBX = b+b
add EBX,[d]; EBX = 0000 00A9  / EBX = b+b+d
sub EAX,EBX; EAX = 0000 0083  / EAX = (a+c) - (b+b+d)  / 131 = (100+200) -(37+37+95) = 300 - 169 
