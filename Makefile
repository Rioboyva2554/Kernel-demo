AS = nasm

all:
  nasm -f bin newkernel.s -o kernel.bin
  qemu-system-i386 kernel.bin
compile:
  nasm -f bin newkernel.s -o kernel.bin
run:
qemu-system-i386 kernel.bin
