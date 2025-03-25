;;;
;;; Space Invaders Game 
;;; 
org 0x7c00
;; SETUP 
;; Set up video mode - VGA mod 13h, 320x200, 256 colors, 8bpp, linear framebuffer at address 0xA000
mov ax, 0x0013
int 0x10 

;; Set up video memory
push 0xA000
pop es              ; ES -> 0xA000  

;; GAME LOOP ===================================
game_loop:
    mov al, 0x04        ; VGA RED
    mov cx, 320*200
    xor di, di
    rep stosb   ; [ES:DI], al cx # of times

    ;; Delay timer - 1 tick delay (1 tick = 18.2/second)
    


jmp game_loop


;; End game & reset TODO
game_over:
    cli
    hlt

times 510-($-$$) db 0

; Boot signature 
dw 0xaa55