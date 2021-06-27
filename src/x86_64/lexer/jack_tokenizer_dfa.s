section .bss
  token resb 1024
  char resb 8

%macro jack_tokenizer_dfa 2
  mov rbx, %1
  mov rsi, %2
  
  mov rax, 0
  mov rdx, 0

  %%reset_token:
    mov rcx, 0

    %%reset_token_loop:
      mov al, [token + rcx]
      
      mov [token + rcx], rdx
      inc rcx

      cmp al, 0
      jne %%reset_token_loop
    
    mov rcx, 0

  %%DFA_STATE_0:
    call %%peek_character

    ; SKIP CHARACTERS
    cmp al, ASCII_NEWLINE
    je %%DFA_STATE_0

    cmp al, ASCII_ESPACE
    je %%DFA_STATE_0

    cmp al, ASCII_TAB
    je %%DFA_STATE_0
    
    ; SYMBOL TOKENS
    mov rdx, JACK_TOKEN_SYMBOL
    
    cmp al, ASCII_EXCL
    je %%DFA_STATE_1000
    
    cmp al, ASCII_SOL
    je %%DFA_STATE_1002
    
    cmp al, ASCII_LCUB
    je %%DFA_STATE_1007
    
    cmp al, ASCII_RCUB
    je %%DFA_STATE_1008

    cmp al, ASCII_LPARENTHESIS
    je %%DFA_STATE_1009

    cmp al, ASCII_RPARENTHESIS
    je %%DFA_STATE_1010
    
    cmp al, ASCII_LSQB
    je %%DFA_STATE_1011

    cmp al, ASCII_RSQB
    je %%DFA_STATE_1012

    cmp al, ASCII_PERIOD
    je %%DFA_STATE_1013

    cmp al, ASCII_COMMA
    je %%DFA_STATE_1014

    cmp al, ASCII_SEMICOLON
    je %%DFA_STATE_1015

    cmp al, ASCII_PLUS
    je %%DFA_STATE_1016

    cmp al, ASCII_MINUS
    je %%DFA_STATE_1017

    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1018

    cmp al, ASCII_AMP
    je %%DFA_STATE_1019

    cmp al, ASCII_VERBAR
    je %%DFA_STATE_1020

    cmp al, ASCII_LESSTHAN
    je %%DFA_STATE_1021

    cmp al, ASCII_GREATERTHAN
    je %%DFA_STATE_1022

    cmp al, ASCII_EQUAL
    je %%DFA_STATE_1023

    cmp al, ASCII_TILDE
    je %%DFA_STATE_1024

    cmp al, ASCII_QUOT
    je %%DFA_STATE_1025

    ; NUMBERS TOKENS
    mov rdx, JACK_TOKEN_NUMBER_UNDEFINED

    is_between rax, ASCII_0, ASCII_9
    cmp rdi, 0
    je %%DFA_STATE_2000

    ; OTHERS TOKENS
    mov rdx, JACK_TOKEN_UNDEFINED

    cmp al, ASCII_UNDERSCORE
    je %%DFA_STATE_1

    is_between rax, ASCII_A, ASCII_Z
    cmp rdi, 0
    je %%DFA_STATE_1

    is_between rax, ASCII_a, ASCII_z
    cmp rdi, 0
    je %%DFA_STATE_1

    cmp al, 0
    je %%stop_peek

    mov rdx, JACK_TOKEN_INVALID
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek

  %%DFA_STATE_1:
    call %%push_character_token
    call %%peek_character
    
    ; OTHERS TOKENS
    cmp al, ASCII_UNDERSCORE
    je %%DFA_STATE_1

    is_between rax, ASCII_0, ASCII_9
    cmp rdi, 0
    je %%DFA_STATE_1

    is_between rax, ASCII_A, ASCII_Z
    cmp rdi, 0
    je %%DFA_STATE_1

    is_between rax, ASCII_a, ASCII_z
    cmp rdi, 0
    je %%DFA_STATE_1

    jmp %%stop_peek
  
  %%DFA_STATE_1000:
    call %%push_character_token
    call %%peek_character

    cmp al, ASCII_EQUAL
    je %%DFA_STATE_1001

    jmp %%stop_peek
  
  %%DFA_STATE_1001:
    jmp %%stop_peek
  
  %%DFA_STATE_1002:
    call %%peek_character

    cmp al, ASCII_SOL
    je %%DFA_STATE_1003

    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1004
    
    mov rax, ASCII_SOL
    call %%push_character_token
    
    jmp %%stop_peek
  
  %%DFA_STATE_1003:
    call %%peek_character

    cmp al, ASCII_NEWLINE
    je %%DFA_STATE_0

    jmp %%DFA_STATE_1003
  
  %%DFA_STATE_1004:
    call %%peek_character

    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1005

    jmp %%DFA_STATE_1004
  
  %%DFA_STATE_1005:
    call %%peek_character
    
    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1005

    cmp al, ASCII_SOL
    je %%DFA_STATE_0

    jmp %%DFA_STATE_1004
  
  %%DFA_STATE_1007:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1008:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1009:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1010:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1011:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1012:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1013:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1014:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1015:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1016:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1017:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1018:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1019:
    mov rax, ASCII_AMP
    call %%push_character_token
    mov rax, ASCII_a
    call %%push_character_token
    mov rax, ASCII_m
    call %%push_character_token
    mov rax, ASCII_p
    call %%push_character_token
    mov rax, ASCII_SEMICOLON
    call %%push_character_token

    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1020:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1021:
    mov rax, ASCII_AMP
    call %%push_character_token
    mov rax, ASCII_l
    call %%push_character_token
    mov rax, ASCII_t
    call %%push_character_token
    mov rax, ASCII_SEMICOLON
    call %%push_character_token

    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1022:
    mov rax, ASCII_AMP
    call %%push_character_token
    mov rax, ASCII_g
    call %%push_character_token
    mov rax, ASCII_t
    call %%push_character_token
    mov rax, ASCII_SEMICOLON
    call %%push_character_token

    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1023:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1024:
    call %%push_character_token
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1025:
    mov rdx, JACK_TOKEN_STRING_CONSTANT
    call %%peek_character
    
    cmp al, ASCII_QUOT
    je %%DFA_STATE_1026

    call %%push_character_token
    
    jmp %%DFA_STATE_1025
  
  %%DFA_STATE_1026:
    call %%peek_character

    jmp %%stop_peek
  
  ; INTEGERS
  %%DFA_STATE_2000:
    mov rdx, JACK_TOKEN_INTEGER_CONSTANT

    call %%push_character_token
    call %%peek_character

    cmp al, ASCII_PERIOD
    je %%DFA_STATE_2001

    is_between rax, ASCII_0, ASCII_9
    cmp rdi, 0
    je %%DFA_STATE_2000

    jmp %%stop_peek
  
  ; FLOATS
  %%DFA_STATE_2001:
    mov rdx, JACK_TOKEN_FLOAT_CONSTANT
    
    call %%push_character_token
    call %%peek_character

    is_between rax, ASCII_0, ASCII_9
    cmp rdi, 0
    je %%DFA_STATE_2001

    jmp %%stop_peek
  
  %%peek_character:
    mov al, [rbx + rsi]
    inc rsi

    ; This code is supposed to work at the end of the file
    ; thus, DO NOT UNCOMMENT IT!
    ; cmp al, 0
    ; je %%stop_peek

    ret
  
  %%push_character_token:
    mov [token + rcx], al
    inc rcx

    ret
  
  %%determinate_token_type:
    jack_token_type_adf token
    ; RDX -> jack token type
    
    jmp %%end
  
  %%stop_peek:
    cmp rdx, JACK_TOKEN_UNDEFINED
    je %%determinate_token_type
    
    jmp %%end
  
  %%end:
    dec rsi
    mov rax, token
%endmacro