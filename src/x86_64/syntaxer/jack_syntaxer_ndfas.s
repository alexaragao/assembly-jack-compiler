%include "../lexer/jack_tokenizer.s"

FALSE equ 1
TRUE equ 0

%macro is_token 1
  mov rdi, TRUE

  cmp rdx, %1
  je %%end

  mov rdi, FALSE
  %%end:
%endmacro

%macro is_this_token 2
  ; Validate token type
  mov rdi, FALSE
  cmp rdx, %1
  jne %%end

  ; Validate token
  mov rdi, TRUE
  cmp rbx, %2
  je %%end
  
  mov rdi, FALSE
  %%end:
%endmacro

%macro is_keyword_constant 2
  ; Validate token type
  mov rdi, FALSE
  cmp %1, JACK_TOKEN_KEYWORD
  jne %%end
  
  ; Validate token
  mov rdi, TRUE
  cmp %2, JACK_KEYWORD_TRUE
  je %%end
  cmp %2, JACK_KEYWORD_FALSE
  je %%end
  cmp %2, JACK_KEYWORD_NULL
  je %%end
  cmp %2, JACK_KEYWORD_THIS
  je %%end

  mov rdi, FALSE
  %%end:
%endmacro

%macro is_unary_operator 2
  mov rdi, TRUE
  cmp %2, JACK_SYMBOL_MINUS
  je %%end
  cmp %2, JACK_SYMBOL_TILDE
  je %%end

  mov rdi, FALSE
  %%end:
%endmacro

%macro is_binary_operator 2
  mov rdi, TRUE
  cmp %2, JACK_SYMBOL_PLUS
  je %%end
  cmp %2, JACK_SYMBOL_MINUS
  je %%end
  cmp %2, JACK_SYMBOL_ASTERISK
  je %%end
  cmp %2, JACK_SYMBOL_SOL
  je %%end
  cmp %2, JACK_SYMBOL_AMP
  je %%end
  cmp %2, JACK_SYMBOL_VERTICAL_BAR
  je %%end
  cmp %2, JACK_SYMBOL_LT
  je %%end
  cmp %2, JACK_SYMBOL_GT
  je %%end
  cmp %2, JACK_SYMBOL_EQUALS
  je %%end

  mov rdi, FALSE
  %%end:
%endmacro

%macro _peek_token 1
  push rsi
  jack_tokenizer %1, rsi
  print peeking
  print token
  print newline
  pop rsi
%endmacro

%macro _pop_token 1
  jack_tokenizer %1, rsi
  print poping
  print token
  print newline
%endmacro

