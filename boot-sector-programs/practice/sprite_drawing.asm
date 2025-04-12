

org 0x7c00


;; ======================= CONSTANTS ========================

SCREEN_WIDTH           equ  320
SCREEN_HEIGHT          equ  200
VIDEO_MODE_ADDRESS     equ  0xa000
SPRITE_WIDTH           equ  8
SPRITE_HEIGHT          equ  4
SPRITE_COLOR           equ  2

;; Activate Video Mode 
mov ax, 0x0013
int 0x10

;; Setup Extra Segment 
push VIDEO_MODE_ADDRESS
pop es 


main_loop:
    mov cx, SCREEN_HEIGHT * SCREEN_WIDTH
    xor ax, ax 
    xor di, di 
    rep stosb  
    

    xor ax, ax 
    mov al, SCREEN_WIDTH  / 2
    mov ah, SCREEN_HEIGHT / 2
    mov bx, SPRITE_COLOR

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
    add di, dl

    ret

sprite_bitmap:
    db 11111111b
    db 11111111b
    db 11111111b
    db 11111111b

times 510-($-$$) db 0

dw 0xaa55