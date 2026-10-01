%{
#include "token.h"
%}
%option yylineno
DIGIT [0-9]
LETTER [a-zA-Z]
%%
(" "|\t|\n) /* skip whitespace */
\+              { return TOKEN_PLUS; }
while           { return TOKEN_WHILE; }
{LETTER}+       { return TOKEN_IDENT; }  
{DIGIT}+        { return TOKEN_INTEGER; }
.               { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
