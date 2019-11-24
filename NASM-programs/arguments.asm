section .data
section .bss
    argc resb 2
    argvBuf resb 20

section .text
    global _start
_start:

    pop rcx
    mov [argc], rcx
    add byte [argc], 48
    cmp argc, 57
    jge


    mov rax, 1
    mov rdi, 1
    mov rsi, argc
    mov rdx, 20
    syscall

    mov rax, 60
    mov rdi, 0
    syscall