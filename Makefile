AS=nasm
OBJ  = bootloader.bin kernel/kernel.bin

all:
	$(AS) -f bin kernel/main.s -o kernel/main.bin
	$(AS) -f bin kernel/systemcalls.s -o kernel/systemcalls.bin
	gcc kernel/main.bin kernel/systemcalls.bin -o kernel/kernel.bin
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
