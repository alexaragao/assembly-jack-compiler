mkdir ./build

# Generate `.o` file:
nasm -f elf64 -o ./build/lexer.o ./main.asm

# Generate executable file:
ld ./build/lexer.o -o ./build/lexer

# Run the program:
./build/lexer

# Print exit code
echo $?