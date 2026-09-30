%{
#include "token.h"
%}
DIGIT [0-9]
LETTER [a-zA-Z]
%%
(" "|\t|\n) /* skip whitespace */
\+                                   { return TOKEN_ADD; }
array                                   { return TOKEN_ARRAY; }
auto                                   { return TOKEN_AUTO; }
carray                                   { return TOKEN_CARRAY; }
if                                   { return TOKEN_IF; }
else                                   { return TOKEN_ELSE; }
for                                   { return TOKEN_FOR; }
while                                { return TOKEN_WHILE; }
print                                { return TOKEN_PRINT; }
return                                { return TOKEN_RETURN; }
void                                { return TOKEN_VOID; }
boolean                                   { return TOKEN_BOOLEAN_TYPE; }
integer                              { return TOKEN_INTEGER_TYPE; }
double                               { return TOKEN_DOUBLE_TYPE; }
float                               { return TOKEN_FLOAT_TYPE; }
boolean                              { return TOKEN_BOOLEAN_TYPE; }
char                                 { return TOKEN_CHAR_TYPE; }
string                               { return TOKEN_STRING_TYPE; }
function                               { return TOKEN_FUNCTION; }
true                                  { return TOKEN_TRUE; }
false                                 { return TOKEN_FALSE; }
{LETTER}+({DIGIT}|{LETTER}|_)*       { return TOKEN_IDENT; }
"                                    { return TOKEN_QUOTE; }
'                                    { return TOKEN_APOSTROPHE; }
:                                    { return TOKEN_COLON; }
;                                    { return TOKEN_SEMICOLON; }
=                                    { return TOKEN_ASSIGN; }
{                                    { return TOKEN_LBRACE; }
}                                    { return TOKEN_RBRACE; }
[                                    { return TOKEN_LSQBRACE; }
]                                    { return TOKEN_RSQBRACE; }
(0x)+([0-9]|[a-f]|[A-F])*              { return TOKEN_HEXADECIMAL; }
(0b)+(0|1)*                             { return TOKEN_BINARY; }
{DIGIT}+(\.({DIGIT})+)?              { return TOKEN_DECIMAL; }
.                                    { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
