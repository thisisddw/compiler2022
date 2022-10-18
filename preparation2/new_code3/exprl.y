%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <map>
#include <string>
#include <utility>
typedef std::string string;
// typedef std::pair<string, double> pair;
#ifndef YYSTYPE
#define YYSTYPE std::pair<string, double>
#endif

std::map<string, double> symbol2val;
FILE *yyin;

int yylex();
extern int yyparse();
void yyerror(const char *s);
%}

%token ADD SUB MUL DIV LEFTPARENTHESIS RIGHTPARENTHESIS NUMBER ID
%left ASSIGN
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' { printf("%lf\n", ($2).second); }
        |   lines assign ';' { printf("%s = %lf\n", ($2).first.c_str(), ($2).second); }
        |   lines ';'
        |
        ;

expr    :   expr ADD expr   { $$.first = string("expr"); $$.second = ($1).second + ($3).second; }
        |   expr SUB expr   { $$.first = string("expr"); $$.second = ($1).second - ($3).second; }
        |   expr MUL expr   { $$.first = string("expr"); $$.second = ($1).second * ($3).second; }
        |   expr DIV expr   { $$.first = string("expr"); $$.second = ($1).second / ($3).second; }
        |   LEFTPARENTHESIS expr RIGHTPARENTHESIS   { $$.first = string("expr"); $$.second = ($2).second; }
        |   SUB expr %prec UMINUS   { $$.first = string("expr"); $$.second = -($2).second; }
        |   NUMBER  { $$.first = string("expr"); $$.second = ($1).second; }
        |   ID  {   
                    $$.first = string("expr"); 
                    if (!symbol2val.count(($1).first)) 
                    { 
                        printf("undefined variable!\n"); 
                        $$.second = 0; 
                    }
                    else 
                        $$.second = symbol2val[($1).first]; 
                }
        ;

assign  :   ID ASSIGN expr  { $$ = $3; $$.first = ($1).first; symbol2val[($1).first] = ($3).second; }

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
        if (c == '=')
            return ASSIGN;
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
            double val = 0;
            int len = 0;
            char numStr[50] = {};
            while(isdigit(c))
            {
                val = val*10 + c - '0';
                numStr[len++] = c;
                c = getchar();
            }
            numStr[len] = 0;
            yylval = { string(numStr), val };
            ungetc(c, stdin);
            return NUMBER;
        }
        if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_')
        {
            int len = 0;
            char idStr[50] = {};
            idStr[len++] = c;
            c = getchar();
            while(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_' || c >= '0' && c <= '9')
            {
                idStr[len++] = c;
                c = getchar();
            }
            idStr[len] = 0;
            yylval = { string(idStr), 998244353 };
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