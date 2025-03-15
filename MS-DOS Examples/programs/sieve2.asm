; Sieve of Eratosthenes – “My Version”
; Finds primes less than table_size.
; Assumptions:
;   - table is at address 0x8000.
;   - table_size is defined (here 15 means we test numbers 2..14).
;   - The BIOS routines display_letter and display_number are provided.
;   - This code is assembled for a .COM file (org 0x0100).

org 0x0100

table       equ 0x8000
table_size  equ 20          ; test numbers 2 .. 14

;--------------------------------------------------
; 1. Initialize the table:
;    For numbers 2..table_size-1, set the table entries to 1 (true).
;    The table index for number N is (N - 2).
start:
    mov cx, table_size - 2   ; There are (table_size - 2) numbers (from 2 to table_size-1)
    mov di, table
init_loop:
    mov byte [di], 1         ; assume number is prime
    inc di
    loop init_loop

;--------------------------------------------------
; 2. Outer loop: for each number p (starting at 2) that is still marked prime,
;    mark its multiples as composite.
;    We'll use BX for p.
    mov bx, 2                ; p = 2

outer_loop:
    ; Stop outer loop if p*p >= table_size.
    mov ax, bx
    mul bx                   ; AX = p*p
    cmp ax, table_size
    jae print_results        ; if p*p >= table_size, we are done

    ; Check if table entry for p (index = p - 2) is still true.
    mov si, bx
    sub si, 2               ; SI = index for p
    mov al, [table + si]
    cmp al, 0
    je next_prime           ; if p is marked composite, skip marking multiples

    ; Inner loop: mark multiples of p.
    ; Start j = p*p.
    mov ax, bx
    mul bx                  ; AX = p*p
    mov dx, ax              ; DX = j = p*p
inner_loop:
    cmp dx, table_size      ; while j < table_size...
    jae next_prime_inner
    ; Compute table index for j: index = j - 2.
    mov si, dx
    sub si, 2
    mov byte [table + si], 0 ; mark j composite
    add dx, bx              ; j = j + p
    jmp inner_loop
next_prime_inner:
    ; Get next candidate for p.
next_prime:
    inc bx
    cmp bx, table_size
    jb outer_loop

;--------------------------------------------------
; 3. Print the primes.
;    For each number N from 2 to table_size-1, if table[N-2] is 1, print N.
print_results:
    ; Set up: CX = count of numbers, SI points to table, BX = current number.
    mov cx, table_size - 2  ; number of table entries
    mov si, table
    mov bx, 2               ; start at number 2

print_loop:
    cmp cx, 0
    je finish
    mov al, [si]
    cmp al, 1
    jne skip_print          ; if not prime, skip printing
    mov ax, bx
    call display_number
    mov ax, 0x20            ; print a space
    call display_letter
skip_print:
    inc bx
    inc si
    dec cx
    jmp print_loop

finish:
    int 0x20                ; exit to DOS

;--------------------------------------------------
; BIOS-based display routines.
; These routines assume:
;   - display_letter: prints the character in AL.
;   - display_number: prints the number in AX in decimal.
; (They use BIOS interrupts.)

display_letter:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ah, 0x0E            ; teletype output
    mov bx, 0x000F          ; page 0, attribute F
    int 0x10
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

display_number:
    ; Recursively display a positive number in AX.
    mov dx, 0
    mov cx, 10
    div cx                  ; AX = quotient, DX = remainder
    push dx
    cmp ax, 0
    je disp_num_pop
    call display_number
disp_num_pop:
    pop ax
    add al, '0'
    call display_letter
    ret
