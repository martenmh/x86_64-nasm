
section .text
    global _start
_start:
    ; if rax < 10 => print("rax is smaller than 10")
    ; if rax > 10 => print("rax is larger than 10")
    ; if rax == 10 => print("rax is equal to 10")
    mov rax, 10
    cmp rax, 10
    jl _print1      ; jump if smaller
    jg _print2      ; jump if greater
    je _print3      ; jump if equal

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_print1:
    mov rsi, msg1
    mov rdx, 23
    call _print

_print2:
    mov rsi, msg2
    mov rdx, 22
    call _print

_print3:
    mov rsi, msg3
    mov rdx, 19
    call _print

_print:
    mov rax, 1
    mov rdi, 1
    syscall
    call _exit

section .data
msg1 db "rax is smaller than 10",10
msg2 db "rax is larger than 10", 10
msg3 db "rax is equal to 10",10