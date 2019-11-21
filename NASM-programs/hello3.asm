section .text
    global _start
_start:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; standard output
    mov rsi, msg    ; msg buffer
    mov rdx, msgLen ; message length
    syscall

    call _exit

_exit:
    mov rax, 60     ; sys_exit
    mov rdi, 0      ; exit code 0
    syscall

section .data
    msg     db "Hello, World!", 10	; newline = ', 10'
    msgLen  equ  $-msg  ; calculate string length with NASM