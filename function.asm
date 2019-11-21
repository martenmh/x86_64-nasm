extern someFunction

section .text
someFunction:
    mov rcx, [i]
    mov rax, [i]
    ret

section .data
i: DD 5
flo: DT 3.512
b: DW 5
a: dp
