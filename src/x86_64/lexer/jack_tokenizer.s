section .bss
  token resb 1024

%macro jack_tokenizer 2
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
    call %%rax_is_numeric
    cmp rdi, 0
    je %%DFA_STATE_2000

    ; KEYWORD TOKENS
    cmp al, ASCII_c
    je %%DFA_STATE_4

    cmp al, ASCII_f
    je %%DFA_STATE_26

    cmp al, ASCII_m
    je %%DFA_STATE_35

    cmp al, ASCII_s
    je %%DFA_STATE_41

    cmp al, ASCII_v
    je %%DFA_STATE_49

    cmp al, ASCII_t
    je %%DFA_STATE_56

    cmp al, ASCII_i
    je %%DFA_STATE_61

    cmp al, ASCII_w
    je %%DFA_STATE_64

    cmp al, ASCII_b
    je %%DFA_STATE_69

    cmp al, ASCII_n
    je %%DFA_STATE_76

    cmp al, ASCII_l
    je %%DFA_STATE_80

    cmp al, ASCII_d
    je %%DFA_STATE_83

    cmp al, ASCII_e
    je %%DFA_STATE_45

    cmp al, ASCII_r
    je %%DFA_STATE_89

    ; cmp al, 0
    ; je %%stop_peek

    ; call %%push_character_token
    ; call %%peek_character

    call %%rax_is_alpha_or_underscore
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%stop_peek

  %%DFA_STATE_1:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_2

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_2:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_3

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_3:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_4:
    call %%push_character_token
    call %%peek_character

    cmp al, ASCII_l
    je %%DFA_STATE_5

    cmp al, ASCII_h
    je %%DFA_STATE_1
    
    cmp al, ASCII_o
    je %%DFA_STATE_9

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_5:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_6

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_6:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_7

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_7:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_8

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
    ; FINAL
  %%DFA_STATE_8:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_9:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_10

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_10:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_11

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_11:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_12

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_12:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_13

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_13:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_14

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_14:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_15

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_15:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_16

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_16:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_17

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_17:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_18

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_18:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_19:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_20

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_20:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_21

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_21:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_22

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_22:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_23

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_23:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_24

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_24:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_25

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_25:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_26:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_19

    cmp al, ASCII_a
    je %%DFA_STATE_27

    cmp al, ASCII_i
    je %%DFA_STATE_31
    
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_27:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_28

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_28:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_29

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_29:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_30

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_30:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_31:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_32

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_32:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_33

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_33:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_34

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_34:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_35:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_36

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_36:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_37

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_37:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_38

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_38:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_39

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_39:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_40

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_40:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_41:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_42

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_42:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_43

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_43:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_44

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_44:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_45

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_45:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_46

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_46:
    call %%push_character_token
    call %%peek_character
    
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_47:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_48

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_48:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_49:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_47

    cmp al, ASCII_o
    je %%DFA_STATE_50

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_50:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_51

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_51:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_52

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_52:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_53:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_54

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_54:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_55

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_55:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_56:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_53

    cmp al, ASCII_r
    je %%DFA_STATE_57

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_57:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_58

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_58:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_59

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_59:
    call %%push_character_token
    call %%peek_character
    
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  ; FINAL
  %%DFA_STATE_60:
    call %%push_character_token
    call %%peek_character
  
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_61:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_f
    je %%DFA_STATE_60

    cmp al, ASCII_n
    je %%DFA_STATE_62

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_62:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_63

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_63:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_64:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_65

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_65:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_66

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_66:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_67

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_67:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_68

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_68:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_69:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_70

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_70:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_71

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_71:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_72

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_72:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_73

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_73:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_74

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_74:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_75

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_75:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_76:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_77

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_77:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_78

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_78:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_79

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_79:
    call %%push_character_token
    call %%peek_character
    
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_80:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_81

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_81:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_82

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_82:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_83:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_84

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_84:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_85:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_86

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_86:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_87

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_87:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_88

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_88:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_89:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_90

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_90:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_91

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_91:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_92

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_92:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_93

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_93:
    call %%push_character_token
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_94

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  ; FINAL
  %%DFA_STATE_94:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_keyword
  
  %%DFA_STATE_3000:
    call %%push_character_token
    call %%peek_character
    
    call %%rax_is_identifier_char
    cmp rdi, 0
    je %%DFA_STATE_3000

    jmp %%is_identifier
  
  %%DFA_STATE_1000:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1002:
    call %%peek_character

    cmp al, ASCII_SOL
    je %%DFA_STATE_1003

    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1004
    
    mov rax, ASCII_SOL
    call %%push_character_token
    
    jmp %%is_symbol
  
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

    jmp %%is_symbol
  
  %%DFA_STATE_1008:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1009:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1010:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1011:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1012:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1013:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1014:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1015:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1016:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1017:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1018:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
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

    jmp %%is_symbol
  
  %%DFA_STATE_1020:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
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

    jmp %%is_symbol
  
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

    jmp %%is_symbol
  
  %%DFA_STATE_1023:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1024:
    call %%push_character_token
    call %%peek_character

    jmp %%is_symbol
  
  %%DFA_STATE_1025:
    call %%peek_character
    
    cmp al, ASCII_QUOT
    je %%DFA_STATE_1026

    call %%push_character_token
    
    jmp %%DFA_STATE_1025
  
  %%DFA_STATE_1026:
    call %%peek_character

    jmp %%is_string_constant
  
  ; INTEGERS
  %%DFA_STATE_2000:
    call %%push_character_token
    call %%peek_character

    call %%rax_is_numeric
    cmp rdi, 0
    je %%DFA_STATE_2000

    jmp %%is_integer_constant
  
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
  
  %%is_keyword:
    mov rdx, JACK_TOKEN_KEYWORD
    jmp %%stop_peek
  
  %%is_identifier:
    mov rdx, JACK_TOKEN_IDENTIFIER
    jmp %%stop_peek

  %%is_symbol:
    mov rdx, JACK_TOKEN_SYMBOL
    jmp %%stop_peek

  %%is_integer_constant:
    mov rdx, JACK_TOKEN_INTEGER_CONSTANT
    jmp %%stop_peek

  %%is_string_constant:
    mov rdx, JACK_TOKEN_STRING_CONSTANT
    jmp %%stop_peek

  %%rax_is_alpha_or_underscore:
    cmp al, ASCII_UNDERSCORE
    je %%accept

    is_between rax, ASCII_A, ASCII_Z
    cmp rdi, 0
    je %%accept

    is_between rax, ASCII_a, ASCII_z
    cmp rdi, 0
    je %%accept
    
    mov rdi, 1
    ret
  
  %%rax_is_numeric:
    is_between rax, ASCII_0, ASCII_9
    cmp rdi, 0
    je %%accept

    mov rdi, 1
    ret
  
  %%rax_is_identifier_char:
    call %%rax_is_alpha_or_underscore
    cmp rdi, 0
    je %%accept
    
    call %%rax_is_numeric
    cmp rdi, 0
    je %%accept

    mov rdi, 1
    ret

  %%accept:
    mov rdi, 0
    ret
  
  %%stop_peek:
    dec rsi
    mov rax, token
%endmacro