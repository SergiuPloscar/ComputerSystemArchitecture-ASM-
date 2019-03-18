bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 30
	b  db 20
    c  db 10
    ;(a+a) - (b+b) - c
segment  code use32 class=code ; code segment
start: 
; We put the bytes into a word size registry to avoid overflows
mov AX,0h  ; AX = 0000
mov AL,[a] ; AX = 001E
add AX,AX  ; AX = 003C  / AX = a+a
mov BX,0h  ; BX = 0000
mov BL,[b] ; BX = 0014
add BX,BX  ; BX = 0028  / BX = b+b
sub AX,BX  ; AX = 0014  / AX = (a+a) - (b+b)
sub AX,[c] ; AX = 000A = 10 / AX = (a+a) - (b+b) - c /  (30+30)-(20+20)-10 = 60-40-10 = 10