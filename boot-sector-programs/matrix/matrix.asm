
org 0x7c00

COLOR equ 0x0002

start:
    mov ax, cs
    mov ds, ax 

    mov ax, 0x0003
    int 0x10

    mov ax, 0xb800
    mov es, ax

    xor di, di 
    mov si, msg
print_msg:
    mov al, [si]
    cmp al, 0
    je inf_loop
    mov ah, COLOR
    stosw  
    inc si
    jmp print_msg

inf_loop:
    jmp inf_loop

msg db "Hello World", 0

times 510-($-$$) db 0
dw 0x55aa