#ifndef _yy_defines_h_
#define _yy_defines_h_

#define ID 257
#define NUM 258
#define RELOP 259
#define INT 260
#define FLOAT 261
#define DOUBLE 262
#define CHAR 263
#define IF 264
#define ELSE 265
#define FOR 266
#define WHILE 267
#define INC 268
#define IFX 269
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE { char str[100]; } YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
