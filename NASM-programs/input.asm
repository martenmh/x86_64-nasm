
section .text
    global _start
_start:

    call _printText1
    call _getName
    call _printText2
    call _printName

    mov rax, 60
    mov rdi, 0
    syscall

_printText1:
    mov rax, 1
    mov rdi, 1
    mov rdx, 19
    mov rsi, startingMsg
    syscall
    ret

_printText2:
    mov rax, 1
    mov rdi, 1
    mov rdx, 7
    mov rsi, hello
    syscall
    ret

_printName:
    mov rax, 1
    mov rdi, 1
    mov rdx, 16
    mov rsi, name
    syscall
    ret

_getName:
    mov rax, 0 ; get input
    mov rdi, 0 ; standard input
    mov rsi, name
    mov rdx, 16
    syscall
    ret

section .bss ; reserve space for name
    name resb 16    ; reserve 16 bytes

section .data
    startingMsg db "What is your name? "
    startingMsgLen equ $-startingMsg
    hello db "Hello, "
    helloLen equ $-hello
