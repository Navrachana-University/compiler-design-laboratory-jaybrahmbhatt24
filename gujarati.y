%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *s);
int temp_count = 0;
int label_count = 0;

char* new_temp() {
    char *temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

char* new_label(const char *prefix) {
    char *label = malloc(20);
    sprintf(label, "%s%d", prefix, label_count++);
    return label;
}

void emit_tac(char *op, char *arg1, char *arg2, char *result) {
    if (arg2)
        printf("%s = %s %s %s\n", result, arg1, op, arg2);
    else
        printf("%s = %s\n", result, arg1);
}

void emit_jump(char *label) {
    printf("goto %s\n", label);
}

void emit_label(char *label) {
    printf("%s:\n", label);
}
%}

%union {
    int num;
    char *str;
}

%token <num> NUMBER
%token <str> ID
%token IF ELSE SWITCH CASE DEFAULT INT VARIABLE
%token PLUS MINUS MUL DIV ASSIGN EQ GT LT
%token LBRACE RBRACE LPAREN RPAREN COLON SEMICOLON

%type <str> expr stmt case_stmt switch_expr

%left EQ GT LT
%left PLUS MINUS
%left MUL DIV

%%

program:
    stmt_list { printf("Compilation successful!\n"); }
    ;

stmt_list:
    stmt stmt_list
    | /* empty */
    ;

stmt:
    INT ID SEMICOLON { 
        printf("declare %s\n", $2); 
        free($2); 
    }
    | ID ASSIGN expr SEMICOLON {
        emit_tac("", $3, NULL, $1);
        free($1);
        free($3);
    }
    | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE {
        char *if_end = new_label("IF_END_");
        printf("if not %s goto %s\n", $3, if_end);
        emit_label($3); // True branch
        emit_label(if_end);
        free($3);
        free(if_end);
    }
    | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE {
        char *else_label = new_label("ELSE_");
        char *if_end = new_label("IF_END_");
        printf("if not %s goto %s\n", $3, else_label);
        emit_label($3); // True branch
        emit_jump(if_end);
        emit_label(else_label); // Else branch
        emit_label(if_end);
        free($3);
        free(else_label);
        free(if_end);
    }
    | SWITCH LPAREN switch_expr RPAREN LBRACE case_list DEFAULT COLON stmt_list RBRACE {
        char *switch_end = new_label("SWITCH_END_");
        emit_label(switch_end);
        free($3); // Free switch_expr
        free(switch_end);
    }
    ;

switch_expr:
    ID { $$ = strdup($1); } // Store the switch variable
    ;

case_list:
    case_stmt case_list
    | /* empty */
    ;

case_stmt:
    CASE NUMBER COLON stmt_list {
        char *case_label = new_label("CASE_");
        printf("if %s == %d goto %s\n", $<str>0, $2, case_label);
        emit_label(case_label);
        $$ = case_label;
    }
    ;

expr:
    NUMBER { 
        $$ = new_temp(); 
        printf("%s = %d\n", $$, $1); 
    }
    | ID { $$ = strdup($1); }
    | expr PLUS expr {
        $$ = new_temp();
        emit_tac("+", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr MINUS expr {
        $$ = new_temp();
        emit_tac("-", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr MUL expr {
        $$ = new_temp();
        emit_tac("*", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr DIV expr {
        $$ = new_temp();
        emit_tac("/", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr EQ expr {
        $$ = new_label("IF_TRUE_");
        printf("if %s == %s goto %s\n", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr GT expr {
        $$ = new_label("IF_TRUE_");
        printf("if %s > %s goto %s\n", $1, $3, $$);
        free($1);
        free($3);
    }
    | expr LT expr {
        $$ = new_label("IF_TRUE_");
        printf("if %s < %s goto %s\n", $1, $3, $$);
        free($1);
        free($3);
    }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}