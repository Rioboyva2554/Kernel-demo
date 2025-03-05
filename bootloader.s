bits 16
org 0x7C00
	; Screw genuinely helpful standards like multiboot!
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
	call printtxt
	%endmacro
	
	printtxt:
	lodsb
	or al, al
	jz writetextout
	mov ah, 0x0e
	int 0x10
	jmp printtxt

	writetextout:
	ret
_start:
	jmp conf
	; Bios Parameter block:
	DB "RCKernel-OS" 	;OEM id
	DW 0x0200		;Bytes per sector
	DB 0x01			;Sectors per cluster
	DW 0x0001		;Reserved Sectors
	DB 0x02			;Total fats
	DW 0x00E0		;Max root entries
	DW 0x0B40		;Total Sectors (smol)
	DB 0xF0 		;Media descriptor 
	DW 0x0009               ;Sectors per File Allocation Table (FAT)
	DW 0x0012               ;Sectors per Track
        DW 0x0002               ;number of heads 
	DD 0x00000000		;Hidden Sectors
	DD 0x00000000		;Total Sectors (big) 
	DB 0x00			;Drive Number
	DB 0x00			;flags
	DB 0x29			;signature
	DD 0x00010203		;Volume serial
	DB "RCOSv1"		;Volume Label
	DB "FAT12"		;System ID

conf:

	vwritetext test1
	vwritetext test2
	vwritetext test3
	vwritetext test4
	vwritetext test5
	vwritetext final
	vwritetext done
	call boot
	jmp $
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
