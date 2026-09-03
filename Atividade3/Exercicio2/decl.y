%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int  yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

#define MAX_DECL 2048
char *tabela_simbolos[MAX_DECL];
int total_declaradas = 0;

char *tipo_atual = NULL;

int ja_declarada(const char *nome) {
    for (int i = 0; i < total_declaradas; i++) {
        if (strcmp(tabela_simbolos[i], nome) == 0) {
            return 1;
        }
    }
    return 0;
}

void processar_variavel(char *nome) {
    if (ja_declarada(nome)) {
        printf("erro: %s já foi declarada\n", nome);
    } else {
        printf("%s %s\n", tipo_atual, nome);
        tabela_simbolos[total_declaradas++] = strdup(nome);
    }
    free(nome);
}
%}

%union {
    char *str;
}

%token <str> TIPO ID
%token VIRGULA PONTO_VIRGULA

%%
programa : declaracoes { printf("+++++ %d variáveis declaradas\n", total_declaradas); }
         ;

declaracoes : 
            | declaracoes declaracao
            ;

declaracao : TIPO { tipo_atual = $1; } lista_ids PONTO_VIRGULA { free($1); tipo_atual = NULL; }
           ;

lista_ids : ID                  { processar_variavel($1); }
          | lista_ids VIRGULA ID { processar_variavel($3); }
          ;
%%

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv)
{
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Erro ao abrir o arquivo");
            return 1;
        }
        yyin = file;
    }

    return yyparse();
}