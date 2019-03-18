bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	T  dd 468DE62Eh  ;                 0100 0110 1000 1101 1110 0110 0010 1110
    R  dd 0BA167489h ;                 1011 1010 0001 0110 0111 0100 1000 1001
    Q  dd 0h ; the result should be :  0100 1000 1001 1011 1001 0010 1111 1001
    
segment  code use32 class=code ; code segment
start: 
mov EAX,0h                                ; EAX = 00000000 (we want to use EAX to form our required number)
mov EBX,[T]                               ; EBX = 468DE62E
and EBX,00000000000000011111110000000000b ; EBX = 0001E400 = 0000 0000 0000 0001 1110 0100 0000 0000 we keep the bits from 10-16 of T
or EAX,EBX                                ; EAX = 0001E400 = 0000 0000 0000 0001 1110 0100 0000 0000
mov CL,10                                 ; We move in CL the number of shifts we need  
shr EAX,CL                                ; EAX = 00000079 = 0000 0000 0000 0000 0000 0000 0111 1001  first part of number
mov EBX,[T]                               ; EBX = 468DE62E = 0100 0110 1000 1101 1110 0110 0010 1110  
mov EDX,[R]                               ; EDX = BA167489 = 1011 1010 0001 0110 0111 0100 1000 1001 and we use XOR and get
xor EBX,EDX                               ; EBX = FC9B92A7 = 1111 1100 1001 1011 1001 0010 1010 0111
and EBX,00000001111111111111111110000000b ; EBX = 009B9280 = 0000 0000 1001 1011 1001 0010 1000 0000 we keep the bits from 7-24 of T xor R
or EAX,EBX                                ; EAX = 009B92F9 = 0000 0000 1001 1011 1001 0010 1111 1001  second part of number
and EDX,00000000000000000000111111100000b ; EDX = 00000480 = 0000 0000 0000 0000 0000 0100 1000 0000 we keep the bits from 5-11 of R
mov CL,20                                 ; We move in CL the number of shifts we need
shl EDX,CL                                ; EDX = 48000000 = 0100 1000 0000 0000 0000 0000 0000 0000 
or EAX,EDX                                ; EAX = 489B92F9 = 0100 1000 1001 1011 1001 0010 1111 1001 the final result
mov [Q],EAX                               ; So we just put it in Q because we know it is final and correct
