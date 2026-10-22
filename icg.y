%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *s);
int tc = 1, lc = 1;
char *new_temp()  { char *t = malloc(20); sprintf(t, "t%d", tc++); return t; }
char *new_label() { char *l = malloc(20); sprintf(l, "L%d", lc++); return l; }
%}

%union { char str[100]; }

%token <str> ID NUM RELOP
%token INT FLOAT CHAR DOUBLE IF ELSE WHILE FOR
%type  <str> cond expr for_increment if_head

%left '+' '-'
%left '*' '/'
%nonassoc IFX
%nonassoc ELSE

%%
program    : statements ;
statements : statements statement | statement ;

statement  : declaration
           | assignment
           | if_statement
           | while_statement
           | for_statement
           | '{' statements '}'
           ;

declaration: INT ID ';' | FLOAT ID ';' | CHAR ID ';' | DOUBLE ID ';' ;

assignment : ID '=' expr ';' { printf("%s = %s\n", $1, $3); } ;

expr : expr '+' expr { char *t = new_temp(); printf("%s = %s + %s\n", t, $1, $3); strcpy($$, t); }
     | expr '-' expr { char *t = new_temp(); printf("%s = %s - %s\n", t, $1, $3); strcpy($$, t); }
     | expr '*' expr { char *t = new_temp(); printf("%s = %s * %s\n", t, $1, $3); strcpy($$, t); }
     | expr '/' expr { char *t = new_temp(); printf("%s = %s / %s\n", t, $1, $3); strcpy($$, t); }
     | '(' expr ')'  { strcpy($$, $2); }
     | ID            { strcpy($$, $1); }
     | NUM           { strcpy($$, $1); }
     ;

cond : expr RELOP expr { sprintf($$, "%s %s %s", $1, $2, $3); } ;

/* value of if_head = false label */
if_head : IF '(' cond ')'
          {
            char *t = new_label(), *f = new_label();
            printf("if %s goto %s\ngoto %s\n%s:\n", $3, t, f, t);
            strcpy($$, f);
          }
        ;

if_statement
    : if_head statement %prec IFX { printf("%s:\n", $1); }
    | if_head statement ELSE
      {
        char *e = new_label();
        printf("goto %s\n%s:\n", e, $1);
        strcpy($<str>$, e);
      }
      statement { printf("%s:\n", $<str>4); }
    ;

while_statement
    : WHILE { strcpy($<str>$, new_label()); printf("%s:\n", $<str>$); }
      '(' cond ')'
      {
        char *b = new_label(), *x = new_label();
        printf("if %s goto %s\ngoto %s\n%s:\n", $4, b, x, b);
        strcpy($<str>$, x);
      }
      statement { printf("goto %s\n%s:\n", $<str>2, $<str>6); }
    ;

for_statement
    : FOR '(' for_init ';' { strcpy($<str>$, new_label()); printf("%s:\n", $<str>$); }
      cond ';' for_increment ')'
      {
        char *b = new_label(), *x = new_label();
        printf("if %s goto %s\ngoto %s\n%s:\n", $6, b, x, b);
        strcpy($<str>$, x);
      }
      statement { printf("%sgoto %s\n%s:\n", $8, $<str>5, $<str>10); }
    ;

for_init : ID '=' expr { printf("%s = %s\n", $1, $3); } ;

for_increment
    : ID '=' ID '+' NUM
      { char *t = new_temp(); sprintf($$, "%s = %s + %s\n%s = %s\n", t, $3, $5, $1, t); }
    ;
%%

void yyerror(const char *s) { printf("Syntax Error\n"); }
int main() { yyparse(); return 0; }
