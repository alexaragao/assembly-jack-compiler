mkdir ./build

# Generate `.o` file:
nasm -f elf64 -o ./build/xmler.o ./main.asm

# Generate executable file:
ld ./build/xmler.o -o ./build/xmler

# Run the program:
./build/xmler ../../../data/jack/Square.jack ./build/SquareT.xml

# Print exit code
echo "EXIT CODE:" $?