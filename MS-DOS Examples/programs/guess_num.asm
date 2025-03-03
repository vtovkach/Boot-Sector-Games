
org 0x0100

section .text

    in al, (0x40)
    and al, 0x07
    add al, 0x30
    mov cl, al

    mov si, intro_string1
    call display_label

game_loop:
    ; make new line
    mov si, endline
    call display_label
    ; print guess number string 
    mov si, intro_string2
    call display_label
    ; read input, result is stored in AL
    call read_keyboard
    ; check if input equals to the key number 
    cmp cl, al 
    jne game_loop

    ; make new line 
    mov si, endline
    call display_label
    
    mov si, final_string
    call display_label
    mov si, endline
    call display_label

    call terminate_prog  ; terminate process 

display_label:
    push si

loop_i:
    mov al, [si]
    cmp al, '$'
    je end_i
    call display_letter
    inc si
    jmp loop_i

end_i:
    pop si
    ret

display_letter:
    push ax
    push bx
    push cx
    push dx 
    push si
    push di 
    mov  ah, 0x0e    ; Load AH with code for terminal output 
    mov  bx, 0x000f  ; Load BH page zero and BL color (graphic mode)
    int  0x10        ; Call BIOS for displaying one letter 
    pop di 
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret             ; Return to caller

read_keyboard:
    push bx
    push cx
    push dx 
    push si
    push di 
    mov  ah, 0x00   ; Load Ah with code for keyboard read 
    int  0x16       ; Call the BIOS for reading keyboard
    pop di
    pop si 
    pop dx 
    pop cx 
    pop bx 
    ret             ; Return to caller 

terminate_prog:
    int 0x20

intro_string1 db "Welcome to Guess Number Game! You need to guess number between 0 and 7!", '$' 
intro_string2 db "Guess Number: ", '$'
final_string  db "Bingo, You got this!", '$'
endline db " ", 0x0D, 0x0A, '$'