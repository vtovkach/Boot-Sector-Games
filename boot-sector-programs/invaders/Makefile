
all:
	nasm -f bin invaders.asm -o invaders.bin 

test:
	qemu-system-i386 -drive format=raw,file=invaders.bin