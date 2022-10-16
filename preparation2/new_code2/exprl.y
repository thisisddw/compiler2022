%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <map>
#include <string>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char numStr[50];
char idStr[50];
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char *s);
%}

%token ADD SUB MUL DIV LEFTPARENTHESIS RIGHTPARENTHESIS NUMBER ID
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' { printf("%s\n", $2); }
        |   lines ';'
        |   
        ;

expr    :   expr ADD expr   { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, $3); strcat($$, "+ "); }
        |   expr SUB expr   { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, $3); strcat($$, "- "); }
        |   expr MUL expr   { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, $3); strcat($$, "* "); }
        |   expr DIV expr   { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, $3); strcat($$, "/ "); }
        |   LEFTPARENTHESIS expr RIGHTPARENTHESIS   { $$ = $2; }
        |   SUB expr %prec UMINUS   { $$ = $2; strcat($$, "- "); }
        |   NUMBER  { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, " "); }
        |   ID  { $$ = (char *)malloc(sizeof(char)*50); strcpy($$, $1); strcat($$, " "); }
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
            int len = 0;
            while(isdigit(c))
            {
                numStr[len++] = c;
                c = getchar();
            }
            numStr[len] = 0;
            yylval = numStr;
            ungetc(c, stdin);
            return NUMBER;
        }
        if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_')
        {
            int len = 0;
            idStr[len++] = c;
            c = getchar();
            while(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_' || c >= '0' && c <= '9')
            {
                idStr[len++] = c;
                c = getchar();
            }
            idStr[len] = 0;
            yylval = idStr;
            ungetc(c, stdin);
            return ID;
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