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
shotsArr        equ 0FA25h ; 4 Y/X shot values - 8 bytes, 1st shot is player 
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
BARRIERXY               equ 0x1953
BARRIERX                equ 0x19
BARRIERY                equ 0x53
PLAYERY                 equ 93
SPRITE_HEIGHT           equ 4
SPRITE_WIDTH            equ 8
SPRITEWP                equ 16
SPRITE_WIDTH_PIXELS     equ 16

; colors 
ALIEN_COLOR             equ 02h  ; Green
PLAYER_COLOR            equ 07h  ; Gray
BARRIER_COLOR           equ 27h  ; RED
PLAYER_SHOT_COLOR       equ 0Bh  ; Cyan
ALIEN_SHOT_COLOR        equ 0Eh  ; Yellow


;; Clarifications 

;; each bit in alien indicates wheather alien is alive and needs to be displayed 
;; we have 32 aliens, alienarray is 4 bytes (32 bits)


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
    mov ax, [si+13]       ; AL = alienY, AH = alienX
    cmp byte [si+19], cl  ; Change alien? CL = 0 from above
    mov cl, 4
    jg draw_next_alien_row    ; Nope, use normal sprite  
    add di, cx                ; Yes, use alternate sprite  (CX = 4)
    draw_next_alien_row:
        pusha
        mov cl, 8             ; # of aliens to check per row      
        .check_next_alien:
            pusha
            dec cx
            bt [si], cx     ; Bit test - copy bit to carry flag
            jnc .next_alien ; Not set, skip

            mov si, di      ; SI = alien sprite to draw
            call draw_sprite
            
            .next_alien:
                popa
                add ah, SPRITE_WIDTH+4
        loop .check_next_alien

        popa
        add al, SPRITE_HEIGHT+2
        inc si
    loop draw_next_alien_row

    ;; Draw player ship -------------------------- 
    lodsb ; AL = playerX 
    push si 
    mov si, ship
    mov ah, PLAYERY
    xchg ah, al ; Swap playerX and PlayerY values
    mov bl, PLAYER_COLOR
    call draw_sprite

    ;; Draw barriers -----------------------------
    mov bl, BARRIER_COLOR
    mov ax, BARRIERXY
    mov cl, 5
    draw_barrier_loop:
        pusha   
        call draw_sprite
        popa
        add ah, 25       ; # of pixels between barriers 
        add si, SPRITE_HEIGHT  
    loop draw_barrier_loop
    pop si 

    ;; Check if shot hit anything ----------------
    mov cl, 4 
    get_next_shot:
        push cx 
        lodsw           ; Get Y/X values for shot in AL/AH
        cmp al, 0 
        jnz check_shot 
        next_shot:
            pop cx 
    loop get_next_shot 

    ;;jmp create_alien_shots 

    check_shot:
        call get_screen_position     ; Put shot Y/X position in DI 
        mov al, [di]

        ;; Hit player
        cmp al, PLAYER_COLOR
        je game_over 

        ;; Hit barrier
        cmp al, BARRIER_COLOR
        jne .check_hit_alien 

        xor bx, bx 

        mov bx, barrierArr                  ; Start checking at first barrier 
        mov ah, BARRIERX + SPRITE_WIDTH     ; Start checking at right side of sprite

        ; dh X dl Y
        .check_barrier_loop:
            cmp dh, ah
            ja .next_barrier 

            sub ah, SPRITE_WIDTH        ; Get starting X value of barrier 
            sub dh, ah                  ; Subtract from shot X 

            pusha 
            sub dl, BARRIERY            ; Subtract from shot Y
            add bl, dl                  ; BX now points to pixel row of barrier 
            mov al, 7
            sub al, dh                  ; Subtract X value from max bit 
            cbw 
            btr [bx], ax                ; Bit test & reset, clear bit in barrier 
            mov byte [si-2], ah 
            popa 
            jmp next_shot
            
            .next_barrier:
                add ah, 25              ; Add X offset to check next barrier 
                add bl, SPRITE_HEIGHT   ; Go to next barrier in array

        jmp .check_barrier_loop 
        ;; Hit allien
        .check_hit_alien:
    ;; Draw shots -------------------------------- 
    ;; Create alien shots ------------------------
    ;; Move aliens -------------------------------
    ;; Get player input --------------------------


    ;; Delay timer - 1 tick delay (1 tick = 18.2/second)
    ;; 046Ch # of imer ticks since midnight 
    delay_timer:
        mov ax, [CS:TIMER]
        inc ax
        .wait_d:
            cmp [CS:TIMER], ax 
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
    call get_screen_position    ; Get X/Y position in DI to draw at
    mov cl, SPRITE_HEIGHT
    .next_line:
        push cx
        lodsb                   ; AL = next byte of sprite data
        xchg ax, dx             ; save off sprite data
        mov cl, SPRITE_WIDTH    ; # of pixels to draw in sprite
        .next_pixel:
            xor ax, ax          ; If drawing blank/black pixel
            dec cx
            bt dx, cx           ; Is bit in sprite set? Copy to carry
            cmovc ax, bx        ; Yes bit is set, move BX into AX (BL = color)
            mov ah, al          ; Copy color to fill out AX
            mov [di+SCREEN_WIDTH], ax
            stosw                   
        jnz .next_pixel                               

        add di, SCREEN_WIDTH*2-SPRITE_WIDTH_PIXELS
        pop cx
    loop .next_line

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
    imul di, ax, SCREEN_WIDTH  * 2  ; DI = Y value
    mov al, dh      ; AX = X value
    shl ax, 1       ; X value * 2
    add di, ax      ; DI = Y value + X value or X/Y position

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

    db 00011000b    ; Barrier bitmap
    db 00111100b 
    db 01100110b
    db 11000011b

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