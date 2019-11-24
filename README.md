# x86_64 NASM 
Tutorial & Examples of x86_64 Netwide Assembly

* NASM-programs contain examples of programs in pure NASM
* NASM-decleration gives an example of how to implement (and call) a C/C++ function in NASM

Use compile-assemble script to compile .cpp file, assemble .asm file, link them and execute. Use it as:
```
chmod +x compile-assemble
./compile-assemble file.cpp file.asm
```

Use assemble script to assemble, link & run an .asm file
```
chmod +x assemble
./assemble file.asm
```

Use debug script to assemble, link & debug using gdb
```
chmod +x debug
./debug file.asm
```

Use assemble-args to assemble, link & run with arguments given to the script
```
chmod +x assemble-args
./assemble-args file.asm arg1 arg2 etc
```

The object file & a.out will be removed after use
.
