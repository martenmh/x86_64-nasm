%include "macros.inc"   ; include the macros.inc file, which places all code at this location to be used later in the program.

section .data
    msg db "Hello, what would you like to input? ",0
    msg2 db "Your input: ",0

section .text
    Global _start
_start:
    print msg
    getInput
    print msg2
    print input
    exit 0          ; exit with error code 0