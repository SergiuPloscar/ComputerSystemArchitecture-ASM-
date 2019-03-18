bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a  db 14h  ; 20
	b  db 1Eh  ; 30
    c  db 0Dh  ; 13
    d  dw 12Ch ; 300
    ; d+[(a+b)*5-(c+c)*5)]   / 300+[(20+30)*5 -(13+13)*5] = 300 + [ 250 - 130 ] = 420 = 01A4h
segment  code use32 class=code ; code segment
start: 
mov AX,0h   ;AX=0000
mov AL,[a]  ;AX=0014
add AL,[b]  ;AX=0032   AX = a+b
adc AX,0h   ;AX=0032
mov DX,5h   ;DX=0005
mul DX      ;DX=0000   AX = 00FA   DX:AX = (a+b)*5
mov BX,DX   ;BX=0000
mov CX,AX   ;CX=00FA               BX:CX = (a+b)*5
mov AX,0h   ;AX=0000
mov AL,[c]  ;AX=000D
add AL,[c]  ;AX=001A
mov DX,5h   ;DX=0005
mul DX      ;DX=0000   AX=0082     DX:AX =(c+c)*5
sub CX,AX   ;CX=0078
sbb BX,DX   ;BX=0000               BX:CX = (a+b)*5 - (c+c)*5
add CX,[d]  ;CX=01A4               BX:CX = d+[(a+b)*5-(c+c)*5)]
jnc here    ;In case we have a carry we add it to the higher registry in the pair containing the result
inc BX
here:

