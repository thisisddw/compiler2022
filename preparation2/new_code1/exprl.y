%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char *s);
%}

%token ADD SUB MUL DIV LEFTPARENTHESIS RIGHTPARENTHESIS NUMBER
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' { printf("%f\n", $2); }
        |   lines ';'
        |   
        ;

expr    :   expr ADD expr   { $$ = $1 + $3; }
        |   expr SUB expr   { $$ = $1 - $3; }
        |   expr MUL expr   { $$ = $1 * $3; }
        |   expr DIV expr   { $$ = $1 / $3; }
        |   LEFTPARENTHESIS expr RIGHTPARENTHESIS   { $$ = $2; }
        |   SUB expr %prec UMINUS   { $$ = -$2; }
        |   NUMBER
        ;

// NUMBER  :   '0'     { $$ = 0.0; }
//         |   '1'     { $$ = 1.0; }
//         |   '2'     { $$ = 2.0; }
//         |   '3'     { $$ = 3.0; }
//         |   '4'     { $$ = 4.0; }
//         |   '5'     { $$ = 5.0; }
//         |   '6'     { $$ = 6.0; }
//         |   '7'     { $$ = 7.0; }
//         |   '8'     { $$ = 8.0; }
//         |   '9'     { $$ = 9.0; }
//         ;

%%

// programs section

int yylex()
{
    // place your token retrieving code here
    while(1)
    {
        char c = getchar();
        if (c == ' ' || c == '\n' || c == '\t')
            continue;
        if (c == '+')
            return ADD;
        if (c == '-')
            return SUB;
        if (c == '*')
            return MUL;
        if (c == '/')
            return DIV;
        if (c == '(')
            return LEFTPARENTHESIS;
        if (c == ')')
            return RIGHTPARENTHESIS;
        if (isdigit(c))
        {
            yylval = 0;
            while(isdigit(c))
            {
                yylval = yylval * 10 + c - '0';
                c = getchar();
            }
            ungetc(c, stdin);
            return NUMBER;
        }
        return c;
    }
}

int main()
{
    yyin = stdin;
    do {
        yyparse();
    } while(!feof(yyin));

    return 0;
}

void yyerror(const char *s)
{
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}