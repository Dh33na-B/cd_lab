%{
#include <stdio.h>

int yylex();
void yyerror(const char *s);

%}

%token INT FLOAT DOUBLE CHAR

%%

program:
       start
       ;
start:
      start end
      | end
      ;
end: 
   INT 
   | FLOAT 
   | DOUBLE 
   | CHAR
   ;

%%


int main(){
   printf("Enter input: \n");
    yyparse();
    return 0; 
}

void yyerror(const char *s){
    printf("Syntax Error\n");
}
    
