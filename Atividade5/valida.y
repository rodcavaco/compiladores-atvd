%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE *yyin;

void yyerror(const char *s) {
    /* Não faz nada. A saída de erro é tratada inteiramente na main(). */
}
%}

%token STRING NUMBER TRUE_TOK FALSE_TOK NULL_TOK ERRO_LEXICO

%%

json_file: value
         ;

value: STRING
     | NUMBER
     | TRUE_TOK
     | FALSE_TOK
     | NULL_TOK
     | object
     | array
     ;

object: '{' '}'
      | '{' members '}'
      ;

members: pair
       | members ',' pair
       ;

pair: STRING ':' value
    ;

array: '[' ']'
     | '[' elements ']'
     ;

elements: value
        | elements ',' value
        ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("JSON COM ERRO\n");
            return 1;
        }
    }
    
    if (yyparse() == 0) {
        printf("JSON OK\n");
    } else {
        printf("JSON COM ERRO\n");
    }
    
    if (yyin) {
        fclose(yyin);
    }
    return 0;
}