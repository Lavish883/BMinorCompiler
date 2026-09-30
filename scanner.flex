%{
#include "token.h"
%}
DIGIT [0-9]
LETTER [a-zA-Z]
%%
(" "|\t|\n) /* skip whitespace */
\+                                   { return TOKEN_ADD; }
if                                   { return TOKEN_IF; }
while                                { return TOKEN_WHILE; }
{LETTER}+({DIGIT}|{LETTER}|_)*       { return TOKEN_IDENT; }
:                                    { return TOKEN_COLON; }
;                                    { return TOKEN_SEMICOLON; }
=                                    { return TOKEN_ASSIGN; }
integer                              { return TOKEN_INTEGER_TYPE; }
double                               { return TOKEN_DOUBLE_TYPE; }
boolean                              { return TOKEN_BOOLEAN_TYPE; }
char                                 { return TOKEN_CHAR_TYPE; }
string                               { return TOKEN_STRING_TYPE; }
{DIGIT}+(\.({DIGIT})+)?              { return TOKEN_NUMBER; }
.                                    { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
