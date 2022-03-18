%{
#include <stdlib.h>
#include <string.h>
#include "parser.h"

#define KEYWORD_TOKEN(t)    yylval.token = t
#define STRING_TOKEN        yylval.str = strdup(yytext)
#define INT_TOKEN           yylval.val = atoi(yytext)
%}

%option noyywrap

%%

[ \t\n]                                         ;
"int"                                           KEYWORD_TOKEN(TINT); return TINT;
"return"                                        KEYWORD_TOKEN(TRETURN); return TRETURN;

[a-zA-Z_][a-zA-Z0-9_]*                          STRING_TOKEN; return TIDENTIFIER;
[0-9]+                                          INT_TOKEN; return TINTEGER;

"("                                             return TLPAREN;
")"                                             return TRPAREN;
"{"                                             return TLBRACE;
"}"                                             return TRBRACE;
";"                                             return TSEMICOLON;

%%
