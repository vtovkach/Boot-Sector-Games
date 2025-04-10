;;;
;;; Space Invaders Game 
;;; 
use16
org 0x7c00

;; DEFINE VARIABLES AFTER SCREEN MEMORY - 320*200 = 64000 (FA00H)
sprites         equ 0FA00h
alien1          equ 0FA00h
alien2          equ 0FA04h
ship            equ 0FA08h 
barrierArr      equ 0FA0Ch 
alienArr        equ 0FA20h ; 2 words (1 dblword) - 32bits/aliens
playerX         equ 0FA24h
shotsArr        equ 0FA25h
alienY          equ 0FA2Dh
alienX          equ 0FA2Eh
num_aliens      equ 0FA2Fh
direction       equ 0FA30h
move_timer      equ 0FA31h
change_alien    equ 0FA33h ; Use alternate sprite yes/no

;; CONSTANTS ====================================
SCREEN_WIDTH            equ 320
SCREEN_HEIGHT           equ 200
VIDEO_MEMORY            equ 0A000h
TIMER                   equ 046Ch  ; # of timer ticks since midnight
BARRIERX                equ 22
BARRIERY                equ 85
PLAYERY                 equ 93
SPRITEH                 equ 4
SPRITEW                 equ 8
SPRITEWP                equ 16

; colors 
ALIEN_COLOR             equ 02h  ; Green
PLAYER_COLOR            equ 07h  ; Gray
BARRIER_COLOR           equ 27h  ; RED
PLAYER_SHOT_COLOR       equ 0Bh  ; Cyan
ALIEN_SHOT_COLOR        equ 0Eh  ; Yellow


;; SETUP 
;; Set up video mode - VGA mod 13h, 320x200, 256 colors, 8bpp, linear framebuffer at address 0xA000
mov ax, 0x0013
int 0x10 

;; Set up video memory
push VIDEO_MEMORY
pop es                  ; ES -> 0xA000  

;; Load sprite bitmaps into es:di
mov di, sprites             ;; address (FA00H)
mov si, sprite_bitmaps      
mov cl, 6
;; mov worrd from [DS:SI] to [ES:DI]
rep movsw

;; Move barrier bitmap to barrier array
;; Barrier array will contain 5 barriers 
;; So I move 5 doblewords into barrierarray; address []
lodsd    
mov cl, 5
rep stosd  

;; Set initial variables
mov cl, 5
rep movsb 

xor ax, ax
mov cl, 4
rep stosw 

mov cl, 7
rep movsb 

; Make Extra Segment equal to Data Segment 
push  es
pop   ds 


;; GAME LOOP ===================================
game_loop:
    xor ax, ax
    xor di, di
    mov cx, SCREEN_HEIGHT * SCREEN_WIDTH
    rep stosb           ; [ES:DI], al cx # of times

    ;; ES:DI now points to AFA00h
    ;; Draw aliens -------------------------------

    mov si, alienArr
    mov bl, ALIEN_COLOR
    mov ax, [si + 13]   ; AL = alienY, AH = alienX
    cmp byte [si+19], cl
    mov cl, 4 
    jg draw_alien_loop  ; Nope, use normal sprites
    add di, cx 
    draw_next_alien_row:
        pusha 
        mov cl, 8       ; # of aliens to chceck per row
        .check_next_alien:
            pusha
            dec cx 
            bt [si], cx 
            jnc .next_alien

            mov si, di 
            call draw_sprite 

            .next_alien:
                popa 
                add ah, SPRITEW+4
        loop .check_next_alien

        popa 
        add al, SPRITEH+2
    loop draw_next_alien_row
    


    ;; Draw barriers -----------------------------
    ;; Draw player ship --------------------------
    ;; Check if shot hit anything ----------------
        ;; Hit player
        ;; Hit barrier 
        ;; Hit allien
    ;; Draw shots -------------------------------- 
    ;; Create alien shots ------------------------
    ;; Move aliens -------------------------------
    ;; Get player input --------------------------


    ;; Delay timer - 1 tick delay (1 tick = 18.2/second)
    ;; 046Ch # of imer ticks since midnight 
    delay_timer:
        mov ax, word [046Ch]
        inc ax
        .wait_d:
            cmp [0x046C], ax 
            jl .wait_d
jmp game_loop


;; End game & reset TODO
game_over:
    cli
    hlt


;; Draw a sprite to the screen
;; INPUT parameters: 
;;  SI = address of sprite to draw 
;;  AL = Y Value of sprite 
;;  AH = X value of sprite 
;;  BL = color 
draw_sprite:
    call get_screen_position
    mov cl, SPRITEH
    .next_line:
        push cx 
        lodsb 
        ;; I am here!!!!


    ret 

;; GET X/Y screen position in DI 
;; INPUT Parameters:
;;  AL = Y value
;;  AH = X value 
;; Clobbers:
;;  DX
get_screen_position:
    mov dx, ax      ; Save Y/X values  
    cbw             ; Convert byte to word - sign extend AL into AH, AH = 0 if AL < 128
    imul di, ax, SCREEN_WIDTH*2   ; DI = Y value 
    mov ah, al      ; AX = X value  
    shl ax, 1       ; X value * 2
    add di, ax      ; DI = Y value + X value or X/Y positions 

    ret

;; CODE SEGMENT DATA ===========================================
sprite_bitmaps:
    db 10011001b    ; Alien 1 bitmap
    db 01011010b 
    db 00111100b
    db 01000010b

    db 10011001b    ; Alien 2 bitmap
    db 01011010b 
    db 00111100b
    db 01000010b

    db 00001000b    ; Player Ship bitmap
    db 00011100b 
    db 00110110b
    db 11111111b

    db 00111100b    ; Barrier bitmap
    db 01111110b 
    db 11100111b
    db 11100111b


    ;; Initial variable values 
    dw 0FFFFh       ; Alien array
    dw 0FFFFh
    db 70           ; PlayerX
    ;; times 6 db 0 ; Shots Array     
    dw 230Ah        ; alien Y & alien X | 10 = Y, 35 = X
    db 20h          ; # aliens = 32 

    db 0FBh         ; Direction -5
    dw 18           ; Move Timer 
    db 1            ; Chagne alien - toggle between 
    
times 510-($-$$) db 0

; Boot signature 
dw 0xaa55