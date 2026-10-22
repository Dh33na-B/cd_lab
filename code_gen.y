%{
/* PHASE 5 : CODE GENERATION (reads TAC from stdin, writes assembly) */
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

char *jmp(char *r) {
    return !strcmp(r,"<")  ? "JL"  : !strcmp(r,">")  ? "JG"  :
           !strcmp(r,"<=") ? "JLE" : !strcmp(r,">=") ? "JGE" :
           !strcmp(r,"==") ? "JE"  : "JNE";
}
char *ins(char op) {
    return op=='+' ? "ADD" : op=='-' ? "SUB" : op=='*' ? "MUL" : "DIV";
}
%}

%union { char str[64]; }
%token IF GOTO NL
%token <str> ID NUM RELOP OP
%type  <str> operand

%%
program : program line
        |
        ;

line    : NL
        | ID ':' NL                                   /* L1:             */
            { printf("%s:\n", $1); }
        | GOTO ID NL                                  /* goto L1         */
            { printf("JMP %s\n", $2); }
        | ID '=' operand NL                           /* x = a           */
            { printf("MOV R0, %s\nMOV %s, R0\n", $3, $1); }
        | ID '=' operand OP operand NL                /* x = a op b      */
            { printf("MOV R0, %s\n%s R0, %s\nMOV %s, R0\n", $3, ins($4[0]), $5, $1); }
        | IF operand RELOP operand GOTO ID NL         /* if a r b goto L */
            { printf("MOV R0, %s\nCMP R0, %s\n%s %s\n", $2, $4, jmp($3), $6); }
        ;

operand : ID  { strcpy($$, $1); }
        | NUM { strcpy($$, $1); }
        ;
%%
void yyerror(const char *s) { fprintf(stderr, "Syntax error in TAC\n"); }
int main() { yyparse(); return 0; }

