#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX 500

struct Statement {
    char res[16];       /* left side of the line (x in  x = a op b)  */
    char opt[64];       /* final text of this line                   */
    int dead;           /* 1 = removed by dead code elimination      */
} code[MAX];

int isNum(char *s) {
    for (; *s; s++) if (!isdigit((unsigned char)*s)) return 0;
    return 1;
}
int is(char *a, char *b) { return strcmp(a, b) == 0; }

//int uses(char *s, char *v) {                   /* does line s contain v as a whole word? */
    //int len = strlen(v);
    //for (char *p = s; (p = strstr(p, v)); p++)
        //if ((p == s || !isalnum((unsigned char)p[-1])) && !isalnum((unsigned char)p[len])) return 1;
    //return 0;
//}
int uses1(char *s, char *v) {                   /* is v a whole word of line s? */
    char a[80], b[24];
    sprintf(a, " %s ", s);       /* "t1 = a + 1"  ->  " t1 = a + 1 " */
    sprintf(b, " %s ", v);       /* "t1"          ->  " t1 "         */
    return strstr(a, b) != nullptr;
}
int main() {
    int n, i, j, k, ch;
    char line[64], r[16], a[16], o[8], b[16];

    n = 0;
    while (n < MAX && fgets(line, sizeof(line), stdin)) {      /* read until end of file */
        line[strcspn(line, "\n")] = 0;
        if (line[0] == 0) continue;
        i = n++;

        strcpy(code[i].opt, line);
        if (sscanf(line, "%s = %s %s %s", r, a, o, b) != 4) {
            sscanf(line, "%s", code[i].res);            /* label, goto, if, or  x = a  : keep as it is */
            continue;
        }
        strcpy(code[i].res, r);

        /* 1. Constant folding */
        if (isNum(a) && isNum(b) && !(is(o, "/") && atoi(b) == 0)) {
            int x = atoi(a), y = atoi(b), v = 1;
            if (is(o, "+"))      v = x + y;
            else if (is(o, "-")) v = x - y;
            else if (is(o, "*")) v = x * y;
            else if (is(o, "/")) v = x / y;
            sprintf(code[i].opt, "%s = %d", r, v);
        }
        /* 2. Algebraic identities */
        else if ((is(o, "+") || is(o, "-")) && is(b, "0"))  sprintf(code[i].opt, "%s = %s", r, a);
        else if (is(o, "+") && is(a, "0"))                  sprintf(code[i].opt, "%s = %s", r, b);
        else if ((is(o, "*") || is(o, "/")) && is(b, "1"))  sprintf(code[i].opt, "%s = %s", r, a);
        else if (is(o, "*") && is(a, "1"))                  sprintf(code[i].opt, "%s = %s", r, b);
        else if (is(o, "*") && (is(a, "0") || is(b, "0")))  sprintf(code[i].opt, "%s = 0", r);
        /* 3. Strength reduction */
        else if (is(o, "*") && is(b, "2"))                  sprintf(code[i].opt, "%s = %s + %s", r, a, a);
        else if (is(o, "*") && is(a, "2"))                  sprintf(code[i].opt, "%s = %s + %s", r, b, b);
    }

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

    printf("\n--- Optimized Code ---\n");
    for (i = 0; i < n; i++)
        if (!code[i].dead) printf("%s\n", code[i].opt);

    return 0;
}
