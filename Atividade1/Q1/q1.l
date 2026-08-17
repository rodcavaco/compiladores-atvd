%{
#include <stdio.h>

/* Declaração dos contadores globais */
int linhas = 0;
int palavras = 0;
int caracteres = 0;
int inteiros = 0;
int floats = 0;
int pontuacoes = 0;
%}

%%

\n              { linhas++; caracteres += yyleng; }
[a-zA-Z]+       { palavras++; caracteres += yyleng; }
[0-9]+\.[0-9]+  { floats++; caracteres += yyleng; }
[0-9]+          { inteiros++; caracteres += yyleng; }
[.,;:!?]        { pontuacoes++; caracteres += yyleng; }
.               { caracteres += yyleng; }

%%

int main(void) {
    /* Inicia a análise léxica lendo da entrada padrão */
    yylex();
    
    /* Imprime o relatório final quando a entrada acaba (Ctrl+D) */
    printf("linhas: %d\n", linhas);
    printf("palavras: %d\n", palavras);
    printf("caracteres: %d\n", caracteres);
    printf("inteiros: %d\n", inteiros);
    printf("floats: %d\n", floats);
    printf("pontuacoes: %d\n", pontuacoes);
    
    return 0;
}

/* Função necessária para o Flex saber que a entrada terminou */
int yywrap(void) {
    return 1;
}