
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
    mov cx, 3 ; there're three lines to print

    ; set initial draw position 
    push 0xb800
    pop es 
    xor di, di
    mov si, 0 ; number of symbols printed
    call draw_game 

    ; TODO 
    jmp end;

draw_game:
    ; draw game table
    ; arguments: $bx - table base address, $cx - counter 
    push cx
    mov cx, 3 
    call draw_line
    pop cx 
    inc si
    ; check if si == 3
    cmp si, 3
    jne .no_update
; update si, if $si == 3
    mov si, 0
    add di, 156
.no_update:
    loop draw_game
    ret
    
draw_line:
    ; display a line
    ; args: $cx - loop counter (3), $bx - table address 
    mov ah, TEXT_COLOR
    mov al, [bx]
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

table db '1', '2', '3', '4', '5', '6', '7', '8', '9'

times 510 - ($ - $$) db 0
db 0x55, 0xaa