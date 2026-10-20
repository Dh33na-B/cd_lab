int a;
float b;
char c;
double d;
int i;
int j;
a = 10;
b = a + 5 * 2 - 3 / 1;
c = (a + b) * (a - 2);
d = 2 * 3 + 4;
a = a + 0;
b = c * 1;
if (a < b) a = a + 1;
if (a > b) b = b - 1; else b = b + 1;
if (a == b) { a = a + 1; b = b + 1; } else { a = a - 1; b = b - 1; }
if (a != b) { if (a <= b) a = 1; else a = 2; }
if (a >= b) a = 0;
while (a < 10) a = a + 1;
while (a > 0) { a = a - 1; b = b + a; }
for (i = 0; i < 5; i++) a = a + i;
for (i = 0; i < 10; i = i + 2) { b = b + i; }
for (i = 0; i < 3; i++) { for (j = 0; j < 2; j = j + 1) { a = a + j; } }
while (a < 100) { if (a > 50) a = a + 10; else a = a + 1; }
