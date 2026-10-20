%{
#include <stdio.h>

int yylex();
void yyerror(const char *s);
%}

%token INT FLOAT CHAR DOUBLE
%token IF ELSE WHILE FOR
%token EQ NE LE GE LT GT
%token ASSIGN
%token PLUS MINUS MUL DIV
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token ID NUM

%%

program:
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
      declaration
    | assignment
    | if_stmt
    | while_stmt
    | for_stmt
    ;

declaration:
      INT ID SEMICOLON
    | FLOAT ID SEMICOLON
    | CHAR ID SEMICOLON
    | DOUBLE ID SEMICOLON
    ;

assignment:
    ID ASSIGN expression SEMICOLON
    ;

expression:
      expression PLUS expression
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | ID
    | NUM
    ;

condition:
      expression LT expression
    | expression GT expression
    | expression LE expression
    | expression GE expression
    | expression EQ expression
    | expression NE expression
    ;

if_stmt:
    IF LPAREN condition RPAREN statement
    ;

while_stmt:
    WHILE LPAREN condition RPAREN statement
    ;

for_stmt:
    FOR LPAREN assignment condition SEMICOLON assignment RPAREN statement
    ;

%%

int main()
{
    printf("Enter input:\n");

    if (yyparse() == 0)
        printf("Valid Syntax\n");

    return 0;
}

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}
