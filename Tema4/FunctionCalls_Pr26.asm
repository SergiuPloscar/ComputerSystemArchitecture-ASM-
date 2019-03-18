bits 32
global start        

; declaring extern functions used in the program
extern exit, printf, scanf            
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicating to the assembler that the printf fct can be found in the msvcrt.dll library
import scanf msvcrt.dll      ; similar for scanf
                          
segment  data use32 class=data
	a dd 0                              ;First keyboard input
	b dd 0                              ;Second keyboard input
    k equ 2                             ;The constant
    message1 db "a=", 0                 ;Message for first input
    message2 db "b=", 0                 ;Message for second input
    format1  db "%d", 0                 ;We take the inputs as decimal numbers
	format2  db "(a-b)*2 = %Xh", 0       ;The result will be the hexa value of the operation
    
segment  code use32 class=code
    start:
    push dword message1                 ;We print "a=" on the screen 
    call [printf]
    add ESP,4                           ;Reseting the stack pointer
    push dword a                        ;We take the value of a from the keyboard as a decimal value
    push dword format1
    call [scanf]
    add ESP, 4*2                        ;Reseting the stack pointer
    mov EAX,0                           ;We empty EAX to prepare our result and store our first value in AL 
    mov AL,[a]
    PUSHAD                              ;We save the values of the registries 
    push dword message2                 ;We print "b=" on the screen
    call [printf]
    add ESP,4                           ;Reseting the stack pointer
    push dword b                        ;We take the value of b from the keyboard as a decimal value
    push dword format1
    call [scanf]    
    add ESP, 4*2                        ;Reseting the stack pointer
    POPAD                               ;We restore our registries to the values we saved before
    sub AX,[b]                          ;We perform a-b in AX
    lea eax,[eax*k]                     ;We perform (a-b)*k and move it to EAX
    push dword EAX                      ;We prepare to print our result
    push dword format2
    call [printf]                       ;We print the result of our operation in hexa
    add ESP, 4*2                        ;Reseting the stack pointer
    push dword 0
    call[exit]
    