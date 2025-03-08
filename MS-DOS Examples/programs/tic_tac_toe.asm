
section .text

    org 0x0100

start:
    ; starting point 
    call initialize_board
    ;call display_board
    
    int 0x20 

;Initialize SubRoutine
initialize_board:
    ; save reg values
    push bx
    push dx 
    mov bx, board
    mov dx, 0 ; iterator
loopTest:
    cmp dx, 9
    jge end_loop1
    mov byte [bx], '*'
    inc dx
    add bx, 1
    jmp loopTest
end_loop1:
    ; restore regs values
    pop dx
    pop bx
    ret
;;;;


get_input:
    ; will receive input from user row and column 


;Display Board
display_board:
    ; will display board here
    push ax
    push bx
    push dx
    push cx

    mov bx, board
    mov dx, 0 ; iterator
loop2Test:
    cmp dx, 9
    jge end_loop2
    
    ; module 2
    mov ax, dx 
    mov cx, 2
    div cx
    cmp dx, 0
    jne endif
if_newline:
    push ax
    mov ax, 0x0d
    call display_letter
    mov ax, 0x0a
    call display_letter
    pop ax
endif:
    ;continue here
    mov al, [bx]
    call display_letter
    inc dx
    add bx, 1
    jmp loop2Test 
end_loop2:
    pop dx
    pop bx
    ret
;;;;;


update_board:
    ; will update board with a cordinate and value


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

section .bss
X: resb 1
board: resb 9