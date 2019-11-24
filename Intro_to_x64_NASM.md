# NASM
Created by martenmh.
## Table of contents
- [NASM](#nasm)
  * [Table of contents](#table-of-contents)
  * [The NASM Language](#the-nasm-language)
  * [Registers](#registers)
      - [16 bit 8086 Registers:](#16-bit-8086-registers-)
      - [32 bit 80386 Registers:](#32-bit-80386-registers-)
      - [64 bit Pentium IV Registers:](#64-bit-pentium-iv-registers-)
  * [Operands](#operands)
      - [Register Operands](#register-operands)
      - [Memory Operands](#memory-operands)
      - [Immediate Operands](#immediate-operands)
- [Instructions with two memory operands are extremely rare.](#instructions-with-two-memory-operands-are-extremely-rare)
  * [Sections](#sections)
    + [Assembly sections](#assembly-sections)
    + [Memory sections](#memory-sections)
  * [ASM data types](#asm-data-types)
  * [Defining data & Reserving space](#defining-data---reserving-space)
  * [Some Instructions](#some-instructions)
  * [Write some NASM!](#write-some-nasm-)
      - [Defining main](#defining-main)
      - [Assembling](#assembling)
  * [Registers #2](#registers--2)
    + [Flags](#flags)
    + [Pointers](#pointers)
  * [Control flow](#control-flow)
    + [Jumps](#jumps)
    + [Comparisons](#comparisons)
    + [Comparisons & flags](#comparisons---flags)
    + [Conditional flags](#conditional-flags)
    + [Registers as pointers](#registers-as-pointers)
    + [Calls](#calls)
      - [Note: Calls are not functions and don't have to be explicitly called, they are labels to jump to, and will still run when executed by default (top to bottom).](#note--calls-are-not-functions-and-don-t-have-to-be-explicitly-called--they-are-labels-to-jump-to--and-will-still-run-when-executed-by-default--top-to-bottom-)
  * [Programs](#programs)
    + [Program: Hello World!](#program--hello-world-)
    + [Program: Get user input](#program--get-user-input)
  * [Math](#math)
      - [Note, when using the div operation, if the rdx register is not 0 then the rdx will be concated on the rax register, acting like a 128 bit register. If rdx is 0, it will hold the remainder after a div.](#note--when-using-the-div-operation--if-the-rdx-register-is-not-0-then-the-rdx-will-be-concated-on-the-rax-register--acting-like-a-128-bit-register-if-rdx-is-0--it-will-hold-the-remainder-after-a-div)
    + [How to display a digit](#how-to-display-a-digit)
    + [The Stack](#the-stack)
    + [Program: A simple for loop](#program--a-simple-for-loop)
  * [Subroutine programs](#subroutine-programs)
    + [Program: Print string v2](#program--print-string-v2)
    + [Program: Print string v3 (simple)](#program--print-string-v3--simple-)
  * [NASM macros](#nasm-macros)
    + [Syntax](#syntax)
    + [Inputs](#inputs)
    + [Local labels](#local-labels)
    + [Defining values with EQU (C/C++ Like defines)](#defining-values-with-equ--c-c---like-defines-)
    + [Including external files](#including-external-files)
    + [Program: input with macros](#program--input-with-macros)
  * [Pointers & values](#pointers---values)
  * [Program: print (more than one) numbers](#program--print--more-than-one--numbers)
    + [The program](#the-program)
    + [Debugging!](#debugging-)
    + [The program with Code explenation](#the-program-with-code-explenation)
  * [Linux](#linux)
  * [Further reading:](#further-reading-)
  * [Credits](#credits)


## The NASM Language

NASM is line-based. Most programs consist of `directives` followed by one or more `sections`. Lines can have an optional `label`. Most lines have an `instruction` followed by zero or more `operands`.

```
label:    instruction operands        ; comment
```

First some context: Registers
## Registers
#### 16 bit 8086 Registers: 
> The 8086 had 16 bit registers.
1. General purpose registers (GPR):
> You can access the GPR low and high byte with `H` & `L`
* AX
  * AH (High byte)
  * AL (Low byte)
> Windows C++ compiler expects this value to be the same after using it
> so use:
>```asm
>push rbx
>;do stuf with bx
>pop rbx
>```
* BX 
  * BH (High byte)
  * BL (Low byte) 
* CX
  * CH (High byte)
  * CL (Low byte)
* DX
  * DH (High byte)
  * DL (Low byte)
  
2. Index registers: 

* SI (For string operations, Source Index)
* DI (For string operations, Destination Index)
* BP (Base Pointer)
* SP (Stack Pointer)

3. Instruction Pointer
* IP (Point to ram where the instructions are read from)

4. Segment Registers (Deprecated, now flat memory)
* CS
* DS
* ES
* SS

5. Flags Register
* Flags (state)

#### 32 bit 80386 Registers:
>Every 16 bit register gets a 32 bit register with the prefix `E`

| bit |     |    |    |
|:----|:----|:---|:---|
| 32  | EAX |    |    |
| 16  |     | AX |    |
| 8   |     | AH | AL |

| bit |     |    |
|:----|:----|:---|
| 32  | ESI |    |
| 16  |     | SI |
* IP => EIP 
* Flags => EFlags 
* etc..

Added segment registers (Again.. these are now deprecated):
* FS 
* GS

#### 64 bit Pentium IV Registers:

> Every register gets a 32 bit register with the prefix `R`

| bit |     |     |    |    |
|:----|:----|:----|:---|:---|
| 64  | RAX |     |    |    |
| 32  |     | EAX |    |    |
| 16  |     |     | AX |    |
| 8   |     |     | AH | AL |

* IP => RIP 
* Flags => RFlags
* etc..

The 4 index registers now also get a lower byte:

| bit |     |     |    |     |
|:----|:----|:----|:---|:----|
| 64  | RSI |     |    |     |
| 32  |     | ESI |    |     |
| 16  |     |     | SI |     |
| 8   |     |     |    | SIL |

>So the lower byte of SI, DI, SP and BP can be accessed by a postfix `L`

Instruction pointer only has 32 bit & 64 bit version

| bit |     |     |
|:----|:----|:----|
| 64  | RIP |     |
| 32  |     | EIP |

Flag:

| bit |     |     |     |
|:----|:----|:----|:----|
| 64  | RFlags |     |     |
| 32  |     | EFlags |  |
| 16  |     |  | Flags |

8 new general purpose registers: 
* R8
* R9
* R10
* R11
* R12
* R13
* R14
* R15
* R16
* R17
* R18

> Instead of using RAX > EAX > AX > AH - AL, the new registers use R8 >
> R8D > R8W > R8B
* B (Byte for lower 8 bit)
* W (Word for 16 bit)
* D (DoubleWord for 32 bit)

| bit |    |     |     |     |
|:----|:---|:----|:----|:----|
| 64  | R8 |     |     |     |
| 32  |    | R8D |     |     |
| 16  |    |     | R8W |     |
| 8   |    |     |     | R8B |


> When using the 32 bit registers, the top 32 bit of the 64 bit register
> is wiped and changed to all zeros. The other bit registers don't do
> this.

## Operands

#### Register Operands
*64bit:*
R0  R1  R2  R3  R4  R5  R6  R7  R8  R9  R10  R11  R12  R13  R14  R15
RAX RCX RDX RBX RSP RBP RSI RDI

*32bit:*
R0D R1D R2D R3D R4D R5D R6D R7D R8D R9D R10D R11D R12D R13D R14D R15D
EAX ECX EDX EBX ESP EBP ESI EDI

*16bit:*
R0W R1W R2W R3W R4W R5W R6W R7W R8W R9W R10W R11W R12W R13W R14W R15W
AX  CX  DX  BX  SP  BP  SI  DI

*8bit:*
R0B R1B R2B R3B R4B R5B R6B R7B R8B R9B R10B R11B R12B R13B R14B R15B
AL  CL  DL  BL  SPL BPL SIL DIL

*And finally, there are 16 XMM registers, each 128 bits wide, named:*
XMM0 ... XMM15

#### Memory Operands

*These are the basic forms of addressing:*

    * [ number ]
    * [ reg ]
    * [ reg + reg*scale ]
    * [ reg + number ]
    * [ reg + reg*scale + number ] 

The number is called the `displacement`; the plain register is called the `base`; the register with the scale is called the `index`.


#### Immediate Operands

These can be written in many ways. Here are some examples from the official docs.
 
```
200          ; decimal
0200         ; still decimal - the leading 0 does not make it octal
0200d        ; explicitly decimal - d suffix
0d200        ; also decimal - 0d prefex
0c8h         ; hex - h suffix, but leading 0 is required because c8h looks like a var
0xc8         ; hex - the classic 0x prefix
0hc8         ; hex - for some reason NASM likes 0h
310q         ; octal - q suffix
0q310        ; octal - 0q prefix
11001000b    ; binary - b suffix
0b1100_1000  ; binary - 0b prefix, and by the way, underscores are allowed
```



> # Instructions with two memory operands are extremely rare.
> Most of the basic instructions have only the following forms:
> * add reg, reg
> * add reg, mem
> * add reg, imm
> * add mem, reg
> * add mem, imm

## Sections
source = [https://en.wikipedia.org/wiki/Data_segment](https://en.wikipedia.org/wiki/Data_segment)

> A computer program memory can be largely categorized into two sections: read-only and read-write.
> This distinction grew from early systems holding their main program in read-only memory such as Mask ROM, PROM or EEPROM. 
> As systems became more complex and programs were loaded from other media into 
> RAM instead of executing from ROM the idea that some portions of the program's memory should not be modified was retained. 
> These became the .text and .rodata segments of the program, and the remainder which could be written to divided into a number of other segments for specific tasks.

### Assembly sections
* `.data` The .data segment contains any global or static variables which have a pre-defined value and can be modified.

( Initialized data )
> The .data segment contains any global or static variables which have a pre-defined value and can be modified. 
> That is any variables that are not defined within a function (and thus can be accessed from anywhere) 
> or are defined in a function but are defined as static so they retain their address across subsequent calls

* `.bss` The BSS segment, also known as uninitialized data, is usually adjacent to the data segment.

( Uninitialized data )
> The BSS segment, also known as uninitialized data, is usually adjacent to the data segment. 
> The BSS segment contains all global variables and 
> static variables that are initialized to zero or do not have explicit initialization in source code.

* `.text` The .text section is generally for code
> The code segment, also known as a text segment or simply as text, 
> is where a portion of an object file or the corresponding section of the program's virtual address space
> that contains executable instructions is stored and is generally read-only and fixed size.
 
### Memory sections
* The heap
> The heap area commonly begins at the end of the .bss and .data segments and grows to larger addresses from there. 
> The heap area is managed by malloc, calloc, realloc, and free, 
> which may use the brk and sbrk system calls to adjust its size 
> (note that the use of brk/sbrk and a single "heap area" is not required to fulfill the contract of malloc/calloc/realloc/free; 
> they may also be implemented using mmap/munmap to reserve/unreserve potentially non-contiguous regions of virtual memory into the process' 
> virtual address space). 
> The heap area is shared by all threads, shared libraries, and dynamically loaded modules in a process. 

* The stack
> The stack area contains the program stack, a LIFO structure, typically located in the higher parts of memory. 
> A "stack pointer" register tracks the top of the stack; 
> it is adjusted each time a value is "pushed" onto the stack. 
> The set of values pushed for one function call is termed a "stack frame". 
> A stack frame consists at minimum of a return address. Automatic variables are also allocated on the stack. 

## ASM data types
Integer:
* byte (8bit)
* word (16bit)
* dword (32bit)
* qword (64bit)

Floating point: 
* real4 (single precision float, 32 bit -> 1 sign bit, 8 bit exponent,
  23 bit mantissa)
* real8 (single precision float, 64 bit -> 1 sign bit, 11bit exponent,52
  bit mantissa)
* real10 (single precision float, 80 bit -> 1 sign bit, 15 bit exponent,
  64 bit mantissa)
> real10 is mostly ignored and is only used with x87 FPU

SIMD Pointers: 
* xmmword (128 bits)
* ymmword (256 bits)
* zmmword (new data type for new CPU's)(512 bits)

>when using signed integers you want to use different instructions like
>`IDIV` & `IMUL` instead of `DIV` & `MUL` depending on the instruction

The left most bit is the sign bit, when the bit is 0 the number is
positive and negative when the bit is 1


## Defining data & Reserving space

*To place data in memory:*
``` 
      db    0x55                ; just the byte 0x55
      db    0x55,0x56,0x57      ; three bytes in succession
      db    'a',0x55            ; character constants are OK
      db    'hello',13,10,'$'   ; so are string constants
      dw    0x1234              ; 0x34 0x12
      dw    'a'                 ; 0x61 0x00 (it's just a number)
      dw    'ab'                ; 0x61 0x62 (character constant)
      dw    'abc'               ; 0x61 0x62 0x63 0x00 (string)
      dd    0x12345678          ; 0x78 0x56 0x34 0x12
      dd    1.234567e20         ; floating-point constant
      dq    0x123456789abcdef0  ; eight byte constant
      dq    1.234567e20         ; double-precision float
      dt    1.234567e20         ; extended-precision float
```

*To reserve space without initializing:*
```
buffer:         resb    64              ; reserve 64 bytes
wordvar:        resw    1               ; reserve a word
realarray:      resq    10              ; array of ten reals
```


## Some Instructions

mov x, y      	x ← y
and x, y	    x ← x and y
or x, y	        x ← x or y
xor x, y	    x ← x xor y
add x, y	    x ← x + y
sub x, y	    x ← x – y
inc x	        x ← x + 1
dec x	        x ← x – 1
syscall	        Invoke an operating system routine
db	            A pseudo-instruction that declares bytes that will be in memory when the program runs (in .data)
resb            A pseudo-instruction that reserves bytes that will be in memory when the program runs (in .bss)


## Write some NASM!
#### Defining main

*When you are running assembly without a main from another program you can define main by:*
(Example hello world)
```
          global    _start

          section   .text
_start:   mov       rax, 1                  ; system call for write
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rsi, message            ; address of string to output
          mov       rdx, 13                 ; number of bytes
          syscall                           ; invoke operating system to do the write
          mov       rax, 60                 ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall                           ; invoke operating system to exit

          section   .data
message:  db        "Hello, World", 10      ; note the newline at the end
```


When you have a main in C or C++
you only have to define global main
```
        global  main
        section .text
main:   
```
#### Assembling
Pure assembly
```
nasm -f elf64 file.asm
ld file.o -m elf_x86_64
```

C++ and Assembly 
```
nasm -f elf64 file.asm
g++ main.cpp file.o 
``` 

Running
```
./a.out
```


## Registers #2
### Flags
Flags hold a single value, either a 1 or a 0.
Each bit in the flags register is a flag, some of these are:

| Flag Symbol | Description       |
|:------------|:------------------|
| CF          | Carry             |
| PF          | Parity            |
| ZF          | Zero              |
| SF          | Sign              |
| OF          | Ofervlow          |
| AF          | Adjust            |
| IF          | Interrupt Enabled |

### Pointers

| Pointer Name | Meaning            | Description                                               |
|:-------------|:-------------------|:----------------------------------------------------------|
| rip          | Index pointer      | Points to next address to be executed in the control flow |
| rsp          | Stack pointer      | Points to the top address of the stack                    |
| rbp          | Stack base pointer | Points to the bottom of the stacl                         |

## Control flow

All code runs from top to bottom by default

The rip register hold the address of the next instruction to be executed, after each instruction it is incremented by 1 (or more).

### Jumps
Syntax:
```
jmp label
```
> What this actually does is load the value of "label" into the rip (index pointer) register.

for example:
```
_start:
    jmp _start
```
### Comparisons
Comparisons allow programs to be able to take different paths based on certain conditions.

Comparisons are done on `registers`
Syntax:
```
cmp register, register/value
```
example:
```
cmp rax, 23
cmp rax, rbx
```

### Comparisons & flags

After a comparison is made certain flags are set.
```
cmp a,b
```

|   ||
|---|---|
|  a == b | ZF = 1|
| a != b  | ZF = 0|

### Conditional flags

After a comparison is made, a conditional jump can be made.
Conditional jumps are based on the status of the flags.

| Jump symbol (signed) | Jump symbol (unsigned) | Results of `cmp a, b`  |
|:---------------------|:-----------------------|:-----------------------|
| je                                           || a == b                 |
| jne                                          || a != b                 |
| jg                   | ja                     | a > b                  |
| jge                  | jae                    | a >= b                 |
| jl                   | jb                     | a < b                  |
| jle                  | jbe                    | a <= b                 |
| jz                                           || a == 0                 |
| jnz                                          || a != 0                 |
| jo                                           || Overflow occurred      |
| jno                                          || Overflow did not occur |
| js                                           || Jump if signed         |
| jns                                          || Jump if not signed     |

examples:
```
cmp rax, 23 
je _doThis ; if rax == 23 jump to doThis
```
```
cmp rax, rbx
jg _doThis ; if rax > rbx jump to doThis
```

### Registers as pointers

Default registers can be treated as pointers, to threat a register as a pointer surround the register name with square brackets such as `rax` => `[rax]`

```
mov rax, rbx
```
Loads the value from the rbx register into the rax register. 
```
mov rax, [rbx]
```
Loads the value the rbx register is pointing to into the rax register

### Calls

Calls and jumps are essentially the same however when `call` is used the
original position the call was made from can be returned to using `ret`.
*This is called a `subroutine`*
##### Note: Calls are not functions and don't have to be explicitly called, they are labels to jump to, and will still run when executed by default (top to bottom).


for example:
```
	global _start
	section	.text   ; section for code
_start:
    call _printHello    ; call subroutine
                        ; continue after subroutine finished
	mov	rax, 60		; sys_exit
	mov	rdi, 0		; exit code
	syscall
	
_printHello:         ; subroutine printHello
    mov	rax, 1		; sys_write
    mov	rsi, msg	; write hello world
    mov	rdx, 14		; write 14 characters
    mov	rdi, 1		; standard output
    syscall
    ret             ; return to _start

	section	.data   ; section for static constant variables
msg:	db "Hello, World!", 10	; newline = ', 10'
```

## Programs
### Program: Hello World!
```
section .data
    msg db "Hello World!",10       ; define a string 
    msgLen equ $-msg               ; get amount of bytes
    
section .text
    global _start
_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; standard output
    mov rdx, msgLen     ; write characters
    mov rsi, msg        ; write msg
    syscall
    
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; exit code
    syscall
```
### Program: Get user input

```
section .bss            ; for non-constant data
    name resb 16        ; reserve 16 bytes (resb)

section .text
    mov rax, 0          ; sys_read
    mov rdi, 0          ; standard input
    mov rdx, 16         ; size= 16 bytes
    mov rsi, name       ; buffer
    syscall
                        ; you can print the name by using: 
                        ; mov rsi, name
                        
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; exit code
    syscall
```


## Math

Math operations are used to mathematically manipulate registers.

The form of a math operation is typically:
`operation register, value / register`

examples:
```
add rax, 5      ; the value of rax is incremented by 5
sub rbx, rax    ; the value of rbx is decremented by rax
```

| Operation Name | Operation Name (signed) | Description     |
|:---------------|:------------------------|:----------------|
| add a, b       |                         | a = a + b       |
| sub a, b       |                         | a = a - b       |
| mul reg        | imul reg                | rax = rax * reg |
| div reg        | imul reg                | rax = rax / reg |
| neg reg        |                         | reg = -reg      |
| inc reg        |                         | reg = reg + 1   |
| dec reg        |                         | reg = reg - 1   |
| adc a, b       |                         | a = a + b + CF  |
| sbb a, b       |                         | a = a - b - CF  |

`mul` and `div` are assuming that the first operator is `rax` so:
```
mul rbx
```
Actually does:
```
rax = rax * rbx
```
##### Note, when using the div operation, if the rdx register is not 0 then the rdx will be concated on the rax register, acting like a 128 bit register. If rdx is 0, it will hold the remainder after a div.

```
mov rax, 26
mov rbx, 3
div rbx     ; rax / rbx => rax = 12
            ; rdx holds 2
            ; this is the value that comes from the modulus operator (%) in higher languages.

```  
### How to display a digit
To display a single digit:
> *Note:* "`digit`" is actually defined with two bytes, 
> being `0` and `10` (='\n'), a new line character. 
> Since we are only loading the lower byte of the `rax` register (=`al`)
> into "`digit`", it only overwrites the first byte 
> and does not affect the newline character:
> ```
> digit db 0,10
> add byte [i], 48
> ```
```
    mov [i], al         ; place lower byte of r10 in i (because i is a byte)
    add byte [i], 48    ; add 48 to it because ASCII '0' = 48
    mov rax, 1          ; sys_write
    mov rdi, 1
    mov rsi, i
    mov rdx, 2
    syscall
```

### The Stack
You can't see in the middle of the stack without removing the top of the stack.
Terminology:
* When you add data onto the top of the stack, you `push` data on the stack.
* When you remove data from the top of the stack, you `pop` data from the stack.
* if you look at the top of the stack without removing or adding anything to it, you `peek` at the stack. 
> You can only affect the data on top of the stack.

Stack operations:

| Operation  | Effect |
|---|---|
|  `push reg` / `push value` | Pushes a value onto the stack|
|`pop reg`   |Pops a value off of the stack and stores it in reg|
|  `mov reg, [rsp]` |Stores the peek value in reg|
 
### Program: A simple for loop
```

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
```

## Subroutine programs
These 2 programs show how you don't have to manually add the number of characters for a print statement but calculate it in 2 different ways:
* Print string v2 shows how to do it with a for loop.
* Print string v3 shows how to do it by doing a simple NASM calculation `msgLen  equ  $-msg`.
### Program: Print string v2
```
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
```
### Program: Print string v3 (simple)
```
section .text
    global _start
_start:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; standard output
    mov rsi, msg    ; msg buffer
    mov rdx, msgLen ; message length
    syscall

    call _exit

_exit:
    mov rax, 60     ; sys_exit
    mov rdi, 0      ; exit code 0
    syscall

section .data
    msg     db "Hello, World!", 10	; newline = ', 10'
    msgLen  equ  $-msg  ; calculate string length with NASM
```

## NASM macros
> Note, macros are specific to the assembly language and will be dealt with differently in different languages.

Macros is a single instruction that expands into a predefined set of instructions to perform a particular task.
```
exit
```
could be:
```
mov rax, 60
mov rdi, 0
syscall 
```

### Syntax
Defining a macro:
```
%macro <name> <argc>
    ...
    <macro body>
    ...
%endmacro
```
Example, exit macro:
```
%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro
```
### Inputs
Using inputs with macro's:

<argc> is the number of arguments the macro takes.
These inputs are referenced (inside the macro) using `%1` for the first input, `%2` for the second, etc..

Example:
```
%macro printDigit 1
    mov rax, %1
    call _printRAXDigit
%endmacro

_start:
    printDigit 3
    printDigit 4
    
    exit
```
if args > 1, then a comma is used between inputs.

Example:
```
%macro printDigitSum 2
    mov rax, %1
    add rax, %2
    call _printRAXDigit
%endmacro

_start:
    printDigitSum 3, 2
    exit
```

### Local labels
> Macros are expanded upon compilation into predefined code. 
> So if the code contains a label, it can cause duplicate label error if the macro is used more than once.

So this:
```
%macro freeze 0
_loop:
    jmp _loop
%endmacro

_start:
    freeze
    freeze
    exit
```
Expands out to:
```
_start:
_loop:
    jmp _loop
_loop:
    jmp _loop
    
    mov rax, 60
    mov rdi, 0
    syscall
```
Causes: `Redefined Symbol Error`

To solve this we can use `%%` before label names within a macro, 
this will make it so that the label is unique every time it is expanded.

This:
```
%macro freeze 0
_loop:
    jmp _loop
%endmacro
```
Becomes:
```
%macro freeze 0
%%loop:
    jmp %%loop
%endmacro
```

### Defining values with EQU (C/C++ Like defines)

For example:
```
STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

_start
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    ; etc..
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
```

### Including external files

"Include" will load an external file's code and insert it into the position 
in which it is included upon compilation.
```
%include "filename.asm"
```
Example:
```
%include "linux64.inc"

section .data
    text db "Hello, World!",10,0
section .text
    global _start
    
_start:
    print text
    exit
```

### Program: input with macros
A simple program that shows your input, 
but now with a hidden and repeatable interface.

.asm file:
```
%include "file.inc"   ; include the macros.inc file, which places all code at this location to be used later in the program.

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
```
.inc file:
```
SYS_READ equ 0      ; define sys_read
SYS_WRITE equ 1     ; define sys_write
SYS_EXIT equ 60     ; define sys_exit

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
```
<!--## Using multiple .asm files-->

<!--### Extern-->
<!--### Global-->

## Pointers & values
Think of the difference between these 2 instructions:
```
mov cl, buffer
mov cl, [buffer]
```
`mov cl, buffer` will move the *address* of buffer to cl(which may or 


## Program: print (more than one) numbers

### The program

```
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
```


### Debugging!
How to debug an assembly program?

[web.cecs.pdx.edu/gdb.pdf](http://web.cecs.pdx.edu/~apt/cs491/gdb.pdf)

make executable from .asm
```
nasm -felf64 numbers.asm
ld numbers.o
gdb a.out
```
or use the `./debug` script
```
./debug file.asm
```

some commands in gdb:
* `run` to run the program
* `info register` to print out all registers
* `break _subroutine` to set a breakpoint at the start of a subroutine
* `continue` to continue executing the program after a breakpoint has been reached.
* `whe` to show the call stack
* `step i` to execute a single instruction.
* `next i` like step i, except that if the instruction is a subroutine call the entire subroutine is executed before control returns to the console.( basically skip the function implementation ) 


## Command line arguments
When a program is executed from the command line, arguments can be passed into it.
After the name of the program to execute, the arguments are seperated by spaces.
<br><br>

All arguments are strings, not integers.
`$ ./program arg1 arg2 arg3 etc`


When the program is executed, the arguments are automatically loaded onto the stack.
The top item is the number of arguments. This number is always at least 1. (argc in C & C++)
The next items in the stack are pointers to the zero-terminated
string starting the path of the program (eg `./program`) then of each individual arguments.
<br><br>

`*arg[1]` is the first user defined argument.
 
Stack:
* `argc`
* `*path`
* `*arg[1]`
* `*arg[2]`
* `...`
* `*arg[n]`


Example:
* `argc` = 3
* `*path` = "./program"
* `*arg[1]` = "argument1"
* `*arg[2]` = "argument2"

## Linux

### Files




File modes specify the permissions for files.
They specify who is allowed to read, write, and/or execute the file.

Modes are stored as a three digit octal value

| Value | Read | Write | Execute |
|:------|:-----|:------|:--------|
| 0                           ||||
| 1                  ||| X       |
| 2           || X              ||
| 3           || X     | X       |
| 4     | X                    |||
| 5     | X           || X       |
| 6     | X    | X              ||
| 7     | X    | X     | X       |

You cann add 2 values together if you want to have those rows of permissions:

1 ( Only execute ) + 2 ( Only write ) = 3 ( Write & Execute )

In linux file permissions are set with four octal values. The least 3 significant octal 
values are for the file owner's permission, the group's permissions, and the "other's" permissions

The most significant octal value is reserved for special permissions ( Usually not necessary )  <br><br>

| Special  |Owner|Group|Other|
|---|---|---|---|
| sticky bit  |execute|execute|execute|
|  setgid |write|write|write|
|  setuid |read|read|read|

(Special is usually set to 0)

We've used `sys_read` & `sys_write` before as reading and writing console input & output.
We can also use them for reading & writing to files
For this, you need the *filedescriptor*, which can be obtained by `sys_open`

#### Obtaining the filedescriptor with sys_open

| System call | rax (ID) | rdi                  | rsi       | rdx | r10 | r8 | r9 |
|:------------|:---------|:---------------------|:----------|:----|:----|:---|:---|
| sys_open    | 2        | const char *filename | int flags | int mode         ||||

* The first argument for sys_open takes is a pointer to the filename (zero terminated).
* The second argument are the flags. 
* The third argument is the file mode, being the 4-digit octal number that we learned from earlier.

Flags:

| Flag name   | Value   | log2(value) | Actual name            |
|:------------|:--------|:------------|:-----------------------|
| O_RDONLY    | 0       | null        | Read only              |
| O_WRONLY    | 1       | 0           | Write only             |
| O_RDWR      | 2       | 1           | Read Write             |
| O_CREAT     | 64      | 6           | Create (if not exists) |
| O_APPEND    | 1024    | 10                                  ||
| O_DIRECTORY | 65536   | 16                                  ||
| O_PATH      | 2097152 | 21                                  ||
| O_TMPFILE   | 4194304 | 22                                  ||

If you want to execute multiple flags you cann add them together.

Code to open a file with the "create" and "write" flag.
```
mov rax, 1          ; system call ID for sys_open
mov rdi, filename   ; pointer to null terminated string
mov rsi, 64 + 1     ; 64 = O_CREAT + 1 = O_WRONLY

                    ; you can also use defines: 
                    ; O_CREAT equ 64
                    ; O_WRONLY equ 1
                    ; mov rsi, O_CREAT + O_WRONLY
                    
mov rdx, 0644o      ; 0644o is an octal value for the permissions
```

##### Note, sys_open returns the file descriptor of the file opened within the rax register.



#### Program: Writing files with sys_write

| System call | rax (ID) | rdi                         | rsi                | rdx          | r10 | r8  | r9  |
|:------------|:---------|:----------------------------|:-------------------|:-------------|:----|:----|:----|
| sys_write   | 1        | unsigned int filedescriptor | const char *buffer | size_t count | ... | ... | ... |

sys_write can be used to write text to a file.

It's exactly like in the hello world program, except the rdi is changed to the file descriptor (in `rax`) returned from the sys_open syscall.

```
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
```

#### Program: Reading files with sys_read
| System call | rax (ID) | rdi                         | rsi                | rdx          | r10 | r8  | r9  |
|:------------|:---------|:----------------------------|:-------------------|:-------------|:----|:----|:----|
| sys_read    | 0        | unsigned int filedescriptor | char *buffer       | size_t count | ... | ... | ... |

First we have to use sys_open to get the file descriptor ( as is stated above ).
But now we don't need the writing flag, only the reading flag:
```
mov rax, 2          ; sys_open ID
mov rdi, filename   ; pointer to zero-terminated string for the file name
mov rsi, 0          ; O_RDONLY read only flag 
mov rdx, 0644o      ; file permissions ( octal value )
syscall
```

Now we can use the file descriptor in rax and read the file
```
mov rdi, rax        ; file descriptor from sys_open 
mov rax, 0          ; sys_read ID
mov rsi, text       ; buffer for the read text
mov rdx. 17         ; the number of bytes to be read
syscall
```

and close the file


### Syscall
Syscalls can be seen at table.md

Here are the most important ones

| System call | rax (ID) | rdi                         | rsi                | rdx          | r10 | r8  | r9  |
|:------------|:---------|:----------------------------|:-------------------|:-------------|:----|:----|:----|
| sys_read    | 0        | unsigned int filedescriptor | char *buffer       | size_t count | ... | ... | ... |
| sys_write   | 1        | unsigned int filedescriptor | const char *buffer | size_t count | ... | ... | ... |
| sys_open    | 2        | const char *filename        | int flags          | int mode     | ... | ... | ... |
| sys_close   | 3        | unsigned int filedescriptor | ...                | ...          | ... | ... | ... |
| ...         | ...      | ...                         | ...                | ...          | ... | ... | ... |
| pwritev2    | 328      | ...                         | ...                | ...          | ... | ... | ... |


### Exit codes
<br>

exit codes:
* 1 - Catchall for general errors
* 2 - Misuse of shell builtins (according to Bash documentation)
* 126 - Command invoked cannot execute
* 127 - “command not found”
* 128 - Invalid argument to exit
* 128+n - Fatal error signal “n”
* 130 - Script terminated by Control-C
* 255\* - Exit status out of range

Exit status can be printed out with: 
```
echo $?
```



## Further reading:

[nasm.us](https://www.nasm.us/doc)

[cs.lmu.edu/nasmtutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial)

[intel.com](https://software.intel.com/en-us/articles/intel-sdm) 

[blog.rchapman.org/Linux_System_Call_Table_for_x86_64](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64)

[web.cecs.pdx.edu/gdb.pdf](http://web.cecs.pdx.edu/~apt/cs491/gdb.pdf)

[wikipedia.org/Data_segment](https://en.wikipedia.org/wiki/Data_segment)

kupala's macro's files.
[pastebin.com](https://pastebin.com/wCNZs3RN)


## Credits
<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

<small><i><a href='https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn'>Created by following (among other tutorials) kupala's tutorial</a></i></small>

