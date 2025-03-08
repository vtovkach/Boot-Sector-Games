
section .text

    org 0x0100

start:
    ; starting point 
    call initialize_board
    call display_board
    
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
    push ax
    push bx
    push di
    push si 
    mov si, board   ; si holds a current address of board
    mov di, board
    add di, 9       ; di holds a max address  
    mov bx, 0       ; new line iterator 
testLoop:
    cmp si, di
    jge endloop

    ; calculate if new line needed 
    mov ax, bx
    mov cx, 3   ; modulo 0
    xor dx, dx  ; clear reg dx 
    div cx 
    cmp dx, 0
    jne endifnew
ifnew: 
    mov ax, 10
    call display_letter
    mov ax, 13
    call display_letter
endifnew:
    ;endif

    mov ax, [si]
    call display_letter
    add si, 1 ; increment pointer 
    add bx, 1 ; increment new line iterator
    jmp testLoop
endloop:
    ; make new line 
    mov ax, 10
    call display_letter
    call display_letter
    mov ax, 13
    call display_letter
    pop si
    pop di
    pop bx
    pop ax 
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
