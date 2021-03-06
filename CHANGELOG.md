# Change log
All notable changes to this project will be documented in this file.

## 1.2.0 - 2021-07-15
### Lexer
  - Bugfix: wrong DFA transitions at states 1019, 1021 and 1022.
  - Feature: DFA also return token UUID
### Xmler
### Synatxer
  - First release

## 1.1.1 - 2021-06-28
### Lexer
  - Bugfix: Stop peek at undefined tokens

### Xmler
  - Bugfix: Stop peek at undefined tokens
  - Bugfix: Not write undefined tokens

## 1.1.0 - 2021-06-28
- Bugfix: Removed float token
- Update: Create program `xmler` to generate .xml
### Lexer
  - Update: Now `lexer` only do lexic validation
  - Update: Merged jack_tokenizer DFAs into single DFA
### Xmler
  - Prevent append to .xml output file
  - Command line .jack input file and .xml outuput file

## 1.0.1 - 2021-06-26
### Lexer
  - Bugfix: wrong DFA transitions at token_type_dfa
  - Feature: now add invalid characters to .xml

## 1.0.0 - 2021-06-26
### Lexer
  - Specify basic JACK language tokens
  - Create [DFA (Deterministic Finite Automaton) for identify tokens](docs/jack-tokenizer-dfa.pdf)
  - Create DFA (Deterministic Finite Automaton) for identify token type
  - Export tokens to .xml