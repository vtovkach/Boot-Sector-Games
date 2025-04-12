
all:
	nasm -f bin sprite_drawing.asm -o s_draw.bin 

test:
	qemu-system-i386 -drive format=raw,file=s_draw.bin