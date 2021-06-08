# Generate `.o` file:
nasm -f elf64 -o main.o main.asm

# Generate executable file:
ld main.o -o main

# Run the program:
./main