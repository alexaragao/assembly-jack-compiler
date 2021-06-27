section .data
  rtoken db "TOKEN <",0
  ltoken db ">",10,0

%macro jack_token_type_adf 1
  ; <pop-on-finish>
  push rax
  push rbx
  push rsi
  push rdi
  ; </pop-on-finish>

  mov rbx, %1
  mov rdx, JACK_TOKEN_UNDEFINED
  mov rsi, 0
  
  mov rax, 0

  mov rdx, JACK_TOKEN_IDENTIFIER

  %%DFA_STATE_0:
    call %%peek_character

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

    jmp %%stop_peek

  %%DFA_STATE_1:
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_2

    jmp %%stop_peek
  
  %%DFA_STATE_2:
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_3

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_3:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_4:
    call %%peek_character

    cmp al, ASCII_l
    je %%DFA_STATE_5

    cmp al, ASCII_h
    je %%DFA_STATE_1
    
    cmp al, ASCII_o
    je %%DFA_STATE_9

    jmp %%stop_peek
  
  %%DFA_STATE_5:
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_6

    jmp %%stop_peek
  
  %%DFA_STATE_6:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_7

    jmp %%stop_peek
  
  %%DFA_STATE_7:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_8

    jmp %%stop_peek
  
    ; FINAL
  %%DFA_STATE_8:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_9:
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_10

    jmp %%stop_peek
  
  %%DFA_STATE_10:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_11

    jmp %%stop_peek
  
  %%DFA_STATE_11:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_12

    jmp %%stop_peek
  
  %%DFA_STATE_12:
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_13

    jmp %%stop_peek
  
  %%DFA_STATE_13:
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_14

    jmp %%stop_peek
  
  %%DFA_STATE_14:
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_15

    jmp %%stop_peek
  
  %%DFA_STATE_15:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_16

    jmp %%stop_peek
  
  %%DFA_STATE_16:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_17

    jmp %%stop_peek
  
  %%DFA_STATE_17:
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_18

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_18:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_19:
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_20

    jmp %%stop_peek
  
  %%DFA_STATE_20:
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_21

    jmp %%stop_peek
  
  %%DFA_STATE_21:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_22

    jmp %%stop_peek
  
  %%DFA_STATE_22:
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_23

    jmp %%stop_peek
  
  %%DFA_STATE_23:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_24

    jmp %%stop_peek
  
  %%DFA_STATE_24:
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_25

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_25:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_26:
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_19

    cmp al, ASCII_a
    je %%DFA_STATE_27

    cmp al, ASCII_i
    je %%DFA_STATE_31
    
    jmp %%stop_peek
  
  %%DFA_STATE_27:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_28

    jmp %%stop_peek
  
  %%DFA_STATE_28:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_29

    jmp %%stop_peek
  
  %%DFA_STATE_29:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_30

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_30:
    call %%peek_character
  
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_31:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_32

    jmp %%stop_peek
  
  %%DFA_STATE_32:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_33

    jmp %%stop_peek
  
  %%DFA_STATE_33:
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_34

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_34:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_35:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_36

    jmp %%stop_peek
  
  %%DFA_STATE_36:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_37

    jmp %%stop_peek
  
  %%DFA_STATE_37:
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_38

    jmp %%stop_peek
  
  %%DFA_STATE_38:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_39

    jmp %%stop_peek
  
  %%DFA_STATE_39:
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_40

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_40:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_41:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_42

    jmp %%stop_peek
  
  %%DFA_STATE_42:
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_43

    jmp %%stop_peek
  
  %%DFA_STATE_43:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_44

    jmp %%stop_peek
  
  %%DFA_STATE_44:
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_45

    jmp %%stop_peek
  
  %%DFA_STATE_45:
    call %%peek_character
    
    cmp al, ASCII_c
    je %%DFA_STATE_46

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_46:
    call %%peek_character
  
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_47:
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_48

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_48:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_49:
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_47

    cmp al, ASCII_o
    je %%DFA_STATE_50

    jmp %%stop_peek
  
  %%DFA_STATE_50:
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_51

    jmp %%stop_peek
  
  %%DFA_STATE_51:
    call %%peek_character
    
    cmp al, ASCII_d
    je %%DFA_STATE_52

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_52:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_53:
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_54

    jmp %%stop_peek
  
  %%DFA_STATE_54:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_55

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_55:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_56:
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_53

    cmp al, ASCII_r
    je %%DFA_STATE_57

    jmp %%stop_peek
  
  %%DFA_STATE_57:
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_58

    jmp %%stop_peek
  
  %%DFA_STATE_58:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_59

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_59:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_60:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_61:
    call %%peek_character
    
    cmp al, ASCII_f
    je %%DFA_STATE_60

    cmp al, ASCII_n
    je %%DFA_STATE_62

    jmp %%stop_peek
  
  %%DFA_STATE_62:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_63

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_63:
    call %%peek_character
    
    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_64:
    call %%peek_character
    
    cmp al, ASCII_h
    je %%DFA_STATE_65

    jmp %%stop_peek
  
  %%DFA_STATE_65:
    call %%peek_character
    
    cmp al, ASCII_i
    je %%DFA_STATE_66

    jmp %%stop_peek
  
  %%DFA_STATE_66:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_67

    jmp %%stop_peek
  
  %%DFA_STATE_67:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_68

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_68:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_69:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_70

    jmp %%stop_peek
  
  %%DFA_STATE_70:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_71

    jmp %%stop_peek
  
  %%DFA_STATE_71:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_72

    jmp %%stop_peek
  
  %%DFA_STATE_72:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_73

    jmp %%stop_peek
  
  %%DFA_STATE_73:
    call %%peek_character
    
    cmp al, ASCII_a
    je %%DFA_STATE_74

    jmp %%stop_peek
  
  %%DFA_STATE_74:
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_75

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_75:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_76:
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_77

    jmp %%stop_peek
  
  %%DFA_STATE_77:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_78

    jmp %%stop_peek
  
  %%DFA_STATE_78:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_79

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_79:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_80:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_81

    jmp %%stop_peek
  
  %%DFA_STATE_81:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_82

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_82:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_83:
    call %%peek_character
    
    cmp al, ASCII_o
    je %%DFA_STATE_84

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_84:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_85:
    call %%peek_character
    
    cmp al, ASCII_l
    je %%DFA_STATE_86

    jmp %%stop_peek
  
  %%DFA_STATE_86:
    call %%peek_character
    
    cmp al, ASCII_s
    je %%DFA_STATE_87

    jmp %%stop_peek
  
  %%DFA_STATE_87:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_88

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_88:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_89:
    call %%peek_character
    
    cmp al, ASCII_e
    je %%DFA_STATE_90

    jmp %%stop_peek
  
  %%DFA_STATE_90:
    call %%peek_character
    
    cmp al, ASCII_t
    je %%DFA_STATE_91

    jmp %%stop_peek
  
  %%DFA_STATE_91:
    call %%peek_character
    
    cmp al, ASCII_u
    je %%DFA_STATE_92

    jmp %%stop_peek
  
  %%DFA_STATE_92:
    call %%peek_character
    
    cmp al, ASCII_r
    je %%DFA_STATE_93

    jmp %%stop_peek
  
  %%DFA_STATE_93:
    call %%peek_character
    
    cmp al, ASCII_n
    je %%DFA_STATE_94

    jmp %%stop_peek
  
  ; FINAL
  %%DFA_STATE_94:
    call %%peek_character

    cmp al, 0
    je %%is_keyword

    jmp %%stop_peek
  
  %%DFA_STATE_1000:
    call %%peek_character

    cmp al, ASCII_EQUAL
    je %%DFA_STATE_1001

    jmp %%stop_peek
  
  %%DFA_STATE_1001:
    jmp %%stop_peek
  
  %%DFA_STATE_1002:
    push rdx
    call %%peek_character

    cmp al, ASCII_SOL
    je %%DFA_STATE_1003

    cmp al, ASCII_ASTERISK
    je %%DFA_STATE_1004
    
    pop rdx
    dec rdx
    call %%peek_character
    
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

    cmp al, ASCII_SOL
    je %%DFA_STATE_0

    jmp %%DFA_STATE_1004
  
  ; %%DFA_STATE_1006:
    ; call %%peek_character

    ; jmp %%DFA_STATE_1004
  
  %%DFA_STATE_1007:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1008:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1009:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1010:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1011:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1012:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1013:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1014:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1015:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1016:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1017:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1018:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1019:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1020:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1021:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1022:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1023:
    call %%peek_character

    jmp %%stop_peek
  
  %%DFA_STATE_1024:
    call %%peek_character

    jmp %%stop_peek
  
  ; INTEGERS
  %%DFA_STATE_2000:
    call %%peek_character

    cmp al, ASCII_PERIOD
    je %%DFA_STATE_2001

    is_between rax, 48, 50
    cmp rdi, 0
    je %%DFA_STATE_2000

    jmp %%stop_peek
  
  ; FLOATS
  %%DFA_STATE_2001:
    call %%peek_character

    is_between rax, 48, 50
    cmp rdi, 0
    je %%DFA_STATE_2001

    jmp %%stop_peek
  
  %%peek_character:
    mov al, [rbx + rsi]
    inc rsi
    
    ret
  
  %%stop_peek:
    jmp %%end

  %%is_keyword:
    mov rdx, JACK_TOKEN_KEYWORD
    jmp %%end

  %%end:
    ; <pushed>
    pop rdi
    pop rsi
    pop rbx
    pop rax
    ; </pushed>
%endmacro