section .text
    global _start
_start:
    call _stackOperations
    call _printRAXDigit
    call _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_stackOperations:
    mov rax, 3
    push rax            ; push 3 on the stack
    call _printRAXDigit ; print

    push 5
    mov rax, [rsp]      ; peek at the stack and store the value in rax
    call _printRAXDigit ; print

    pop rax             ; pop the stack and store the value in rax
    call _printRAXDigit ; print


_printRAXDigit:
    add rax, 48     ; ASCII 48 = '0'
    mov [digit], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    ret

section .data
    digit db 0,10