# Assembly Jack Compiler

![Assembly](https://img.shields.io/badge/-Assembly-FF6946?logo=AssemblyScript)

<div style="width: 100%; display: flex; justify-content: center">
  <img src="https://raw.githubusercontent.com/PKief/vscode-material-icon-theme/main/icons/assembly.svg" width="250">
</div>

## Description
A `.jack` program compiler create with assembly language.

## Local Development
How to run locally:

### Compiling

Detect your system architecture:
- **Linux**: `uname -m`

Generate `.o` file:
- **Linux**: `nasm -f elf64 -o main.o main.asm`

Generate executable file:
- **Linux**: `ld main.o -o main`

Run the program:
- **Linux**: `./main`

## Contribuitors
<table>
  <tr>
    <td align="center">
      <a href="https://github.com/alexaragao">
        <img src="https://avatars.githubusercontent.com/u/43763150?s=100" width="100px;" alt="Alexandre Aragão"/>
        <br />
        <b>Alexandre Aragão</b>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/nathyanemoreno">
        <img src="https://avatars.githubusercontent.com/u/40841909?s=100" width="100px;" alt="Nathyane Moreno"/>
        <br />
        <b>Nathyane Moreno</b>
      </a>
    </td>
  </tr>
</table>