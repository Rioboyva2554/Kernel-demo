; mostly gdt stuff for now
%include "kernel/syscalls.s"
loadgdt:
	cli
	call setgdt
