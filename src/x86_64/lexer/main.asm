%include "../../ascii.inc"

%include "../x86_64.inc"
%include "jack_tokens.inc"
%include "jack_tokenizer_dfa.s"
%include "jack_token_type_adf.s"
%include "jack_xml_writer.s"

section .data
  marker db "Marker", 0
  filename db "../../../data/jack/Square.jack", 0
  output_filename db "./build/output.xml", 0

section .bss
  _digit resb 8
  source resb 1024 * 5 ; This allows to save content up to 5 kB

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

  open_xml:
    ; OPEN the .xml file
    mov rax, SYS_OPEN
    mov rdi, output_filename
    mov rsi, O_CREAT + O_WRONLY + O_APPEND
    mov rdx, 0644o
    syscall

    push rax ; PUSH &filedescriptor to stack
    
    ; &filedescriptor should be in RAX
    write_open_tag_tokens_to_xml

  jack_tokenizer:
    mov rsi, 0 ; Start char index
    mov r10, 0 ; Prevent infinite loop (x64 only)

    jack_tokenizer_loop:
      jack_tokenizer_dfa source, rsi
      ; RAX -> &token
      ; RBX -> file content
      ; RCX -> token length
      ; RDX -> jack token type
      ; RSI -> last char index
      
      cmp rcx, 0
      je close_xml

      mov rbx, rdx
      mov rdx, rax
      mov rax, [rsp] ; &filedescriptor (peek stack)

      ; &filedescriptor should be in RAX
      write_token_to_xml

      print rtoken
      print token
      print ltoken

      inc r10

      cmp r10, 1048576
      je close_xml
      
      jmp jack_tokenizer_loop

  close_xml:
    pop rax ; POP &filedescriptor to stack

    ; &filedescriptor should be in RAX
    write_close_tag_tokens_to_xml
    
    ; CLOSE the .xml file
    mov rdi, rax
    mov rax, SYS_CLOSE
    syscall

    jmp _exit

  _exit:
    exit 0