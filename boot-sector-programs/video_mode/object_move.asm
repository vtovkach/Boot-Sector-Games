org 0x7C00


;; [es:di] - extra segment 

start:
    ; Set video mode 13h
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; ES = video segment
    mov ax, 0xA000
    mov es, ax

draw_background:
    mov cx, 320 * 200
    mov al, 15
    rep stosb

    jmp end


;; ax 
;; di
;; si 

;; Unused 
;; bx - offset 
;; dx 
;; cx 

display_obj:
    
    mov si, object_bitmap
    ;; calculate offset 
    mov al, [object_y]
    xor ah, ah 
    mov cx, 320 
    mul cx 
    mov al, [object_x]
    xor ah, ah  
    add bx, ax 
    mov di, bx 

    mov cx, 96
draw_loop:

    ;; check if bit
    

    loop draw_loop

;; hault the processor 
end:
    cli 
    hlt    

object_x:       db 160
object_y:       db 100

object_size:    db 96

object_bitmap:
    db 00000001b, 10000000b
    db 00000011b, 1100000b
    db 00001111b, 11110000b
    db 00111111b, 11111100b
    db 01111111b, 11111110b
    db 11111111b, 11111111b


times 510-($-$$) db 0
dw 0xAA55