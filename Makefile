AS = nasm

all:
  $(AS) -f bin newkernel.s -o kernel.bin
  qemu-system-i386 kernel.bin
compile:
  $(AS) -f bin newkernel.s -o kernel.bin
run:
  qemu-system-i386 kernel.bin
