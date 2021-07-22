mkdir ./build

# Generate `.o` file:
nasm -f elf64 -o ./build/syntaxer.o ./main.asm

# Generate executable file:
ld ./build/syntaxer.o -o ./build/syntaxer

# Run the program:
./build/syntaxer

# Print exit code
echo "EXIT CODE:" $?