%macro _ndfa_class_definition 1
  print entering_ndfa_classDef
  push rsi
  %%NDFA_STATE_0:
    _pop_token %1
    
    ; class
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_CLASS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    ; className
    call _compile_class_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    _pop_token %1
    
    ; {
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LCURB
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_3:
    ; classVarDec*
    call _compile_class_variable_declaration
    cmp rdi, TRUE
    je %%NDFA_STATE_3
    
    ; subroutineDec*
    call _compile_subroutine_declaration
    cmp rdi, TRUE
    je %%NDFA_STATE_4

    _pop_token %1
    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    je %%NDFA_STATE_5

    jmp %%NDFA_END
    
  %%NDFA_STATE_4:
    ; subroutineDec*
    call _compile_subroutine_declaration
    cmp rdi, TRUE
    je %%NDFA_STATE_4

    _pop_token %1
    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_5:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_classDef
    pop rsi
%endmacro

%macro _ndfa_subroutine_declaration 1
  print entering_ndfa_subroutineDec
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    cmp rdx, JACK_TOKEN_KEYWORD
    jne %%NDFA_END

    cmp rbx, JACK_KEYWORD_CONSTRUCTOR
    je %%NDFA_STATE_1

    cmp rbx, JACK_KEYWORD_FUNCTION
    je %%NDFA_STATE_1

    cmp rbx, JACK_KEYWORD_METHOD
    je %%NDFA_STATE_1

    jmp %%NDFA_END
  
  %%NDFA_STATE_1:
    call _compile_type
    cmp rdi, TRUE
    je %%NDFA_STATE_2

    _pop_token %1
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_VOID
    cmp rdi, TRUE
    jne %%NDFA_END
    
  %%NDFA_STATE_2:
    call _compile_subroutine_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    _pop_token %1
    
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    call _compile_parameter_list
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    _pop_token %1
    
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_6:
    call _compile_subroutine_body
    cmp rdi, TRUE
    jne %%NDFA_END
    
  %%NDFA_STATE_7:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_subroutineDec
    pop rsi
%endmacro

%macro _ndfa_class_variable_declaration 1
  print entering_ndfa_classVarDec
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1
    
    ; static | field
    cmp rdx, JACK_TOKEN_KEYWORD
    jne %%NDFA_END

    cmp rbx, JACK_KEYWORD_STATIC
    je %%NDFA_STATE_1

    cmp rbx, JACK_KEYWORD_FIELD
    je %%NDFA_STATE_1

    ; TODO: DISCORVER WHY THE FOLLOWING LINE IS NECESSARY
    mov rdi, FALSE
    jmp %%NDFA_END
  
  %%NDFA_STATE_1:
    ; type
    call _compile_type
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    ; varName
    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    ; (, varName)*
    _peek_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_COMMA
    cmp rdi, TRUE
    jne %%NDFA_STATE_4
    
    _pop_token %1

    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_3

  %%NDFA_STATE_4:
    ; ;
    _pop_token %1
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_SEMICOLON
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_classVarDec
    pop rsi
%endmacro

%macro _ndfa_type 1
  print entering_ndfa_type
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_class_name
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    _pop_token %1

    cmp rdx, JACK_TOKEN_KEYWORD
    jne %%NDFA_END

    cmp rbx, JACK_KEYWORD_INT
    je %%NDFA_STATE_1

    cmp rbx, JACK_KEYWORD_CHAR
    je %%NDFA_STATE_1

    cmp rbx, JACK_KEYWORD_BOOLEAN
    je %%NDFA_STATE_1

    ; TODO: remove
    mov rdi, FALSE
    jmp %%NDFA_END
  
  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_type
    pop rsi
%endmacro

%macro _ndfa_class_name 1
  print entering_ndfa_className
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    is_token JACK_TOKEN_IDENTIFIER
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_className
    pop rsi
%endmacro

%macro _ndfa_subroutine_name 1
  print entering_ndfa_subroutineName
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    is_token JACK_TOKEN_IDENTIFIER
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_subroutineName
    pop rsi
%endmacro
  
%macro _ndfa_variable_name 1
  print entering_ndfa_varName
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    is_token JACK_TOKEN_IDENTIFIER
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_varName
    pop rsi
%endmacro

%macro _ndfa_parameter_list 1
  print entering_ndfa_parameterList
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_type
    cmp rdi, TRUE
    jne %%NDFA_STATE_3
  
  %%NDFA_STATE_1:
    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_STATE_2

  %%NDFA_STATE_2:
    ; (, varName)*
    _peek_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_COMMA
    cmp rdi, TRUE
    jne %%NDFA_STATE_3
    
    _pop_token %1

    call _compile_type
    cmp rdi, TRUE
    jne %%NDFA_END

    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_2
  
  %%NDFA_STATE_3:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_parameterList
    pop rsi
%endmacro

%macro _ndfa_subroutine_body 1
  print entering_ndfa_subroutineBody
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; {
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    call _compile_variable_declaration
    cmp rdi, TRUE
    je %%NDFA_STATE_1

  %%NDFA_STATE_3:
    call _compile_statements
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    _pop_token %1

    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_subroutineBody
    pop rsi
%endmacro

%macro _ndfa_variable_declaration 1
  print entering_ndfa_varDec
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; static
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_VAR
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    ; type
    call _compile_type
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    ; varName
    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    ; (, varName)*
    _peek_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_COMMA
    cmp rdi, TRUE
    jne %%NDFA_STATE_4
    
    _pop_token %1

    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_3

  %%NDFA_STATE_4:
    ; ;
    _pop_token %1
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_SEMICOLON
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_varDec
    pop rsi
%endmacro

%macro _ndfa_statement 1
  print entering_ndfa_statement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_statement_let
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    call _compile_statement_if
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    call _compile_statement_do
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    call _compile_statement_return
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    call _compile_statement_while
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    jmp %%NDFA_END
  
  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_statement
    pop rsi
%endmacro

%macro _ndfa_statements 1
  print entering_ndfa_statements
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_statement
    cmp rdi, TRUE
    je %%NDFA_STATE_0
  
  %%NDFA_STATE_1:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_statements
    pop rsi
%endmacro

%macro _ndfa_expression 1
  print entering_ndfa_expression
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_term
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    _peek_token %1

    is_binary_operator rdx, rbx
    cmp rdi, TRUE
    jne %%NDFA_STATE_2

    _pop_token %1

    call _compile_term
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    jmp %%NDFA_STATE_2
  
  %%NDFA_STATE_2:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_expression
    pop rsi
%endmacro

%macro _ndfa_term 1
  print entering_ndfa_term
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_subroutine_call
    cmp rdi, TRUE
    je %%NDFA_STATE_7

    call _compile_variable_name
    cmp rdi, TRUE
    je %%NDFA_STATE_1

    _pop_token %1
        
    ; push rax
    ; push rbx
    ; push rcx
    ; push rdx
    ; push rsi
    ; push rdi
    ; printVal rdx
    print newline
    ; printVal rbx
    ; pop rdi
    ; pop rsi
    ; pop rdx
    ; pop rcx
    ; pop rbx
    ; pop rax
    
    is_keyword_constant rdx, rbx
    cmp rdi, TRUE
    je %%NDFA_STATE_7
    
    cmp rdx, JACK_CONSTANT_INTEGER
    je %%NDFA_STATE_7

    cmp rdx, JACK_CONSTANT_STRING
    je %%NDFA_STATE_7
    
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    je %%NDFA_STATE_4

    is_unary_operator rdx, rbx
    cmp rdi, TRUE
    je %%NDFA_STATE_6

    jmp %%NDFA_END

  %%NDFA_STATE_1:
    _peek_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LSQB
    cmp rdi, TRUE
    jne %%NDFA_STATE_7

    _pop_token %1

  %%NDFA_STATE_2:
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    _pop_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RSQB
    cmp rdi, TRUE
    je %%NDFA_STATE_7

    jmp %%NDFA_END
  
  %%NDFA_STATE_4:
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    _pop_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    je %%NDFA_STATE_7

    jmp %%NDFA_END

  %%NDFA_STATE_6:
    call _compile_term
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_7:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_term
    pop rsi
%endmacro

%macro _ndfa_statement_let 1
  print entering_ndfa_letStatement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; let
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_LET
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    ; varName
    call _compile_variable_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    _peek_token %1
    
    ; [
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LSQB
    cmp rdi, TRUE
    jne %%NDFA_STATE_5

    _pop_token %1

    jmp %%NDFA_STATE_3
  
  %%NDFA_STATE_3:
    ; expression
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    _pop_token %1
    
    ; [
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RSQB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    _pop_token %1
    
    ; =
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_EQUALS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_6:
    ; expression
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_7:
    _pop_token %1
    ; ;
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_SEMICOLON
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_8:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_letStatement
    pop rsi
%endmacro

%macro _ndfa_statement_if 1
  print entering_ndfa_ifStatement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; if
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_IF
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    _pop_token %1
    
    ; (
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    ; expression
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_3:
    _pop_token %1
    
    ; )
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    _pop_token %1
    
    ; {
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    ; statements
    call _compile_statements
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_6:
    _pop_token %1
    
    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_7:
    _peek_token %1
    
    ; else
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_ELSE
    cmp rdi, TRUE
    jne %%NDFA_STATE_1000
  
  %%NDFA_STATE_8:
    _pop_token %1
    
    ; {
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_9:
    ; statements
    call _compile_statements
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_10:
    _pop_token %1
    
    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1000:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_ifStatement
    pop rsi
%endmacro

%macro _ndfa_statement_do 1
  print entering_ndfa_doStatement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; do
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_DO
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    ; subroutineCall
    call _compile_subroutine_call
    cmp rdi, TRUE
    jne %%NDFA_END

  %%NDFA_STATE_2:
    _pop_token %1

    ; ;
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_SEMICOLON
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_doStatement
    pop rsi
%endmacro

%macro _ndfa_statement_return 1
  print entering_ndfa_returnStatement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; return
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_RETURN
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    ; expression
    call _compile_expression

  %%NDFA_STATE_2:
    _pop_token %1
    ; ;
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_SEMICOLON
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_returnStatement
    pop rsi
%endmacro

%macro _ndfa_subroutine_call 1
  print entering_ndfa_subroutineCall
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    ; subroutineName
    call _compile_subroutine_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    _pop_token %1
    ; (
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    je %%NDFA_STATE_3

    ; .
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_PERIOD
    cmp rdi, TRUE
    je %%NDFA_STATE_10

    jmp %%NDFA_END
  
  %%NDFA_STATE_3:
    ; expressionList
    call _compile_expression_list
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    _pop_token %1
    ; )
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_1000

  %%NDFA_STATE_10:
    ; subroutineName
    call _compile_subroutine_name
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_11:
    _pop_token %1
    ; (
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_12:
    ; expressionList
    call _compile_expression_list
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_13:
    _pop_token %1
    ; )
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_1000
  
  %%NDFA_STATE_1000:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_subroutineCall
    pop rsi
%endmacro

%macro _ndfa_expression_list 1
  print entering_ndfa_expressionList
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_STATE_2

  %%NDFA_STATE_1:
    ; (, expression)*
    _peek_token %1

    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_COMMA
    cmp rdi, TRUE
    jne %%NDFA_STATE_2
    
    _pop_token %1

    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END

    jmp %%NDFA_STATE_1
  
  %%NDFA_STATE_2:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_expressionList
    pop rsi
%endmacro

%macro _ndfa_statement_while 1
  print entering_ndfa_whileStatement
  push rsi
  mov rdi, FALSE
  
  %%NDFA_STATE_0:
    _pop_token %1

    ; while
    is_this_token JACK_TOKEN_KEYWORD, JACK_KEYWORD_WHILE
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1:
    _pop_token %1
    
    ; (
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_2:
    ; expression
    call _compile_expression
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_3:
    _pop_token %1
    
    ; )
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RPARENTHESIS
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_4:
    _pop_token %1
    
    ; {
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_LCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_5:
    ; statements
    call _compile_statements
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_6:
    _pop_token %1
    
    ; }
    is_this_token JACK_TOKEN_SYMBOL, JACK_SYMBOL_RCURB
    cmp rdi, TRUE
    jne %%NDFA_END
  
  %%NDFA_STATE_1000:
    print success_ndfa
    mov rdi, TRUE
    pop rcx
    push rsi
  
  %%NDFA_END:
    print exiting_ndfa_whileStatement
    pop rsi
%endmacro