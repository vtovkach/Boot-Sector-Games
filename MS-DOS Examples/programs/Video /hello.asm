
org 0x0100

start:
    mov ax, 0x0002 
    int 0x10 ; set video mode 
    mov ax, 0xb800
    mov ds, ax 
    mov es, ax 
    cld ; clear direction bit 
    xor di, di ; clear di register 
    mov ax, 0x1a48 ; color:ascii
    stosw
    mov ax, 0x1b45 ; color:ascii
    stosw 
    mov ax, 0x1c4c 
    stosw 
    mov ax, 0x1d4c
    stosw 
    mov ax, 0x1e4f
    stosw 

l0:
    jmp l0