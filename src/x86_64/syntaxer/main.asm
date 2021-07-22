%include "../../ascii.inc"

%include "../x86_64.inc"
%include "../lexer/jack_tokens.inc"
%include "jack_syntaxer.s"

section .data
  ERR_INVALID_ARGC db "Usage: syntaxer [input]",10,10,"- input:",9,"path to a .jack file",10,0
  ERR_FILE_NOT_FOUND db "[Error 2] No such file: ",0
  ERR_INSUFFICIENT_FILE_PERMISSIONS db "[Error 13] Insufficient permissions to open file: ",0
  ERR_INPUT_FILE db "[Error 1] Could not open input file",10,"Could not find the reason. Sorry.",0

  entering_ndfa_classDef db "Starting NDFA <classDef>", 10, 0
  entering_ndfa_classVarDec db "Starting NDFA <classVarDec>", 10, 0
  entering_ndfa_subroutineCall db "Starting NDFA <subroutineCall>", 10, 0
  entering_ndfa_subroutineDec db "Starting NDFA <subroutineDec>", 10, 0
  entering_ndfa_subroutineBody db "Starting NDFA <subroutineBody>", 10, 0
  entering_ndfa_varDec db "Starting NDFA <varDec>", 10, 0
  entering_ndfa_statement db "Starting NDFA <statement>", 10, 0
  entering_ndfa_statements db "Starting NDFA <statements>", 10, 0
  entering_ndfa_letStatement db "Starting NDFA <letStatement>", 10, 0
  entering_ndfa_whileStatement db "Starting NDFA <whileStatement>", 10, 0
  entering_ndfa_returnStatement db "Starting NDFA <returnStatement>", 10, 0
  entering_ndfa_ifStatement db "Starting NDFA <ifStatement>", 10, 0
  entering_ndfa_doStatement db "Starting NDFA <doStatement>", 10, 0
  entering_ndfa_expression db "Starting NDFA <expression>", 10, 0
  entering_ndfa_expressionList db "Starting NDFA <expressionList>", 10, 0
  entering_ndfa_parameterList db "Starting NDFA <parameterList>", 10, 0
  entering_ndfa_varName db "Starting NDFA <varName>", 10, 0
  entering_ndfa_subroutineName db "Starting NDFA <subroutineName>", 10, 0
  entering_ndfa_type db "Starting NDFA <type>", 10, 0
  entering_ndfa_term db "Starting NDFA <term>", 10, 0
  entering_ndfa_className db "Starting NDFA <className>", 10, 0

  exiting_ndfa_classDef db "Leaving NDFA <classDef>", 10, 0
  exiting_ndfa_classVarDec db "Leaving NDFA <classVarDec>", 10, 0
  exiting_ndfa_subroutineCall db "Leaving NDFA <subroutineCall>", 10, 0
  exiting_ndfa_subroutineDec db "Leaving NDFA <subroutineDec>", 10, 0
  exiting_ndfa_subroutineBody db "Leaving NDFA <subroutineBody>", 10, 0
  exiting_ndfa_varDec db "Leaving NDFA <varDec>", 10, 0
  exiting_ndfa_statement db "Leaving NDFA <statement>", 10, 0
  exiting_ndfa_statements db "Leaving NDFA <statements>", 10, 0
  exiting_ndfa_letStatement db "Leaving NDFA <letStatement>", 10, 0
  exiting_ndfa_whileStatement db "Leaving NDFA <whileStatement>", 10, 0
  exiting_ndfa_returnStatement db "Leaving NDFA <returnStatement>", 10, 0
  exiting_ndfa_ifStatement db "Leaving NDFA <ifStatement>", 10, 0
  exiting_ndfa_doStatement db "Leaving NDFA <doStatement>", 10, 0
  exiting_ndfa_expression db "Leaving NDFA <expression>", 10, 0
  exiting_ndfa_expressionList db "Leaving NDFA <expressionList>", 10, 0
  exiting_ndfa_parameterList db "Leaving NDFA <parameterList>", 10, 0
  exiting_ndfa_varName db "Leaving NDFA <varName>", 10, 0
  exiting_ndfa_subroutineName db "Leaving NDFA <subroutineName>", 10, 0
  exiting_ndfa_type db "Leaving NDFA <type>", 10, 0
  exiting_ndfa_term db "Leaving NDFA <term>", 10, 0
  exiting_ndfa_className db "Leaving NDFA <className>", 10, 0

  success_ndfa db ">> SUCCESS: ", 0

  poping db "POP ---------------------------> ", 0
  peeking db "PEEK --------------------------> ", 0
  newline db 10, 0

section .bss
  source resb 1024 * 5 ; This allows to save content up to 5 kB
  char resb 8

section .text
  global _start

_start:
  ; Check if user has entered with right argument count (must be 2)
  pop rcx ; argc
  
  cmp rcx, 2
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
  
  call_jack_syntaxer:
    jack_syntaxer source
    cmp rdi, TRUE
    je _exit

    print syntax_error
    print error_unexpected_token
    print token
    print newline
    jmp _exit

  _exit:
    exit rdi

%include "jack_syntaxer_compilers.s"

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