_start:
	mov ah, 0x0e
	mov al, 'Y'
	int 0x10
times 510 - ($-$$) db 0
