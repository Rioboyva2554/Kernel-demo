				
; Won't be fully posix compatible
%include "kernel/gdt.inc"
;syscall handling: 

;Systemcalls:
;The system call number will be  placed in the eax register, and the arguments are passed in the order ebx, ecx, edx, esi, edi, and ebp. Like with linux 
	
;sys call num 0
sys_read:
	mov ah, 0
	int 0x16
	
	cmp al, 0x08
	je .backspace
	
	cmp al, 0x0E
	ret 0
	
	mov ah, 0x0E
	int 0x10
	stosb
	inc cl
	jmp sys_read
	
.backspace:
	; checks if first line
	cmp cl, 0
	je sys_read
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
	;lea si, di
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
	
