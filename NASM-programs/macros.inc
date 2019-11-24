; Flags
O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2
O_CREAT equ 64
O_APPEND equ 1024
O_DIRECTORY equ 65536
O_PATH equ 2097152
O_TMPFILE equ 4194304


SYS_READ equ 0      ; define sys_read
SYS_WRITE equ 1     ; define sys_write
SYS_OPEN equ 2      ; define sys_open
SYS_CLOSE equ 3     ; define sys_close
SYS_EXIT equ 60     ; define sys_exit

; file descriptor
STDIN equ 0         ; define stdin
STDOUT equ 1        ; define stdout
STDERR equ 2        ; define stderr

%macro exit 1       ; create a macro with input of error code
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

%macro print 1      ; create a macro with input of to be printed message
    mov rax, %1     ; point rax to message (char *c = &msg or char *c = msg[0])
    mov rbx, 0      ; reset rbx (only useful when using this macro more than once)
    push rax        ; push rax onto the stack

%%getStrLen:
    inc rax         ; point rax to the next character of the string
    inc rbx         ; add 1 to the string length counter
    mov cl, [rax]   ; move the value of rax (char cl = *c)
    cmp cl, 0       ; if cl is at the "null terminator"
    jne %%getStrLen ; jump to local label getStrLen if cl != 0 (ne => not equal)

    mov rax, SYS_WRITE  ; use defined sys_write
    mov rdi, STDOUT
    pop rsi             ; pop the message from the stack into rsi
    mov rdx, rbx        ; move the counter into the rdx `parameter` of sys_write (which defines the size)
    syscall
%endmacro

%macro getInput 0
    mov rax, SYS_READ   ; use sys_read
    mov rdi, STDIN      ; use standard input
    mov rsi, input      ; use input as buffer to write input to
    mov rdx, 16         ; dont write more than 16 bytes
    syscall
%endmacro

section .bss
    input resb 16       ; reserve 16 bytes for the input