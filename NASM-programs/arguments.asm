




%macro printVal 1
    %%printVal:
        mov rax, %1
        mov rcx, valBuf
        mov qword[rcx], 10
        inc rcx
        mov [bufPtr], rcx

    %%writeToBufferLoop:
        xor rdx, rdx        ; zero out rdx =>  0101 0101 => 0 0 = 0, 1 1 = 0.. etc.
        mov rcx, [bufPtr]   ; restore rcx

        mov rbx, 10
        div rbx             ; rax / rbx ( 503 / 10 )
        add rdx, 48
        mov [rcx], dl      ; rdx hols the remainder, store it in the buffer.
        inc rcx             ; point rcx to the next buffer character

        mov [bufPtr], rcx

        cmp rax, 0          ; if rax != 0 => goto _writeToBufferLoop
        jne %%writeToBufferLoop



    %%storeReversedLoop:
        mov rcx, [bufPtr]    ; restore bufPtr into rcx

        mov rax, 1                  ; sys_write
        mov rdi, 1                  ; standard input
        mov rsi, rcx                ; set source index
        mov rdx, 1                  ; write 1 character
        syscall

        mov rcx, [bufPtr]    ; restore bufPtr into rcx
        dec rcx                     ; point to the "next" (previous) character in the buffer
        mov [bufPtr], rcx    ; store rcx

        cmp rcx, valBuf         ; if rcx >= digitSpace[0] goto _printRAXLoop
        ; Keep printing values until the newline character (digitSpace[0]) is hit
        jge %%storeReversedLoop


%endmacro

%macro exit 1       ; create a macro with input of error code
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro




section .bss
    valBuf resb 2       ; reserve 2 bytes for argument counter ( i've got 99 arguments but.. [ insert something funny ] )
    bufPtr resb 8       ; reserve 4 bytes, ( the same as the amount of bytes in an int on my machine )
    argc resb 3
    args resb 100

section .data
    newLine db 10,0
    NEArguments db `arguments: missing operand,\nTry 'argument --help' for more information.`,10,0
    TMArguments db `arguments: too many operands,\nTry 'argument --help' for more information.`,10,0
    NEArgLen equ $-NEArguments
    TMArgLen equ $-TMArguments



;%include "macros.inc"


; 503
; 503 / 10 = 50 R 3
; 50 / 10 = 5 R 0
; 5 / 10 = 0 R 5

section .text
    Global _start
_start:

    pop rax     ; pop argc into rax
    printVal rax


    pop rax

    mov [args], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, [args]
    mov rdx, 8
    syscall


        mov rax, 1
        mov rdi, 1
        mov rsi, newLine
        mov rdx, 1
        syscall

        pop rax

        mov [args], rax

        mov rax, 1
        mov rdi, 1
        mov rsi, [args]
        mov rdx, 8
        syscall



        mov rax, 1
        mov rdi, 1
        mov rsi, newLine
        mov rdx, 1
        syscall

     exit 0


_printNotEnoughArguments:
    mov rax, 1
    mov rdi, 1
    mov rsi, NEArguments
    mov rdx, NEArgLen
    syscall
    exit 1

_printTooManyArguments:
    mov rax, 1
    mov rdi, 1
    mov rsi, TMArguments
    mov rdx, TMArgLen
    syscall
    exit 1

