%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int  yylex(void);
void yyerror(const char *s);
extern FILE *yyin;

typedef struct {
    char *name;
    double val;
} Variavel;

#define MAX_VARS 1024
Variavel tabela[MAX_VARS];
int qtd_variaveis = 0;

double buscar_variavel(const char *nome) {
    for (int i = 0; i < qtd_variaveis; i++) {
        if (strcmp(tabela[i].name, nome) == 0) {
            return tabela[i].val;
        }
    }
    return 0.0;
}

void salvar_variavel(const char *nome, double val) {
    for (int i = 0; i < qtd_variaveis; i++) {
        if (strcmp(tabela[i].name, nome) == 0) {
            tabela[i].val = val;
            return;
        }
    }
    tabela[qtd_variaveis].name = strdup(nome);
    tabela[qtd_variaveis].val = val;
    qtd_variaveis++;
}

void printar_todas_variaveis() {
    for (int i = 0; i < qtd_variaveis; i++) {
        printf("%s >>> %g\n", tabela[i].name, tabela[i].val);
    }
}
%}

%union {
    double val;
    char *str;
}

%token <val> NUM
%token <str> ID
%token MAIS MENOS VEZES DIVISAO ABRE_PAREN FECHA_PAREN POT ATRIB PRINTAR_VARIAVEIS

%type  <val> expr

%left  MAIS MENOS
%left  VEZES DIVISAO
%right POT
%right UMINUS

%%
entrada : 
        | entrada comando
        ;

comando : '\n'
        | expr '\n'                    { printf("= %g\n", $1); }
        | ID ATRIB expr '\n'           { salvar_variavel($1, $3); free($1); }
        | PRINTAR_VARIAVEIS '\n'       { printar_todas_variaveis(); }
        ;

expr : NUM                          { $$ = $1; }
     | ID                           { $$ = buscar_variavel($1); free($1); }
     | expr MAIS expr               { $$ = $1 + $3; }
     | expr MENOS expr              { $$ = $1 - $3; }
     | expr VEZES expr              { $$ = $1 * $3; }
     | expr DIVISAO expr            { $$ = $1 / $3; }
     | expr POT expr                { $$ = pow($1, $3); }
     | MENOS expr %prec UMINUS      { $$ = -$2; }
     | ABRE_PAREN expr FECHA_PAREN  { $$ = $2; }
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