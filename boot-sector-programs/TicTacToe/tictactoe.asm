
org 0x7c00

TEXT_COLOR equ 0x07

start:
    ; Turn on Color Text Mode 
    mov ax, 0x0003
    int 0x10
    ; Setup Data Segment 
    mov ax, cs 
    mov ds, ax 

    ; Setup Extra Segment 
    mov ax, 0xb800
    mov es, ax 

    ; Setup Stack Segment
    mov ax, 0x7e00
    mov ss, ax 

    xor di, di 

    ; clear direction bit 
    cld

game_loop:
    ; game loop
    mov bx, table
    push bx
    mov cx, 9
    call draw_game
    pop bx 

    jmp end 

draw_game:
    ; draw game table
    ; arguments: $bx - table base address, $cx - counter 
    push cx 
    mov cx, 3
    call draw_line
    pop cx

    loop draw_game

draw_line:
    ; display a line
    mov byte al, [bx]
    mov ah, TEXT_COLOR
    stosw 
    inc bx 
    loop draw_line
    ret 

get_input:
    ; TODO get input from the user
is_win:
    ; TODO determine if game is completed 

end:
    cli  ; Disable interupts
    hlt  ; Halt the CPU


table db '1', '2', '3', '4', '5', '6', '7', '9'

times 510 - ($ - $$) db 0
db 0x55, 0xaa