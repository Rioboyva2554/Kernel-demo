bits 16
org 0x7C00
FMBALIGN  equ  1 << 0            ; align loaded modules on page boundaries
FMEMINFO  equ  1 << 1            ; provide memory map
FVIDMODE  equ  1 << 2            ; try to set graphics mode
FLAGS     equ  FMBALIGN | FMEMINFO | FVIDMODE
MAGIC     equ  0x1BADB002
CHECKSUM  equ -(MAGIC + FLAGS)
	
test1:	db "RCkernel bootloader v0.1", 0x0D, 0x0A, 0
test2:	db "   _ __ ___ ___", 0x0D, 0x0A, 0
test3:	db "  | '__/ __/ __|", 0x0D, 0x0A, 0
test4:	db "  | | | (__\__ \_", 0x0D, 0x0A, 0
test5:	db "  |_|  \___|___(_) Software done worse.", 0x0D, 0x0A, 0x0A, 0x0A, 0x0A, 0
final:	db "Press any key to boot RCKernel", 0x0D, 0
kernelload:	db "Loading kernel...", 0
done:	db "  DONE", 0x0D, 0x0A
kernelboot:	db "Kernel loaded, booting...", 0
	%macro getch 0
	xor ax, ax
	int 0x16
	%endmacro
	
	%macro vwritetext 1
	lea si, %1
	call writetextin
	%endmacro

	writetextin:
	lodsb
	or al, al
	jz writetextout
	mov ah, 0x0e
	int 0x10
	jmp writetextin

	writetextout:
	ret
_start:
	

conf:
	mov ax, 0x0000          ; Stuff's about to get real
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	vwritetext test1
	vwritetext test2
	vwritetext test3
	vwritetext test4
	vwritetext test5
	vwritetext final
	getch
	vwritetext done
	jmp boot
boot:
	vwritetext kernelload
	mov ax, 0x1000
	mov es, ax
	xor bx, bx
	mov ah, 0x02
	mov al, 0x01
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	mov dl, 0x00
	int 0x13
	jc boot
	vwritetext done
	vwritetext kernelboot
	jmp 0x1000:0x0000
	
times 510 - ($-$$) db 0
dw 0xAA55
