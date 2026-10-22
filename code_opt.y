%{
/* PHASE 4 : CODE OPTIMIZATION (reads TAC from stdin, writes optimized TAC) */
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#define MAX 500

int yylex(void);
void yyerror(const char *s);

struct Statement {
    char res[16];       /* left side of the line (empty for label/goto/if) */
    char opt[128];      /* final text of this line                         */
    int dead;           /* 1 = removed by dead code elimination            */
} code[MAX];
int n = 0;

void add(const char *res, const char *opt) {
    if (n >= MAX) return;
    sprintf(code[n].res, "%s", res);
    sprintf(code[n].opt, "%s", opt);
    code[n].dead = 0;
    n++;
}

int isNum(char *s) {
    for (; *s; s++) if (!isdigit((unsigned char)*s)) return 0;
    return 1;
}
int is(char *a, char *b) { return strcmp(a, b) == 0; }

int uses1(char *s, char *v) {              /* is v a whole word of line s? */
    char a[160], b[40];
    sprintf(a," %s ", s);
    sprintf(b," %s ", v);
    return strstr(a, b) != NULL;
}

/* x = a o b  ->  optimized text in out */
void optimize(char *r, char *a, char *o, char *b, char *out) {
    sprintf(out, "%s = %s %s %s", r, a, o, b);              /* default */

    /* 1. Constant folding */
    if (isNum(a) && isNum(b) && !(is(o, "/") && atoi(b) == 0)) {
        int x = atoi(a), y = atoi(b), v = 1;
        if (is(o, "+"))      v = x + y;
        else if (is(o, "-")) v = x - y;
        else if (is(o, "*")) v = x * y;
        else if (is(o, "/")) v = x / y;
        snprintf(out, 128, "%s = %d", r, v);
    }
    /* 2. Algebraic identities */
    else if ((is(o,"+") || is(o,"-")) && is(b,"0"))  snprintf(out, 128, "%s = %s", r, a);
    else if (is(o,"+") && is(a,"0"))                  snprintf(out, 128, "%s = %s", r, b);
    else if ((is(o,"*") || is(o,"/")) && is(b,"1"))   snprintf(out, 128, "%s = %s", r, a);
    else if (is(o,"*") && is(a,"1"))                  snprintf(out, 128, "%s = %s", r, b);
    else if (is(o,"*") && (is(a,"0") || is(b,"0")))   snprintf(out, 128, "%s = 0", r);
    /* 3. Strength reduction */
    else if (is(o,"*") && is(b,"2"))                  snprintf(out, 128, "%s = %s + %s", r, a, a);
    else if (is(o,"*") && is(a,"2"))                  snprintf(out, 128, "%s = %s + %s", r, b, b);
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
            { char s[80];  snprintf(s, sizeof s, "%s:", $1);               add("", s); }
        | GOTO ID NL                                  /* goto L1         */
            { char s[80];  snprintf(s, sizeof s, "goto %s", $2);           add("", s); }
        | IF operand RELOP operand GOTO ID NL         /* if a r b goto L */
            { char s[200]; snprintf(s, sizeof s, "if %s %s %s goto %s", $2, $3, $4, $6); add("", s); }
        | ID '=' operand NL                           /* x = a           */
            { char s[128]; snprintf(s, sizeof s, "%s = %s", $1, $3);       add($1, s); }
        | ID '=' operand OP operand NL                /* x = a op b      */
            { char s[128]; optimize($1, $3, $4, $5, s);                    add($1, s); }
        ;

operand : ID  { strcpy($$, $1); }
        | NUM { strcpy($$, $1); }
        ;
%%
void yyerror(const char *s) { fprintf(stderr, "Syntax error in TAC\n"); }

int main() {
    int i, j, k, ch;
    yyparse();

    /* 4. Dead code elimination: a temp (t1, t2 ...) that no other line reads */
    do {
        ch = 0;
        for (i = 0; i < n; i++) {
            if (code[i].dead || code[i].res[0] != 't' || !isdigit((unsigned char)code[i].res[1])) continue;
            for (j = 0, k = 0; j < n; j++)
                if (j != i && !code[j].dead && uses1(code[j].opt, code[i].res)) k = 1;
            if (!k) { code[i].dead = 1; ch = 1; }
        }
    } while (ch);

    fprintf(stderr, "\n--- Optimized Code ---\n");
    for (i = 0; i < n; i++)
        if (!code[i].dead) printf("%s\n", code[i].opt);
    return 0;
}

