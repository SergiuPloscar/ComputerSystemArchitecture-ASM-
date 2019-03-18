bits 32

global start


extern exit, fprintf, fopen, fread, fclose, scanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll


segment data use32 class=data
    file_name db "Pr26Lab8.txt", 0   
    access_mode db "w", 0                                  
    file_descriptor dd -1
    format3 db "%c%c",0    
    format db "%s",0    
    string dd 0
    
; our code starts here
segment code use32 class=code
    start:
     push dword access_mode     
     push dword file_name
     call [fopen]                ; we open the file 
     add esp, 4*2                ; clean-up the stack
     mov [file_descriptor], eax  ; store the file descriptor returned by fopen
     cmp eax, 0                  ; check if fopen() has successfully created the file (EAX != 0)
     je final
     cld
     repeta:                     
       
        push dword string
        push dword format
        call [scanf]             ; we take a word from the keyboard
        add esp,4*2              ; clean-up the stack
        cmp eax,0                ; in case scanf crashes we end the execution
        je final            
        mov ESI,string           ; we parse through the letters of the word
        nextchar:
            mov EBX,0            ; We use EBX to check if our letter is Uppercase
            lodsb                ; We take a letter
            cmp AL,'$'           ; If we reach the symbol $ we stop the execution
            je final
            cmp AL,0             ; If we reach the end of the word we go back and read another word
            je afterjmp
            cmp AL,'A'           ; We verify if the letter is uppercase ( A <= letter <= Z )
            jl afterinc
            cmp AL,'Z'
            jg afterinc
            inc EBX              ; If we reach this point the letter is uppercase and we store that in EBX
            afterinc:
            cmp EBX,1            ; If the letter is uppercase we add the word to the file and go to the next line
            jne afterfile
            push dword string
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*2
            push dword 13
            push dword 10
            push dword format3
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*4
            jmp repeta
            afterfile:          
                                 ; If we reach this point we move on to the next letter
            jmp nextchar
            afterjmp:
            jmp repeta           ; If we reach this point our word had no uppercase letters so we move on to the next word
            
    
    
    
    final:
        push dword [file_descriptor]        ; we close the file, clean up the stack and stop the execution
        call [fclose]
        add esp, 4
        push dword 0      
        call [exit]