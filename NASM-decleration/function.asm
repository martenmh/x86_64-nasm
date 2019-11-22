extern someFunction

section .text
someFunction:
    mov rcx, [i]
    mov rax, [i]
    ret

section .data
i: DD 5
