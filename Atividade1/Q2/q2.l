%{
#include <stdio.h>
%}

%%

[ \t]+          { /* Ignora espaços e tabulações */ }
\n              { printf("NEWLINE\n"); }

"+"             { printf("PLUS\n"); }
"-"             { printf("MINUS\n"); }
"*"             { printf("TIMES\n"); }
"/"             { printf("DIVIDE\n"); }
"|"             { printf("ABS\n"); }

"("             { printf("LPAREN\n"); }
")"             { printf("RPAREN\n"); }

"%"             { printf("MOD\n"); }
"^"             { printf("POWER\n"); }

"<="            { printf("REL_OP <=\n"); }
">="            { printf("REL_OP >=\n"); }
"=="            { printf("REL_OP ==\n"); }
"!="            { printf("REL_OP !=\n"); }
"<"             { printf("REL_OP <\n"); }
">"             { printf("REL_OP >\n"); }

[0-9]+          { printf("NUMBER %s\n", yytext); }

.               { printf("Mystery character %s\n", yytext); }

%%

int main(void) {
    /* Inicia a análise léxica lendo da entrada padrão */
    yylex();
    return 0;
}

/* Função necessária para o Flex saber que a entrada terminou */
int yywrap(void) {
    return 1;
}