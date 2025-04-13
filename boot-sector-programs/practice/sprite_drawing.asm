

org 0x7c00


;; ======================= CONSTANTS ========================

SCREEN_WIDTH           equ  320
SCREEN_HEIGHT          equ  200
VIDEO_MODE_ADDRESS     equ  0xa000
SPRITE_WIDTH           equ  8
SPRITE_HEIGHT          equ  4
SPRITE_COLOR           equ  2

TIMER                  equ 046Ch

;; ===================== VARIABLES ========================

SPRITE_BITMAP_LOCATION  equ 0xFA00

;; Activate Video Mode 
mov ax, 0x0013
int 0x10

;; Setup Extra Segment 
push VIDEO_MODE_ADDRESS
pop es 

mov si, sprite_bitmap
mov di, SPRITE_BITMAP_LOCATION

mov cx, 2
rep movsw

push es
pop  ds 

main_loop:
    mov cx, SCREEN_HEIGHT * SCREEN_WIDTH
    xor ax, ax 
    xor di, di 
    rep stosb  
    

    xor ax, ax 
    mov al, SCREEN_WIDTH  / 2
    mov ah, SCREEN_HEIGHT / 2
    mov bx, SPRITE_COLOR

    mov si, SPRITE_BITMAP_LOCATION

    call draw_sprite

end:
    cli 
    hlt


;; Input
;;  al - X cordinate 
;;  ah - Y cordinate 
;;  bx - color
;;  si - sprite bitmap address 
draw_sprite:
    ;; TODO 
    call calculate_mem_position

    xor di, di

    add di, SCREEN_WIDTH / 2 
    add di, SCREEN_WIDTH * 100 

    mov cx, SPRITE_HEIGHT
    draw_line: 

        push cx 
        lodsb 
        mov cx, SPRITE_WIDTH
        mov dx, ax 

        .draw_pixel:

            pusha 
            .delay_timer:
                mov ax, [CS:TIMER]
                inc ax
                .wait_d:
                    cmp [CS:TIMER], ax 
                    jl .wait_d
            popa 

            xor ax, ax 
            dec cx 
            bt dx, cx 
            jnc .skip_pixel
            mov ax, bx 
            mov ah, al 
            mov [di + SCREEN_WIDTH], ax 
            stosw 

            jmp .next_pixel

        .skip_pixel:
        add di, 2 
        cmp cx, 0
        .next_pixel:
        jne .draw_pixel

        add di, SCREEN_WIDTH * 2 - 16
        pop cx 
        
    loop draw_line 
    
    ret 

change_backgroud:
    pusha 
    mov cx, SCREEN_HEIGHT * SCREEN_WIDTH
    xor ax, ax 
    xor di, di
    mov al, 201
    rep stosb
    popa 
    ret

;; Input
;;  ax - cordinate X/Y
;; Output
;;  di - calculated address for printing 
calculate_mem_position:
    mov dx, ax 
    mov al, ah 
    cbw 
    imul di, ax, SCREEN_WIDTH
    xor ax, ax
    mov ax, dx 
    cbw 
    add di, ax
    ret

sprite_bitmap:
    db 10011001b   
    db 01011010b 
    db 00111100b
    db 01000010b

times 510-($-$$) db 0

dw 0xaa55