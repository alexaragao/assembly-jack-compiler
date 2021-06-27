section .data
  XML_OTAG_TOKENS db "<tokens>",0
  XML_CTAG_TOKENS db 10,"</tokens>",0
  XML_OTAG_SYMBOL db 10,9,"<symbol> ",0
  XML_CTAG_SYMBOL db " </symbol>",0
  XML_OTAG_KEYWORD db 10,9,"<keyword> ",0
  XML_CTAG_KEYWORD db " </keyword>",0
  XML_OTAG_IDENTIFIER db 10,9,"<identifier> ",0
  XML_CTAG_IDENTIFIER db " </identifier>",0
  XML_OTAG_INTCONST db 10,9,"<integerConstant> ",0
  XML_CTAG_INTCONST db " </integerConstant>",0
  XML_OTAG_FLOATCONST db 10,9,"<floatConstant> ",0
  XML_CTAG_FLOATCONST db " </floatConstant>",0
  XML_OTAG_STRINGCONST db 10,9,"<stringConstant> ",0
  XML_CTAG_STRINGCONST db " </stringConstant>",0
  XML_OTAG_UNKNOW db 10,9,"<?unknow> ",0
  XML_CTAG_UNKNOW db " </?unknow>",0

; File descriptor should be in RAX
%macro write_open_tag_tokens_to_xml 0
  mov rdi, rax ; &filedescriptor
  mov rax, SYS_WRITE
  mov rsi, XML_OTAG_TOKENS
  mov rdx, 8
  syscall

  mov rax, rdi ; &filedescriptor (keep in RAX)
%endmacro

%macro write_close_tag_tokens_to_xml 0
  mov rdi, rax ; &filedescriptor
  mov rax, SYS_WRITE
  mov rsi, XML_CTAG_TOKENS
  mov rdx, 10
  syscall
  
  mov rax, rdi ; &filedescriptor (keep in RAX)
%endmacro

%macro write_token_to_xml 0
  ; <pop-on-finish>
  push rsi
  push rcx
  ; </pop-on-finish>
  
  mov rdi, rax ; &filedescriptor
  push rdx
  push rcx

  cmp rbx, JACK_TOKEN_SYMBOL
  je %%write_tag_symbol

  cmp rbx, JACK_TOKEN_IDENTIFIER
  je %%write_tag_identifier

  cmp rbx, JACK_TOKEN_INTEGER_CONSTANT
  je %%write_tag_intconst

  cmp rbx, JACK_TOKEN_KEYWORD
  je %%write_tag_keyword

  cmp rbx, JACK_TOKEN_FLOAT_CONSTANT
  je %%write_tag_floatconst

  cmp rbx, JACK_TOKEN_STRING_CONSTANT
  je %%write_tag_strconst

  ; Prevent execution the line bellow 
  jmp %%write_tag_unknow
  
  %%write_tag_symbol:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_SYMBOL
    mov rdx, 11
    syscall

    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall
    
    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_SYMBOL
    mov rdx, 10
    syscall

    jmp %%end
  
  %%write_tag_keyword:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_KEYWORD
    mov rdx, 12
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_KEYWORD
    mov rdx, 11
    syscall
    
    jmp %%end
  
  %%write_tag_identifier:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_IDENTIFIER
    mov rdx, 15
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_IDENTIFIER
    mov rdx, 14
    syscall
    
    jmp %%end
  
  %%write_tag_intconst:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_INTCONST
    mov rdx, 20
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_INTCONST
    mov rdx, 19
    syscall
    
    jmp %%end
  
  %%write_tag_floatconst:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_FLOATCONST
    mov rdx, 21
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_FLOATCONST
    mov rdx, 20
    syscall
    
    jmp %%end
  
  %%write_tag_strconst:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_STRINGCONST
    mov rdx, 19
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_STRINGCONST
    mov rdx, 18
    syscall
    
    jmp %%end
  
  %%write_tag_unknow:
    mov rax, SYS_WRITE
    mov rsi, XML_OTAG_UNKNOW
    mov rdx, 12
    syscall
    
    mov rax, SYS_WRITE
    pop rdx
    pop rsi
    syscall

    mov rax, SYS_WRITE
    mov rsi, XML_CTAG_UNKNOW
    mov rdx, 11
    syscall
    
    jmp %%end
    
  %%end:
    mov rax, rdi
    ; <pushed>
    pop rcx
    pop rsi
    ; </pushed>
%endmacro