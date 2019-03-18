bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	b  db 0DCh ; 220
	c  db 3h   ; 3
    e  dw 156h ; 342
    g  dw 104h ; 260
    ;(e+g-2*b)/c    / (342+260-2*220)/3 = (602-440)/3 = 162/3 = 54 = 0036h
segment  code use32 class=code ; code segment
start: 
mov CL,2h ;CX = 0002
mov AX,0h ;AX = 0000
mov AL,[b];AX = 00DC
mul CL    ;AX = 01B8   / AX = 2*b
mov BX,[e];BX = 0156
add BX,[g];BX = 025A   / BX = e+g
sbb BX,AX ;BX = 00A2   / BX = e+g - 2*b
mov AX,BX ;AX = 00A2   / AX = e+g - 2*b
mov CL,[c];CX = 0003
div CL    ;AH = 00 ( rest = 0 )  AL = 36 ( cat = 54 )  / AX = 0036



