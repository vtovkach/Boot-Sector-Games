
int 0x20

display_number:
    mov dx, 0
    mov cx, 10
    div cx    ; divide ax by cx
    push dx 
    cmp ax, 0 
    je display_number_1
    call display_number

display_number_1:
    pop ax
    add al, '0'
    call display_letter
    ret  
