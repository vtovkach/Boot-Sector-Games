
org 0x0100

start: 
    ; Setup video mode 80x25
    mov ax, 0x0002 
    int 0x10 
    ; Setup data segment
    mov ax, 0xb800 ; video base address
    mov ds, ax
    mov es, ax
    
main_loop:
    mov ah, 0x00
    int 0x1a ; get current date and time 
    mov al, dl
    test al, 0x40
    je m2
    not al
m2:
    and al, 0x3f
    sub al, 0x20
    cbw ; extend al to word
    mov cx, ax 
    mov di, 0x0000
    mov dh, 0
m0: mov dl, 0
m1: push dx
    mov bx, sin_table
    mov al, dh
    shl al, 1
    and al, 0x3f
    cs xlat 
    cbw 
    push ax 

    mov al, dl
    and al, 0x3f 
    cs xlat 
    cbw 
    pop  dx
    add ax, dx 
    add ax, cx 
    mov ah, al
    mov al, 0x2a
    mov [di], ax
    add di, 2
    pop dx
    inc  dl 
    cmp dl, 80
    jne m1
    inc dh
    cmp dh, 25
    jne m0
    mov ah, 0x01
    int 0x16 
    jne key_pressed
    jmp main_loop

key_pressed:
    int 0x20

sin_table:
    db 0, 6, 12, 19,  24, 30, 36, 41 
    db 45, 49, 53, 56, 59, 61, 63, 64
    db 64, 64, 63, 61, 59, 56, 53, 49
    db 45, 41, 36, 30, 24, 19 12, 6
    db 0, -6, -12, -19, -24, -30, -36, -41 
    db -45, -49, -53, -56, -59, -61, -63, -64
    db -64, -64, -63, -61, -59, -56, -53, -49
    db -45, -41, -36, -30, -24, -19, -12, -6