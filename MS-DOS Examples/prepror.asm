%line 9+1 tictactoe.asm
[org 0x0100]

board: equ 0x0300

start:
 mov bx, board
 mov cx, 9
 mov al, '1'


b09:
 mov [bx], al
 inc al
 inc bx
 loop b09
b10:
 call show_board
 call find_line
 call get_movement
 mov byte [bx], 'X'
 call show_board
 call find_line
 call get_movement
 mov byte[bx], 'O'
 jmp b10

show_board:
 mov bx, board
 call show_row
 call show_div
 mov bx, board + 3
 call show_row
 call show_div
 mov bx, board + 6
 jmp show_row
show_row:
 call show_square
 mov al, 0x7c
 call display_letter
 call show_square
 mov al, 0x7c
 call display_letter
 call show_square

show_crlf:
 mov al, 0x0d
 call display_letter
 mov al, 0x0a
 jmp display_letter
show_div:
 mov al, 0x2d
 call display_letter
 mov al, 0x2b
 call display_letter
 mov al, 0x2d
 call display_letter
 mov al, 0x2b
 call display_letter
 mov al, 0x2d
 call display_letter
 jmp show_crlf
show_square:
 mov al, [bx]
 inc bx
 jmp display_letter
get_movement:
 call read_keyboard
 cmp al, 0x1b
 je do_exit
 sub al, 0x31
 jc get_movement
 cmp al, 0x09
 jnc get_movement
 cbw
 mov bx, board
 add bx, ax
 mov al, [bx]
 cmp al, 0x40
 jnc get_movement
 call show_crlf
 ret
find_line:
 mov al, [board]
 cmp al, [board + 1]
 jne b01
 cmp al, [board + 2]
 je won
b01:
 cmp al, [board + 3]
 jne b04
 cmp al, [board + 6]
 je won
b04:
 cmp al, [board + 4]
 jne b05
 cmp al, [board + 8]
 je won
b05:
 mov al, [board + 3]
 cmp al, [board + 4]
 jne b02
 cmp al, [board + 5]
 je won
b02:
 cmp al, [board + 6]
 jne b03
 cmp al, [board + 8]
 je won
b03:
 mov al, [board + 1]
 cmp al, [board + 4]
 jne b06
 cmp al, [board + 7]
 je won
b06:
 mov al, [board + 2]
 cmp al, [board + 5]
 jne b07
 cmp al, [board + 8]
 je won
b07:
 cmp al, [board + 4]
 jne b08
 cmp al, [board + 6]
 je won
b08:
 ret
won:
 call display_letter
 mov al, 0x20
 call display_letter
 mov al, 'w'
 call display_letter
 mov al, 'i'
 call display_letter
 mov al, 'n'
 call display_letter
 mov al, 's'
 call display_letter

 mov al, 0x0d
 call display_letter
 mov al, 0x0a
 call display_letter
do_exit:
 int 0x20

display_letter:
 push ax
 push bx
 push cx
 push dx
 push si
 push di
 mov ah, 0x0e
 mov bx, 0x000f
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
