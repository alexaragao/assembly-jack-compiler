; This section hold all tokens for the .xml file
section .data
  XML_TAG_CLASS_DEFNITION db "classDefinition", 0
  XML_TAG_CLASS_VARIABLE_DECLARATION db "classVariableDeclaration", 0
  XML_TAG_TYPE db "type", 0
  XML_TAG_SUBROUTINE_DECLARATION db "subroutineDeclaration", 0
  XML_TAG_PARAMETER_LIST db "parameterList", 0
  XML_TAG_SUBROUTINE_CALL db "subroutineBody", 0
  XML_TAG_VARIABLE_DECLARATION db "variableDeclaration", 0
  XML_TAG_CLASS_NAME db "className", 0
  XML_TAG_SUBROUTINE_NAME db "subroutineName", 0
  XML_TAG_VARIABLE_NAME db "variableName", 0
  
  ; TOKENS
  XML_TAG_TOKENS db "tokens", 0
  XML_TAG_SYMBOL db "symbol", 0
  XML_TAG_KEYWORD db "keyword", 0
  XML_TAG_IDENTIFIER db "identifier", 0
  XML_TAG_INTCONST db "integerConstant", 0
  XML_TAG_FLOATCONST db "floatConstant", 0
  XML_TAG_STRINGCONST db "stringConstant", 0
  XML_TAG_UNDEFINED db "undefined", 0
  
  ; STATMENTS
  XML_TAG_STATMENT_STATMENT db "statement", 0
  XML_TAG_STATMENT_LET db "statement", 0
  XML_TAG_STATMENT_WHILE db "statement", 0
  XML_TAG_STATMENT_IF db "statement", 0
  XML_TAG_STATMENT_DO db "statement", 0
  XML_TAG_STATMENT_RETURN db "statement", 0
  ; EXPRESSIONS
  XML_TAG_EXPRESSION_EXPRESSION db "statement", 0
  XML_TAG_EXPRESSION_TERM db "statement", 0
  XML_TAG_EXPRESSION_SUBROUTINE_CALL db "statement", 0
  XML_TAG_EXPRESSION_EXPRESSION_LIST db "statement", 0
  XML_TAG_EXPRESSION_BINARY_OPERATOR db "statement", 0
  XML_TAG_EXPRESSION_UNARY_OPERATOR db "statement", 0
  XML_TAG_EXPRESSION_KEYWORD_CONSTANT db "statement", 0

; This section hold helpers for build the .xml file
section .bss
  _xmler_filedescriptor resb 2
  _xmler_digit resb 8
  _xmler_identation resb 8

; Save in filedescriptor
%macro start_xml_file 1
  mov rax, %1
  mov [_xmler_filedescriptor], rax
%endmacro

%macro before_close_xml_file 0
  mov rax, [_xmler_filedescriptor]
%endmacro

%macro open_xml_tag 1
  ; Identation
  
  ; Increment identation
  mov rax, [_xmler_identation]
  inc rax
  mov [_xmler_identation], rax
%endmacro

%macro close_xml_tag 1

  mov rax, ASCII_NEWLINE
  
  mov rax, SYS_WRITE
  mov rdi, %1
  mov rsi, ASCII_NEWLINE
  mov rdx, 1
  syscall
%endmacro

%macro write_digit_to_file 1
  ; <pop-on-finish>
  push rsi
  push rdi
  push rdx
  ; </pop-on-finish>

  mov [_xmler_digit], rax
  mov rsi, _xmler_digit ; &content
  
  mov rax, SYS_WRITE
  mov rdi, %1
  ; &content is already in RSI
  mov rdx, 1
  syscall

  ; <pushed>
  pop rdx
  pop rdi
  pop rsi
  ; </pushed>
%endmacro

%macro write_rax_to_file 1
  ; <pop-on-finish>
  push rsi
  ; </pop-on-finish>

  mov rsi, rax ; &content
  mov rax, 0 ; char
  mov rdx, 0 ; char count

  %%write_rax_to_file_loop:
    mov rax, [rsi + rdx]
    inc rdx
    cmp al, 0
    jne %%write_rax_to_file_loop

  dec rdx

  mov rax, SYS_WRITE
  mov rdi, %1
  ; &content is already in RSI
  syscall

  ; <pushed>
  pop rsi
  ; </pushed>
%endmacro

%macro write_token_to_xml 1
  ; <pop-on-finish>
  push rsi
  ; </pop-on-finish>
  
  mov rdi, %1 ; &filedescriptor
  mov rcx, rax

  push rdx ; &token

  cmp rbx, JACK_TOKEN_KEYWORD
  je %%write_tag_keyword

  cmp rbx, JACK_TOKEN_SYMBOL
  je %%write_tag_symbol

  cmp rbx, JACK_TOKEN_IDENTIFIER
  je %%write_tag_identifier

  cmp rbx, JACK_CONSTANT_INTEGER
  je %%write_tag_intconst

  cmp rbx, JACK_CONSTANT_STRING
  je %%write_tag_strconst

  jmp %%write_tag_undefined
  
  %%write_tag_symbol:
    mov rbx, XML_TAG_SYMBOL
    jmp %%write_xml_tag_and_content
  
  %%write_tag_keyword:
    mov rbx, XML_TAG_KEYWORD
    jmp %%write_xml_tag_and_content
  
  %%write_tag_identifier:
    mov rbx, XML_TAG_IDENTIFIER
    jmp %%write_xml_tag_and_content
  
  %%write_tag_intconst:
    mov rbx, XML_TAG_INTCONST
    jmp %%write_xml_tag_and_content
  
  %%write_tag_strconst:
    mov rbx, XML_TAG_STRINGCONST
    jmp %%write_xml_tag_and_content
  
  %%write_tag_undefined:
    mov rbx, XML_TAG_UNDEFINED
    jmp %%write_xml_tag_and_content
  
  %%write_xml_tag_and_content:
    ; WRITE OPEN TAG
    mov rax, ASCII_LESSTHAN
    write_digit_to_file rdi
    
    mov rax, rbx ; get &tag in RBX
    write_rax_to_file rdi

    mov rax, ASCII_GREATERTHAN
    write_digit_to_file rdi

    ; WRITE SPACE
    mov rax, ASCII_ESPACE
    write_digit_to_file rdi

    ; WRITE CONTENT
    pop rax ; &token
    write_rax_to_file rdi

    ; WRITE SPACE
    mov rax, ASCII_ESPACE
    write_digit_to_file rdi
    
    ; WRITE CLOSE TAG
    mov rax, ASCII_LESSTHAN
    write_digit_to_file rdi
    
    mov rax, ASCII_SOL
    write_digit_to_file rdi

    mov rax, rbx ; get &tag in RBX
    write_rax_to_file rdi

    mov rax, ASCII_GREATERTHAN
    write_digit_to_file rdi
    
    jmp %%end

  %%end:
    mov rbx, rdi
    ; <pushed>
    pop rsi
    ; </pushed>
%endmacro