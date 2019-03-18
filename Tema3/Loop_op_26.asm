bits 32 
global start        
extern exit,printf ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
; our data is declared here (the variables needed by our program)
segment data use32 class=data
	s db 12, 13, 5, 9, 21, 8 , 7      ; We need the max of the numbers in even positions and min of the numbers in odd positions ;
                                      ; Final result should be 21, 8                
    l equ $-s                         ; Computes the length of the string, in this case l=7
    d times 2 db 0                    ; Creates two bytes where we will store the max and min
segment  code use32 class=code ; code segment
start: 
mov ECX,l                             ; Preparing for the loop
mov ESI,0                             ; We use ESI to select which element in the string we need
mov BL,[s]                            ; Using BL to move the first element of the string into the min spot
mov [d+1],BL                          ; We do this because we are working with unsigned numbers and since we start the min var with 0 it
                                      ; wont change otherwise. We don't do it for max because any unsigned will be greater than 0.
                                      ; if there is none greater, 0 is fine
mov BL,0                              ; We use BL to check whether we are on an even ( 0 ) or odd ( 1 ) position in the string
jecxz Sfarsit                         ; We don't want to loop if ECX != 0
        Repeta:                       ; Loop starting point
            mov AL,[s+ESI]            ; We take the current number from the string 
            cmp BL,0                  ; We check if we are at an odd or even position
            JNE Impare                ; If it is even we continue, otherwise we jump to Impare
                cmp AL,[d]            ; We compare our number with max since we are on the even route
                JBE Max               ; If our number is lower or equal to max we jump to Max, otherwise if it is greater we update max
                    mov [d],AL        ; This is us updating max 
                Max:
                    inc BL            ; We know that the next number will be on an odd position
                    JMP SfarsitOp     ; We have done everything with our current number
            Impare:                   ; This is the odd route
                cmp AL,[d+1]          ; We compare our number with min since we are on the odd route
                JGE Min               ; If our number is greater or equal to min we jump to Min, otherwise if it is lower we update min
                    mov [d+1],AL      ; This is us updating min
                Min:    
                    dec BL            ; We know that the next number will be on an even position
                    JMP SfarsitOp     ; We have done everything with our current number
        SfarsitOp:
        inc ESI                       ; We get ready to go to the next number
        loop Repeta                   ; We loop, doing the same operations until we run out of numbers
     Sfarsit:
mov AX,0
mov BX,0                              ; Just used to check the result
mov AL,[d]                            ; AL= 15h which is 21, so it is correct
mov BL,[d+1]                          ; BL= 08h which is 8, so it is correct
