%{
#include <stdio.h>
%}

%%

[ \t\n]+                { /* Ignora espaços, tabulações e quebras de linha */ }
"//".*                  { /* Ignora comentários de linha (do // até o fim da linha) */ }

"if"                    { printf("IF\n"); }
"else"                  { printf("ELSE\n"); }
"while"                 { printf("WHILE\n"); }
"return"                { printf("RETURN\n"); }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("ID %s\n", yytext); }

[0-9]+(\.[0-9]+)?       { printf("NUMBER %s\n", yytext); }

.                       { printf("SIMBOLO %s\n", yytext); }

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