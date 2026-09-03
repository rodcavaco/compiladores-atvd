%{
#include "calc.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%
[ \t]+                  { }
"printar_variaveis"     { return PRINTAR_VARIAVEIS; }
">>>"                   { return ATRIB; }
"**"                    { return POT; }
"+"                     { return MAIS; }
"-"                     { return MENOS; }
"*"                     { return VEZES; }
"/"                     { return DIVISAO; }
"("                     { return ABRE_PAREN; }
")"                     { return FECHA_PAREN; }
\n                      { return '\n'; }

[0-9]+(\.[0-9]+)?       { yylval.val = atof(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

.                       { return yytext[0]; }
%%