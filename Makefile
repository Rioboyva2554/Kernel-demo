AS=nasm
OBJ  = bootloader.bin kernel/kernel.bin

all:
	$(AS) -f elf kernel/main.s -o kernel/main.o
	$(AS) -f elf kernel/syscalls.s -o kernel/syscalls.o
	ld kernel/main.o kernel/syscalls.o -o kernel/kernel.bin --oformat binary
	$(AS) -f bin bootloader.s -o bootloader.bin

disk:
	dd if=/dev/zero of=test.img bs=512 count=2880
	dd if=bootloader.bin of=test.img conv=notrunc
	dd if=kernel/kernel.bin of=test.img seek=1 conv=notrunc

run:
	qemu-system-i386 -fda test.img

clean:
	rm kernel/kernel.bin
	rm bootloader.bin
	rm test.img
