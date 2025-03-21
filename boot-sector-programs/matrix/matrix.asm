
org 0x7c00

COLOR        equ 0x0002
BASE_CHAR    equ 0x41 ; base letter 'A'
BASE_VIDEO   equ 0xb800

start:
    ;Boot Sector Initialization 
    mov ax, cs
    mov ds, ax 

    mov ax, BASE_VIDEO
    mov es, ax

    xor di, di  
    xor dx, dx 

    mov dl, 0 ; letter offset
    mov bx, 0 ; row counter 

test_module: 
    mov al, BASE_CHAR
    mov ah, COLOR
    call print_line
    jmp end_loop

; ISSUE HERE is that print_line subroutine never returns 

%if 0
print_screen:
    ;Main Loop
    cmp dl, 26
    jl endif1 
if_1:
    mov dl, 0
endif1:
    mov al, BASE_CHAR
    add al, dl
    mov ah, COLOR
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
%endif

end_loop:
    jmp end_loop


print_line: 
    ; TODO
    ; subroutine to print a line
    ; subroutine accepts already prepared ax register
    mov cx, 80 ; columnt counter 
    stosw
    ; iterate until cx is 0
    loop print_line
    ret 

times 510-($-$$) db 0
db 0x55, 0xaa 