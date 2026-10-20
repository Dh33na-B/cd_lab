%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%option noyywrap

%%

"int"             {printf("INT\n"); return INT;}
"float"           {printf("FLOAT\n"); return FLOAT;}
"double"          {printf("DOUBLE\n"); return DOUBLE;}
"char"            {printf("CHAR\n"); return CHAR;}
[ \r\t\n]+        {/*ignore white space*/};
.                 {printf("Unknown: %s\n",yytext);}
%%

