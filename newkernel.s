bits 16
org 0x7C00
_start:
	jmp _boot
	mov ax, 0x0000          ; Stuff's about to get real
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	
test1:	db "RCkernel boot demo", 0x0D, 0x0A, 0
test2:	db "   _ __ ___ ___", 0x0D, 0x0A, 0
test3:	db "  | '__/ __/ __|", 0x0D, 0x0A, 0
test4:	db "  | | | (__\__ \_", 0x0D, 0x0A, 0
test5:	db "  |_|  \___|___(_) Software done worse.", 0x0D, 0x0A, 0x0A, 0x0A, 0x0A, 0
final:	db "Press any key to boot RCKernel", 0x0D, 0
CAT:	db ":3", 0
newlinec: db "", 0x0D, 0x0A, 0

	%macro getch 0
	xor ax, ax
	int 0x16
	%endmacro

input:
	mov ah, 0
	int 0x16	
	cmp al, 0x0D
	je newline
	mov ah, 0x0E
	int 0x10
	stosb
	inc cl
	jmp input
	
newline:
	mov ah, 0x0E
	mov al, 0x0D
	int 0x10
	mov al, 0x0A
	int 0x10
	mov al, '#'
	int 0x10
	jmp comparisonchamber

comparisonchamber:
	cmp di, CAT
	je fun
	
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
		
_boot:
	vwritetext test1
	vwritetext test2
	vwritetext test3
	vwritetext test4
	vwritetext test5
	vwritetext final
	getch
	vwritetext newlinec
	call input
	jmp fun
fun:
	vwritetext CAT
	jmp fun
	
times 510 - ($-$$) db 0
dw 0xAA55
