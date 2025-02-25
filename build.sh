nasm -f bin newkernel.s -o kernel.bin
qemu-system-i386 kernel.bin
