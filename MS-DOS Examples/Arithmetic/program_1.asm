; Addition 

org 0x0100 

start: 
    mov al, 0x04
    add al, 0x03
    ;
    add al, 0x30
    call display_letter

    ; Print new line char
    mov al, 0x0d
    call display_letter
    ;
    mov al, 0x0a           
    call display_letter

    int 0x20  ; Terminate Process 

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
