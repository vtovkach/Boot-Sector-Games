
all:
	nasm -f bin tictactoe.asm -o tictactoe.bin


test:
	qemu-system-i386 -drive format=raw,file=tictactoe.bin

debug:
	nasm -f elf32 -g -F  dwarf tictactoe.asm -o tictactoe.o
	ld -m elf_i386 -o tictactoe tictactoe.o

do_debug:
	gdb tictactoe