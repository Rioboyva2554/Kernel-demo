				
; Won't be fully posix compatible
%include "kernel/syscalls.inc"
;syscall handling: 
global setgdt
gdt:
gdt_null:
dq 0
gdt_code:
	dw 0FFFFh
	dw 0
	db 0
	db 10011010b
	db 11001111b
	db 0
gdt_data:
	dw 0FFFFh
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0
gdt_end:
gtd_desc:
   db gdt_end - gdt
	dw gdt
	cli
gdtr DW 0
     DD 0 

setgdt:
   xor   eax, eax
   mov   ax, ds
   shl   eax, 4
   add   eax, gdt
   mov   [gdtr + 2], eax
   mov   eax, gdt_end
   sub   eax, gdt
   mov   [gdtr], ax
   lgdt  [gdtr]
   ret
;Systemcalls:
;The system call number will be  placed in the eax register, and the arguments are passed in the order ebx, ecx, edx, esi, edi, and ebp. Like with linux 
	
;sys call num 0
sys_read:
	mov ah, 0
	int 0x16
	
	cmp al, 0x08
	je .backspace
	
	cmp al, 0x0E
	ret cl
	
	mov ah, 0x0E
	int 0x10
	stosb
	inc cl
	jmp sys_read
	
.backspace:
	; checks if first line
	cmp cl, 0
	je read
	; if not:
	dec di
	mov byte [di], 0
	dec cl
	; removing character on screen
	mov ah, 0x0E
	mov al, 0x08
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 0x08
	int 0x10
	jmp sys_read

; sys call num 1
sys_write:
	lea si, di
	call .print
.print:
	lodsb
	or al, al
	jz .finish
	mov ah, 0x0e
	int 0x10
	jmp .print

.finish:
	ret
	
