bits 32 
global start        
extern exit ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll ; exit is a function that ends the calling process. It is defined in msvcrt.dll

; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
; our data is declared here (the variables needed by our program)
segment data use32 class=data
	s dd 12345678h, 1A2B3C4Dh, 0FE98DC76h      ; we need the high bytes of the low words of these double words, that are multiples of 10
    l equ ($-s)/4                              ; We calculate how many double words we have
    d times l db 0                             ; We define that many available positions to store the result in
    ten db 10                                  ; So we can check divisibility to 10
    
    
segment  code use32 class=code ; code segment
start: 
mov ESI,s                                      ; We select the string to be parsed
cld                                            ; We select the direction to be left - > right
mov ECX,l                                      ; We will loop as many times as we have doublewords
mov EDI,d                                      ; Our resulting string will be put in d
repeta:
    lodsw                                      ; We take the lower word of the current doubleword (It will be put in AX) 
    inc ESI                                    ; We move on to the next double word by incrementing ESI twice                     
    inc ESI
    shr AX,8                                   ; By shifting to the right we put AH into AL 
    mov BL,AL                                  ; We keep a copy of our byte so we don't lose it after the divisibility check|  
    div byte[ten]                              ; We divide by 10
    mov AL,BL                                  ; We restore our byte
    cmp AH,0                                   ; If AH is 0 then our byte is divisible by 10 
    jnz nonmultiplu                            ; If AH is != 0 then we skip ahead to the next doubleword
    stosb                                      ; Reaching this instructions means our byte is divisible so we add it to the string d
    nonmultiplu:
loop repeta                                    ; At the end of this loop, the string d will be loaded with the result 
mov EAX,0                                      ; All the instructions from here on are only for verification
mov ECX,l                                      ; What we do is we parse d and we load each byte in it to check if everything is correct
mov ESI,d
verificare:
lodsb
loop verificare


    
    
