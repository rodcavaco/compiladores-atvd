%{
#include <stdio.h>
#include <stdlib.h>
%}

%%

[ \t\n]+                { /* Ignora espaços, tabulações e quebras de linha */ }
"//".*                  { /* Ignora comentários de linha */ }

"if"                    { printf("IF\n"); }
"else"                  { printf("ELSE\n"); }
"while"                 { printf("WHILE\n"); }
"return"                { printf("RETURN\n"); }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("ID %s\n", yytext); }

[0-9]+(\.[0-9]+)?       { printf("NUMBER %s\n", yytext); }

.                       { printf("SIMBOLO %s\n", yytext); }

%%

int main(int argc, char **argv) {
    /* Verifica se o nome do arquivo foi passado como argumento (item b) */
    if (argc < 2) {
        fprintf(stderr, "Erro: Nenhum arquivo de entrada fornecido.\n");
        fprintf(stderr, "Uso: %s <arquivo.txt>\n", argv[0]);
        return 1; /* Encerra com código de saída diferente de zero */
    }

    /* Tenta abrir o arquivo em modo de leitura */
    FILE *arquivo = fopen(argv[1], "r");
    
    /* Verifica se o arquivo existe ou pôde ser aberto (item b) */
    if (!arquivo) {
        fprintf(stderr, "Erro: Não foi possível abrir o arquivo '%s'.\n", argv[1]);
        return 2; /* Encerra com código de saída diferente de zero */
    }

    /* Redireciona a entrada do Flex (yyin) para o arquivo aberto (item a) */
    yyin = arquivo;
    
    /* Inicia a análise léxica lendo do arquivo */
    yylex();
    
    /* Fecha o arquivo após a análise */
    fclose(arquivo);
    
    return 0;
}

/* Função necessária para o Flex saber que a entrada terminou */
int yywrap(void) {
    return 1;
}