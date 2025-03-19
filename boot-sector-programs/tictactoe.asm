
org 0x7c00

start:
    ; Setup Vide Mode 80x25
    mov ax, 0x0003
    int 0x10
    ; Initialize Video Buffer Address 
    mov ax, 0x07c0
    mov ds, ax 
    mov ax, 0xb800
    mov es, ax 
    
    xor di, di

    mov al, 'H'
    mov ah, 0x1E
    stosw 

    mov al, 'i'
    mov ah, 0x1E
    stosw 

    mov ax, '!'
    mov ah, 0x1E
    stosw

    mov bx, string

print_loop:
    mov al, [bx]
    cmp al, 0
    je end
    mov ah, 0x1e
    stosw
    inc bx 
    jmp print_loop

end:
    jmp end
    
string: db "Hello world!", 0

times 510-($-$$) db 0 ; Fills boot sector (510 bytes)
db  0x55, 0xaa 

; indexes are half bytes 
;     32 10
; A = ## ##
; A[0:1] - Letter 
; A[2] - foreground 
; A[3] - background 