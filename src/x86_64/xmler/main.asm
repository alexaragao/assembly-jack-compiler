%include "../../ascii.inc"

%include "../x86_64.inc"
%include "../lexer/jack_tokens.inc"
%include "../lexer/jack_tokenizer.s"
%include "jack_xmler.s"

section .data
  ERR_INVALID_ARGC db "Usage: xmler [input] [output]",10,10,"- input:",9,"path to a .jack file",10,"- output:",9,"name of the output .xml file",10,0
  ERR_FILE_NOT_FOUND db "[Error 2] No such file: ",0
  ERR_INSUFFICIENT_FILE_PERMISSIONS db "[Error 13] Insufficient permissions to open file: ",0
  ERR_INPUT_FILE db "[Error 1] Could not open input file",10,"Could not find the reason. Sorry.",0
  
  rtoken db "TOKEN <",0
  ltoken db ">",10,0
  newline db 10,0

section .bss
  source resb 1024 * 5 ; This allows to save content up to 5 kB

section .text
  global _start

_start:
  ; Check if user has entered with right argument count (must be 3)
  pop rcx ; argc
  
  cmp rcx, 3
  jne raise_err_invalid_argc

  pop rdi ; &path
  pop rdi ; &arg[1] (input_file_path)

  ; OPEN the file
  ; &input_file_path must be in RDI
  open_jack_file:
    mov rax, SYS_OPEN
    mov rsi, O_RDONLY
    mov rdx, 0644o
    syscall

  cmp rax, 0
  jl raise_err_file_open
  
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

  open_xml:
    pop rdi ; &arg[2] (output_file_path)
    
    ; OPEN the .xml file
    ; &output_file_path must be in RDI
    mov rax, SYS_OPEN
    mov rsi, O_CREAT + O_WRONLY
    mov rdx, 0644o
    syscall

    push rax ; PUSH &filedescriptor to stack
  
    ; write <tokens>
    mov rdi, rax

    mov rax, ASCII_LESSTHAN
    write_digit_to_file rdi
    mov rax, XML_TAG_TOKENS
    write_rax_to_file rdi
    mov rax, ASCII_GREATERTHAN
    write_digit_to_file rdi
    mov rax, ASCII_NEWLINE
    write_digit_to_file rdi

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
      je close_xml

      mov rbx, rdx
      mov rdx, rax ; &token
      mov rdi, [rsp] ; &filedescriptor (peek stack)
      
      mov rax, ASCII_TAB
      write_digit_to_file rdi
      
      write_token_to_xml rdi

      mov rax, ASCII_NEWLINE
      write_digit_to_file rdi

      print rtoken
      print token
      print ltoken

      inc r10

      cmp r10, 1048576
      je close_xml
      
      jmp call_jack_tokenizer_loop

  close_xml:
    pop rdi ; POP &filedescriptor to stack

    ; write </tokens>
    
    mov rax, ASCII_LESSTHAN
    write_digit_to_file rdi
    mov rax, ASCII_SOL
    write_digit_to_file rdi
    mov rax, XML_TAG_TOKENS
    write_rax_to_file rdi
    mov rax, ASCII_GREATERTHAN
    write_digit_to_file rdi
    
    ; CLOSE the .xml file
    mov rdi, rax
    mov rax, SYS_CLOSE
    syscall

    exit 0

raise_err_invalid_argc:
  print ERR_INVALID_ARGC
  exit 1

raise_err_file_open:
  neg rax

  cmp rax, 2
  je raise_err_file_not_found

  cmp rax, 13
  je raise_err_insufficient_file_permissions

  print ERR_INPUT_FILE
  exit 1

raise_err_insufficient_file_permissions:
  print ERR_INSUFFICIENT_FILE_PERMISSIONS
  print rdi
  print newline
  exit 13

raise_err_file_not_found:
  print ERR_FILE_NOT_FOUND
  print rdi
  print newline
  exit 2