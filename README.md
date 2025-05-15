# Gujarati Programming Language Compiler

This project is a **custom compiler** for a domain-specific programming language using **Hindi keywords written in Gujarati transliteration**. It is built using **Flex** (Lex) and **Bison** (Yacc) and outputs intermediate **three-address code**.

---

## Features

- Variable declarations using `purnank` (integer type)
- Arithmetic expressions and assignments
- `jo` and `nahitoh` for conditional statements (if-else)
- `badlo` with `prkar` and `mulbhut` for switch-case logic
- Intermediate code generation (3-address format)

---

## Sample Program (input.txt)

```c
purnank x;
purnank y;
purnank z;

x = 10;
y = 20;
z = x + y;

jo (x == 10) {
    z = z * 2;
}

jo (z > y) {
    y = y + 10;
} nahitoh {
    y = y - 5;
}

badlo (x) {
    prkar 5:
        z = 50;
    prkar 10:
        z = 100;
    mulbhut:
        z = 0;
}



[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/bPoO8GTw)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=19525180&assignment_repo_type=AssignmentRepo)
