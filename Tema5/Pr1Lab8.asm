bits 32

global start


extern exit, printf, fopen, fread, fclose, scanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll


segment data use32 class=data
    file_name db "Pr1Lab8.txt", 0   
    access_mode db "r", 0                                  
    file_descriptor dd -1    
    format2 db "Fisierul contine %d vocale",0  
    format db "%s",0    
    string dd 0
    len equ 100
; our code starts here
segment code use32 class=code
    start:
    push dword access_mode          ;we open the file with the text
    push dword file_name
    call [fopen]
    add esp, 4*2 
    mov [file_descriptor], eax 
    cmp eax, 0                      ;if the open fails we end the execution
    je final
    push dword [file_descriptor]
    push dword len
    push dword 1
    push dword string       
    call [fread]                    ;we read the text from the file
    add esp, 4*4
    push dword [file_descriptor]    ;we close the file because we dont need it anymore
    call [fclose]
    add esp, 4
    cld
    mov ESI,string                  ;we prepare to parse through the text
    mov EBX,0                       ;we keep the number of vowels in EBX
    repeta:
        lodsb
        cmp AL,0                    ;if we reach the end of the text we end the execution
        je final
        cmp AL,'a'                  ;we compare our current letter with every vowel
        je count
        cmp AL,'e'
        je count
        cmp AL,'i'
        je count
        cmp AL,'o'
        je count
         cmp AL,'u'
        je count
         cmp AL,'A'
        je count
         cmp AL,'E'
        je count
         cmp AL,'I'
        je count
         cmp AL,'O'
        je count
         cmp AL,'U'
        je count    
        jmp repeta                  ;if we reach this point our letter is not a vowel so we move on
        count:
        inc EBX                     ;if we reach this point our letter is a vowel and we count it
        jmp repeta
  
    
    final:
    push dword EBX                  ;we print the number of vowels on the screen
    push dword format2
    call [printf]
    add esp,4*2
    push dword 0
    call [exit]