section .text
    global _start
_start:
    mov rax, text
    call _print

_exit:
    mov rax, 60     ; sys_exit
    mov rdi, 0      ; exit code 0
    syscall

;input: rax as pointer to string
;output: print string at rax
_print:
    push rax    ; save rax for later
    mov rbx, 0  ; rbx as counter

_printLoop:
    inc rax         ; point to next value in the string
    inc rbx         ; add 1 to the counter
    mov cl, [rax]   ; move value of the character to lower byte of cl
    cmp cl, 0       ; if cl == 0 it is the end (null terminated string)
    jne _printLoop  ; loop until cl hits the null terminated string

    mov rax, 1      ; sys_write ( just print it )
    mov rdi, 1
    pop rsi         ; pop the pointer from rax to rsi (argument for sys_write)
    mov rdx, rbx
    syscall
    ret

section .data
    text db "Hello, World!", 10,0   ; ,0 for null terminating string