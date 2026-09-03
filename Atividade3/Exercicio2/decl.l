%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "decl.tab.h"
%}

%option noyywrap

%%
[ \t\r\n]+              { }
"int"                   { yylval.str = strdup(yytext); return TIPO; }
"double"                { yylval.str = strdup(yytext); return TIPO; }
"char"                  { yylval.str = strdup(yytext); return TIPO; }
","                     { return VIRGULA; }
";"                     { return PONTO_VIRGULA; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

.                       { return yytext[0]; }
%%