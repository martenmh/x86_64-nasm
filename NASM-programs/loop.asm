
section .text
    global _start
_start:
    ; for(int i = 0; i < 10; i++) print(i)
    mov r10, 0      ; set i = 0
    call _loop      ; start for loop

    mov rax, 60     ; sys_exit with error code 0
    mov rdi, 0
    syscall

_exec:
    call _print     ; print the number
    inc r10         ; i++
    jmp _loop       ; go back to the

_loop:
    cmp r10, 10     ; i < 10 ?
    jl _exec        ; if i < 10 => _exec()
    ret

_print:
    mov [i], r10b       ; place lower byte of r10 in i (because i is a byte)
    add byte [i], 48    ; add 48 to it because ASCII '0' = 48
    mov rax, 1          ; sys_write
    mov rdi, 1
    mov rsi, i
    mov rdx, 2
    syscall
    ret

section .data
    i db 0,10       ; define byte i