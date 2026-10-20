%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}
%option noyywrap

%%
"int"                       { return INT;}
"float"                     { return FLOAT;}
"double"                    { return DOUBLE;}
"char"                      { return CHAR;}
"for"                       { return FOR;}
"while"                     { return WHILE;}
"if"                        { return IF;}
"else"                      { return ELSE;}
[a-zA-Z_][a-zA-Z0-9_]*      { strcpy(yylval.str,yytext); return ID;} 
[0-9]+                      { strcpy(yylval.str,yytext); return NUM;}
"=="|"!="|"<"|"<="|">"|">=" { strcpy(yylval.str,yytext); return RELOP;}
"++"                        { return INC; }
[-+*/=(){};]                { return yytext[0]; }
[ \t\r\n]+                  ;
.                           { printf("unknow character: %s\n",yytext); }
%%


