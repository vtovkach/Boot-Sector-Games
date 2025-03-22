
; matrix window prog
org 0x7c00

COLOR        equ 0x0002
BASE_CHAR    equ 0x41 ; base letter 'A'
BASE_VIDEO   equ 0xb800
STACK_BASE   equ 0x7e00

start:
    ; Boot Sector Initialization 
    ; Set up data segment 
    mov ax, cs
    mov ds, ax 

    ; Set up extra segment at video memory 
    mov ax, BASE_VIDEO
    mov es, ax

    ; Set up stack segment 
    mov ax, STACK_BASE
    mov ss, ax 

    ; Clear $di, $dx 
    xor di, di  
    xor dx, dx 

    mov dl, 0 ; letter offset
    mov bx, 0 ; row counter 

print_screen:
    ;Main Loop
    cmp dl, 26
    jl endif1 
if_1:
    ; adjust letter offset if dl >= 26
    mov dl, 0
endif1:
    mov al, BASE_CHAR
    add al, dl
    mov ah, COLOR
    mov cx, 80 
    call print_line

    inc bx ; increment row counter 
    inc dl ; letter offset 
    cmp bx, 25
    jl endif2
if_2:
    mov bx, 0 
    mov ax, BASE_VIDEO
    mov es, ax
    xor di, di 
endif2:
    jmp print_screen

end_loop:
    jmp end_loop

print_line: 
    ; subroutine to print a line
    ; args: $cx loop counter, $ax letter to print 
    stosw

    push cx
    call delay_exec
    pop cx 

    loop print_line
    ret 

delay_exec:
    ; subroutine to create a visual delay 
    mov cx, 0xffff
delay_loop:
    push cx
    mov cx, 0x0002
    call delay_loop_level2
    pop cx 
    loop delay_loop
    ret

delay_loop_level2:
    ; second level loop, to increase delay 
    loop delay_loop_level2
    ret

times 510-($-$$) db 0
dw 0xaa55