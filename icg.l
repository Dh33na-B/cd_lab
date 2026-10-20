%{
#include "y.tab.h"
#include <string.h>
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
"=="|"!="|"<="|">="|"<"|">"  { strcpy(yylval.str, yytext); return RELOP; }
[0-9]+      { strcpy(yylval.str, yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { strcpy(yylval.str, yytext); return ID; }
[-+*/=(){};] { return yytext[0]; }
[ \t\r\n]+    ;
.           { printf("unknown character: %s\n", yytext); }
%%
