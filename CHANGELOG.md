# Change log
All notable changes to this project will be documented in this file.

## 1.0.1 - 2021-06-26
### Lexer
  - Bugfix: wrong DFA transitions at token_type_dfa
  - Feature: now add invalid characters to .xml

## 1.0.0 - 2021-06-26
### Lexer
  - Specify basic JACK language tokens
  - Create [DFA (Deterministic Finite Automaton) for identify tokens](docs/jack-tokens-dfa.pdf)
  - Create DFA (Deterministic Finite Automaton) for identify token type
  - Export tokens to .xml