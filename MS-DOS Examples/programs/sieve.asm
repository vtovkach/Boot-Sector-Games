
; Sieve of Eratosthenes 

org 0x0100

table:       equ 0x8000
table_size:  equ 15

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


; for(bx = 2;, bx < n, bx++)
    ;   for(cx = bx + 1; cx < n; cx++)

start:
    mov si, table
    mov cx, 2
    ; 0 and 1 are false by default
    mov byte [si], 0
    add si, 1
    mov byte [si], 0
    ; table always starts at 2 
    mov si, table
    add si, 2
p0:
    mov byte [si], 1
    add si, 1
    add cx, 1
    cmp cx, table_size
    jl p0
    ; reset table and $cx
    mov si, table
    add si, 3
    mov cx, 3 ; $cx : j
    ; set i to first p; Sieve of Eratosthenes 
org 0x0100

table:       equ 0x8000
table_size:  equ 15

; 0 false
; 1 true

; Steps:
; 1) Create a table from 0 to n–1.
;    Set index 0 and 1 false; indices 2..n–1 true.
; 2) For each prime k (in BX), mark its multiples as false.
; 3) When k >= table_size, print all indices with value 1.

start:
    mov si, table
    mov cx, 2
    ; 0 and 1 are false by default
    mov byte [si], 0
    add si, 1
    mov byte [si], 0
    ; table always starts at 2 
    mov si, table
    add si, 2
p0:
    mov byte [si], 1       ; mark index as true
    add si, 1
    add cx, 1
    cmp cx, table_size
    jl p0

    ; reset table pointer and set candidate j = 3
    mov si, table
    add si, 3
    mov cx, 3           ; cx: candidate (j)
    mov bx, 2           ; bx: current prime (i)
    jmp p2

; --------------------------------------------------
; p2: Divide candidate (in CX) by current prime (in BX)
p2:
    mov ax, cx
    mov dx, 0
    div bx             ; AX: quotient, DX: remainder
    cmp dx, 0
    je mark          ; if divisible, mark candidate as composite
    jmp test_j

mark:
    mov byte [si], 0  ; mark candidate composite
    jmp test_j

; --------------------------------------------------
; test_j: Check if candidate index (CX) is within table bounds.
test_j:
    cmp cx, table_size
    jb inc_j         ; if CX < table_size, continue inner loop
    ; otherwise, finish inner loop and select next prime:
    mov cx, bx
    add cx, 1
    mov si, table
    add si, cx
    jmp inc_i

inc_j:
    add cx, 1
    add si, 1
    jmp p2

; --------------------------------------------------
; inc_i: Search for next candidate that is still marked true
;         to become the next prime (BX).
inc_i:
    mov al, [si]
    cmp al, 1
    je inc_i_i
    add cx, 1
    add si, 1
    jmp inc_i

inc_i_i:
    mov bx, cx       ; found next prime candidate; update BX
    jmp test_i

; --------------------------------------------------
; test_i: If BX (the current prime) is still less than table_size, 
;         then start another marking pass. Otherwise, go to print.
test_i:
    cmp bx, table_size
    jl prepare_next_iteration
    ; no more primes to process: prepare printing
    mov si, table
    mov cx, 0
    jmp test_print

prepare_next_iteration:
    ; set candidate to BX+1
    mov si, table
    mov cx, bx
    add cx, 1
    add si, cx
    jmp p2

; --------------------------------------------------
; Printing loop: iterate through table indices 0..table_size-1
test_print:
    cmp cx, table_size
    jb print_primes
    jmp exit

print_primes:
    cmp byte [si], 1
    je print
    jmp inc_print

print:
    mov ax, cx
    call display_number
    mov ax, 0xA
    call display_letter
    mov ax, 0xD
    call display_letter
inc_print:
    add si, 1
    add cx, 1
    jmp test_print

exit:
    int 0x20

; --------------------------------------------------
; Display routines:
display_letter:
    push ax
    push bx
    push cx
    push dx 
    push si
    push di 
    mov ah, 0x0e    ; BIOS teletype function
    mov bx, 0x000f  ; page 0, attribute
    int 0x10
    pop di 
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

read_keyboard:
    push bx
    push cx
    push dx 
    push si
    push di 
    mov ah, 0x00
    int 0x16
    pop di
    pop si 
    pop dx 
    pop cx 
    pop bx 
    ret

display_number:
    mov dx, 0
    mov cx, 10
    div cx           ; divide AX by 10
    push dx 
    cmp ax, 0 
    je display_number_1
    call display_number
display_number_1:
    pop ax
    add al, '0'
    call display_letter
    ret. 
    ; jump p2
    cmp bx, table_size
    jl prepare_next_iteration
    ; prepare si and cx for print 
    mov si, table 
    mov cx, 0 
    jmp print_primes

prepare_next_iteration:
    ; prepare next iteration 
    mov si, table 
    mov cx, bx 
    add cx, 1 
    add si, cx 
    jmp p2

test_j:
    ; mistake first incrment then check 
    cmp cx, table_size
    jl inc_j
    ; prepare for inc_i
    mov cx, bx
    add cx, 1
    mov si, table 
    add si, cx 
    jmp inc_i

inc_j:
    add cx, 1
    add si, 1
    jmp p2

inc_i:
    ; check [si] == 0
    mov al, [si]
    cmp al, 1
    je inc_i_i
    add cx, 1 
    add si, 1 
    jmp inc_i

inc_i_i:
    mov bx, cx
    jmp test_i

; j / i : cx / bx 

; $bx : i
p2:
    mov ax, cx 
    mov dx, 0
    div bx
    ; AX: Quotient, DX: Remainder 
    cmp dx, 0
    je mark
    jmp test_j
mark:
    mov byte [si], 0
    jmp test_j

test_print:
    cmp cx, table_size
    jl print_primes
    jmp exit
print_primes:
    cmp byte [si], 1
    je print
    jmp inc_print

print:
    mov ax, cx
    call display_number
    mov ax, 0xA
    call display_letter
    mov ax, 0xD
    call display_letter
inc_print:
    add si, 1
    add cx, 1
    jmp test_print

exit:
    ; leave loop after everuthing is done
    int 0x20


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