; mostly gdt stuff for now
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
   
loadgdt:
	cli
	call setgdt
