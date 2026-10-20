#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

#define MAX 1024

struct Statement {
    char res[16];
    char opt[64];
    int dead;
} code[MAX];

int is_num(char *s){
    for(;*s;s++) if(!isdigit((unsigned char)*s)) return 0;
    return 1;
}

int is(char *a,char *b){
    return strcmp(a,b)==0;
}
int uses(char *s,char *v){
    char *a = malloc(100);
    char *b = malloc(100);
    sprintf(a," %s ",s);
    sprintf(b," %s ",s);

    return strstr(a,b) != nullptr;
}
int main(){
    int n,i,j,k,ch;
    char line[64],r[16],a[16],o[8],b[16];

    n=0;
    while(n<MAX && fgets(line,sizeof(line),stdin)){
        line[strcspn(line,"\n")]=0; 
        if(line[0] ==0 ) continue;

        i = n++;

        strcpy(code[i].opt,line);
        if(sscanf(line,"%s = %s %s %s",r,a,o,b)!=4){
            sscanf(line,"%s",code[i].res);
            continue;
        }

        strcpy(code[i].res,r);

        if(is_num(a) && is_num(b) && !(is(o,"/") && atoi(b) ==0)){
            int x = atoi(a),y = atoi(b),v=1;
            if(is(o,"+")) v = x+y;
            else if(is(o,"-")) v = x-y;
            else if(is(o,"*")) v = x*y;
            else if(is(o,"/")) v = x/y;
            sprintf(code[i].opt,"%s = %d",r,v);
        }
        else if((is(o,"+") || is(o,"-")) && is(b,"0")){
            sprintf(code[i].opt,"%s = %s",r,a);
        }
        else if(is(o,"+") && is(a,"0")){
            sprintf(code[i].opt,"%s = %s",r,b);
        }
        else if((is(o,"*") || is(o,"/")) && is(b,"1")){
            sprintf(code[i].opt,"%s = %s",r,a);
        }
        else if(is(o,"*")) {
            if(is(a,"0") && is(b,"0")) sprintf(code[i].opt,"%s = 0",r);
            else if( is(a,"2")) sprintf(code[i].opt,"%s = %s + %s",r,b,b);
            else if( is(b,"2")) sprintf(code[i].opt,"%s = %s + %s",r,a,a);
        }
        else if (is(o, "*") && is(b, "2"))                  sprintf(code[i].opt, "%s = %s + %s", r, a, a);
        else if (is(o, "*") && is(a, "2"))                  sprintf(code[i].opt, "%s = %s + %s", r, b, b);
    }
    }

    do{
        ch = 0; 
        for(i=0;i<n;i++){
            if(code[i].dead || code[i].res[0]!='t' || !isdigit((unsigned char)code[i].res[1])) continue;
            for( j=0,k=0;j<n;j++){
                if(j!=i && !code[j].dead && uses(code[j].opt,code[i].res)) k=1;
            }
            if(!k){ code[i].dead=1 , ch =1;}
        }
    }while(ch);
    printf("\n--OPTIMIZED CODE--\n");
    for(int i=0;i<n;i++){
        if(!code[i].dead) printf("%s\n",code[i].opt);
    }
    return 0;
}
