%include "../../ascii.inc"

%include "../x86_64.inc"
%include "jack_tokens.inc"
%include "jack_tokenizer.s"

section .data
  filename db "../../../data/jack/Square.jack", 0

  rprint db "TOKEN '", 0
  print_undefined db "' ==> UNDEFINED", 10, 0
  print_keyword db "' ==> KEYWORD", 10, 0
  print_symbol db "' ==> SYMBOL", 10, 0
  print_identifier db "' ==> IDENTIFIER", 10, 0
  print_integer_constant db "' ==> INTEGER CONSTANT", 10, 0
  print_string_constant db "' ==> STRING CONSTANT", 10, 0
  
section .bss
  source resb 1024 * 5 ; This allows to save content up to 5 kB
  char resb 8

section .text
  global _start

_start:
  ; OPEN the file
  open_jack_file:
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0644o
    syscall

    ; STACK the &filedescriptor of the file in the RAX register,
    ; in case of error, the error code is in the RAX register.
    push rax

  ; READ the file and save it content into 'source' reserved bytes.
  read_jack_file:
    mov rdi, rax
    mov rax, SYS_READ
    mov rsi, source
    mov rdx, 1024 * 5
    syscall

  ; CLOSE the file
  close_jack_file:
    mov rax, SYS_CLOSE
    ; POP the &filedescriptor from the STACK and 'mov' it into RDI register
    pop rdi
    syscall

  call_jack_tokenizer:
    mov rsi, 0 ; Start char index
    mov r10, 0 ; Prevent infinite loop (x64 only)

    call_jack_tokenizer_loop:
      jack_tokenizer source, rsi
      ; RAX -> &token
      ; RBX -> file content
      ; RCX -> token length
      ; RDX -> jack token type
      ; RSI -> last char index
      
      cmp rcx, 0
      je finish
      
      print rprint

      print token

      cmp rdx, JACK_TOKEN_KEYWORD
      je is_keyword

      cmp rdx, JACK_TOKEN_SYMBOL
      je is_symbol

      cmp rdx, JACK_TOKEN_IDENTIFIER
      je is_identifier

      cmp rdx, JACK_TOKEN_UNDEFINED
      je is_undefined

      cmp rdx, JACK_TOKEN_INTEGER_CONSTANT
      je is_integer_constant

      cmp rdx, JACK_TOKEN_STRING_CONSTANT
      je is_string_constant
      
      call_jack_tokenizer_end:
      inc r10

      cmp r10, 1048576
      je finish
      
      jmp call_jack_tokenizer_loop

  finish:
    exit 0

_print_rax:
  mov [char], al
  print char
  ret

is_undefined:
  print print_undefined
  jmp call_jack_tokenizer_end

is_keyword:
  print print_keyword
  jmp call_jack_tokenizer_end

is_symbol:
  print print_symbol
  jmp call_jack_tokenizer_end

is_identifier:
  print print_identifier
  jmp call_jack_tokenizer_end

is_integer_constant:
  print print_integer_constant
  jmp call_jack_tokenizer_end

is_string_constant:
  print print_string_constant
  jmp call_jack_tokenizer_end