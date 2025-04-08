
all:
	nasm -f bin object_move.asm -o test.bin 

test:
	qemu-system-i386 -drive format=raw,file=test.bin