
; Sieve of Eratosthenes 

org 0x0100

table:       equ 0x8000
table_size:  equ 20

; 0 false
; 1 true

    ; 1.) Create a table starting from 2, n-size
    ; 2.) Set every position at table to true
    ; - 0 false
    ; - 1 true 
    ; 3.) Set k to be a prime $bx
    ; 4.) Mark every divisible number by k as false 
    ; 5.) Set k to next prime (fist not marked as false)
    ; 6.) Go to step 4 again, 
    ; 7.) Stop when k is greater than sqrt(n)
    ; 8.) Print all numbers marked true (1)


start:
    mov si, table
    mov cx, 0 

p0:
    mov byte [si], 1
    add si, 1
    add cx, 1
    cmp cx, table_size
    jl p0
    mov bx, 2
    jmp p2
p1:
    ; will figure it out what to put here

    ; for(bx = 2;, bx < n, bx++)
    ;   for(cx = bx + 1; cx < n; cx++)
    

test_p2:
    cmp bx, table_size
    jnle exit
increment:
    add bx 1
p2:
    mov cx, bx
    add cx, 1
    mov dx, 0
    mov ax, cx
    div bx
    cmp dx, 0
    je mark
    

mark:
    mov byte [si], 0
    jmp test_p2

exit:
    ; leave loop after everuthing is done







display_letter:
    push ax
    push bx
    push cx
    push dx 
    push si
    push di 
    mov  ah, 0x0e    ; Load AH with code for terminal output 
    mov  bx, 0x000f  ; Load BH page zero and BL color (graphic mode)
    int  0x10        ; Call BIOS for displaying one letter 
    pop di 
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret             ; Return to caller

read_keyboard:
    push bx
    push cx
    push dx 
    push si
    push di 
    mov  ah, 0x00   ; Load Ah with code for keyboard read 
    int  0x16       ; Call the BIOS for reading keyboard
    pop di
    pop si 
    pop dx 
    pop cx 
    pop bx 
    ret             ; Return to caller 

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
 