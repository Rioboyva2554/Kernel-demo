nasm -f bin bootloader.s -o bootloader.bin
nasm -f bin finkernel.s -o finkernel.bin
sudo dd if=/dev/zero of=test.img bs=512 count=2880
sudo chmod 7777 test.img
dd if=bootloader.bin of=test.img conv=notrunc
dd if=finkernel.bin of=test.img seek=1 conv=notrunc
qemu-system-i386 -fda test.img

