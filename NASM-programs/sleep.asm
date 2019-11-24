section .data
    delay dq 5,500000000    ; set tv_sec and tv_nsec values to initialize timespec struct
    sleepMsg db "Sleeping 5.5 seconds...",10,0
    sleepMsgLen equ $-sleepMsg
    stopMsg db "quit",10,0
    stopMsgLen equ $-stopMsg

section .text
    global _start
_start:

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, sleepMsg       ; point to message buffer
    mov rdx, sleepMsgLen    ; size to be written
    syscall

    mov rax, 35             ; sys_nanosleep
    mov rdi, delay          ; amount ( pointer to initialized timespec struct )
    mov rsi, 0
    syscall

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, stopMsg        ; point to message buffer
    mov rdx, stopMsgLen     ; size to write
    syscall

    mov rax, 60             ; sys_exit
    mov rdi, 0              ; exit code
    syscall
