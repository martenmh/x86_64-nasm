section .bss
    digitSpace resb 100     ; buffer for the output
    digitSpacePos resb 8    ; Pointer to the current character in digitSpace

; Small note. Why use digitSpacePos instead of just rcx?
; after using a sys_write syscall the rcx register will be changed implicitly,
; so you need to "back it up" into another variable

%include "macros.inc"

section .text
    Global _start
_start:
    ; How the algorithm works:
    ; 503 / 10 = 50 R 3
    ;       store 3
    ; 50 / 10 = 5 R 0
    ;       store 0
    ; 50 / 10 = 0 R 5
    ;       store 5

    ; = 305
    ; print backwards = 503

    mov rax, 503
    call _printRAX
    exit 0

_printRAX:
    mov rcx, digitSpace         ; mov address of digitSpace into rcx
    mov rbx, 10
    mov [rcx], rbx              ; write a new line character (ASCII '0' = 10)
    inc rcx                     ; point rcx to the next byte for writing
    mov [digitSpacePos], rcx    ; point digitSpacePos to the next byte ( store rcx )

_getRAXValueLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx         ; rax / rbx (503 / 10) = 50 Rest 3
    ; As noted, rdx stores the Rest value if rdx is 0 before the div instruction

    add rdx, 48     ; make it like the ASCII number ( because ASCII numbers start at 48 )

    mov rcx, [digitSpacePos]    ; place digitSpacePos back in rcx ( restore digitSpacePos into rcx)
    mov [rcx], dl               ; write the character from rdx into the digitSpace buffer
    inc rcx                     ; point to the next byte for writing
    mov [digitSpacePos], rcx    ; point digitSpacePos to the next byte
    cmp rax, 0                  ; if rax != 0 ( because it is null terminating string ) => goto _getRAXValueLoop
    ; Keep writing values into the buffer until the null terminator is reached.
    jne _getRAXValueLoop

_printRAXLoop:
    mov rcx, [digitSpacePos]    ; restore digitSpacePos into rcx

    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; standard input
    mov rsi, rcx                ; set source index
    mov rdx, 1                  ; write 1 character
    syscall

    mov rcx, [digitSpacePos]    ; restore digitSpacePos into rcx
    dec rcx                     ; point to the "next" (previous) character in the buffer
    mov [digitSpacePos], rcx    ; store rcx

    cmp rcx, digitSpace         ; if rcx >= digitSpace[0] goto _printRAXLoop
    ; Keep printing values until the newline character (digitSpace[0]) is hit
    jge _printRAXLoop           ; after the new line character has been hit (when rcx == digitSpace)
    ; rcx will be 0 ( because resb zeroes out all reserved space) which is smaller than digitSpace.
    ; So rcx < digitSpace and jge won't cause the program to go back to _printRAXLoop

    ret                         ; return where called for exit