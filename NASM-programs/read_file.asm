%include "macros.inc"

section .bss
    filename resb 100
    text resb 1000

section .data
    newLine db 10,0

section .text
    Global _start
_start:

    pop rax                 ; pop the first 2 values, as they are not of interest
    pop rax
    pop rax
    mov [filename], rax     ; place the third value into filename

    mov rax, 2              ; sys_read
    mov rdi, [filename]
    mov rsi, 0              ; O_RDONLY
    mov rdx, 0644o          ; chmod 664
    syscall

    mov rdi, rax            ; rdi = file descriptor
    mov rax, 0              ; sys_read
    mov rsi, text           ; buffer
    mov rdx, 1000           ; bytes to be read
    syscall

    mov rax, 3              ; sys_close
    pop rdi                 ; pop the file descriptor into rdi
    syscall

    mov rax, 1              ; sys_print
    mov rdi, 1              ; std out
    mov rsi, text           ; use buffer
    mov rdx, 1000           ; bytes to be printed
    syscall

    mov rax, 1              ; print new line
    mov rdi, 1
    mov rsi, newLine
    mov rdx, 1
    syscall
    exit 0