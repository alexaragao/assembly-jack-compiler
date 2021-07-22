section .data
  syntax_error db "[SyntaxError] Too bad.", 10, 0
  error_unexpected_token db "UnexpectedToken: ", 0

%include "jack_syntaxer_ndfas.s"

%macro jack_syntaxer 1
  mov rsi, 0 ; Start char index
  mov rdi, FALSE

  _peek_token %1

  %%compile:
    cmp rdx, JACK_TOKEN_KEYWORD
    jne %%end
  
  %%keyword_router:
    cmp rbx, JACK_KEYWORD_CLASS
    jne %%end

  %%compile_class_definition:
    _ndfa_class_definition %1
    cmp rdi, TRUE
    jne %%end
  
  %%success:
    mov rdi, TRUE
    ; print token
    ; print newline

  %%end:
%endmacro
