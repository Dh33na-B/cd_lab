%{
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"double"    { return DOUBLE; }

"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }

"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }

"="         { return ASSIGN; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }

[0-9]+      { return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { return ID; }

[ \t\n]+    ;
.           { printf("Unknown: %s\n", yytext); }

%%
