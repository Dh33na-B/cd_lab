#include <stdio.h>
#include <string.h>

char *jmp(char *r){
    return !strcmp(r,"<=") ? "JLE" : !strcmp(r,">=")? "JGE" :
           !strcmp(r,"==") ? "JE" : !strcmp(r,">")? "JG" :
           !strcmp(r,"<") ? "JL" : "JNE";
}

char *ins(char op){ return op=='+' ? "ADD" : op =='-' ? "SUB" : op=='*' ? "MUL":
"DIV";}

int main(){

    char line[100],t[6][20];
    int n;
    while(fgets(line,100,stdin)){
        n = sscanf(line,"%s %s %s %s %s %s",t[0],t[1],t[2],t[3],t[4],t[5]);

        if(n==1) printf("%s\n",t[0]);
        else if(n==2) printf("JMP %s\n",t[1]);
        else if(n==3) printf("MOV R0,%s\nMOV %s,R0\n",t[2],t[0]);
        else if(n==5) printf("MOV R0,%s\n %s R0, %s\n MOV %s, R0\n",
                t[2],ins(t[3][0]),t[4],t[0]);
        else if( n==6) printf("MOV R0, %s\nCMP R0, %s\n%s %s\n",
                t[1],t[3],jmp(t[2]),t[5]);
    }
    return 0;
}
