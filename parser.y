%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int token;
    char* str;
    int val;
}

%token TINT
%token TRETURN

%token <str> TIDENTIFIER
%token <val> TINTEGER

%token TLPAREN
%token TRPAREN
%token TLBRACE
%token TRBRACE
%token TSEMICOLON

%type <str> ident
%type <val> value

%%
func_decl: TINT ident TLPAREN TRPAREN block { printf("func_decl %s 'int ()'\n", $2); }

stmt: TRETURN value TSEMICOLON { printf("return_stmt %d\n", $2); }

block: TLBRACE stmt TRBRACE { printf("compound_stmt\n"); }

ident: TIDENTIFIER { $$ = $1; printf("id = %s\n", $1); }

value: TINTEGER { $$ = $1; printf("val = %d\n", $1); }
%%

int main(int argc, char* argv[])
{
    yyparse();
}

void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}
