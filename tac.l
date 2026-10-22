%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"if"                         { return IF; }
"goto"                       { return GOTO; }
[a-zA-Z_][a-zA-Z0-9_]*       { strcpy(yylval.str, yytext); return ID; }
[0-9]+                     { strcpy(yylval.str, yytext); return NUM; }
"=="|"!="|"<="|">="|"<"|">"  { strcpy(yylval.str, yytext); return RELOP; }
[-+*/]                       { strcpy(yylval.str, yytext); return OP; }
[=:]                         { return yytext[0]; }
\n                           { return NL; }
[ \t\r]+                     { }
.                            { fprintf(stderr, "unknown character: %s\n", yytext); }
%%
