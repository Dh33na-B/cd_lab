#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int uses1(char *s, char *v) {                   /* is v a whole word of line s? */
    char a[80], b[24];
    sprintf(a, " %s ", s);       /* "t1 = a + 1"  ->  " t1 = a + 1 " */
    sprintf(b, " %s ", v);       /* "t1"          ->  " t1 "         */
    char *n = strstr(a, b);
    printf("%s\n",n);
    return strstr(a, b) != nullptr;
}
int main() {
    char *s = "t10 = t1 + b";
    char *v = "t1";
    printf("%d", uses1(s, v));
    return 0;
}
