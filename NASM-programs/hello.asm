;-----------------------------------;
; Hello World in NASM               ;
; Compile & link for linux x86_64   ;
;                                   ;
; nasm -f elf64 file.asm            ;
; ld file.o -m elf_x86_64           ;
;-----------------------------------;

	global _start
	section	.text   ; section for code
_start:
	mov	rax, 1		; sys_write
	mov	rsi, msg	; write hello world
	mov	rdx, 14		; write 14 characters
	mov	rdi, 1		; standard output
	syscall
	mov	rax, 60		; sys_exit
	mov	rdi, 0		; exit code
	syscall

	section	.data   ; section for static constant variables
msg:	db "Hello, World!", 10	; newline = ', 10'
