%include "macros.inc"

section .data
    filename db "file.txt",0    ; create null terminated string for sys_open
    text db "Well, hello there.", 10
    textLen equ $-text          ; calculate the string length of the text variable

section .text
    Global _start
_start:
    ; Open
    mov rax, SYS_OPEN           ; sys_open ID
    mov rdi, filename           ; pointer to filename with a null terminator
    mov rsi, O_CREAT+O_WRONLY   ; set to create file
    mov rdx, 0644o              ; with permission 644
    syscall

    ; Write
    mov rdi, rax                ; get file descriptor from rax because of the previous syscall (assuming sys_open was successful)
    mov rax, SYS_WRITE          ; sys_write ID
    mov rsi, text               ; pointer to text
    mov rdx, textLen            ; the number of bytes to write
    syscall

    ; Close
    mov rax, SYS_CLOSE          ; sys_close ID
    pop rdi                     ; this is the file descriptor of the file to close, it assumes it is on the top of the stack
    syscall

    exit 0

