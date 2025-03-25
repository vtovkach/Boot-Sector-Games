
all:
	nasm -f bin tictactoe.asm -o tictactoe.bin


test:
	qemu-system-i386 -drive format=raw,file=tictactoe.bin
