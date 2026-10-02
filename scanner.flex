%{
#include "token.h"
%}

%option yylineno

DIGIT [0-9]
LETTER [a-zA-Z]
CHAR    \'((\\0x[0-9a-fA-F][0-9a-fA-F])|(\\?.))?\'
STRING  \"(([^\\]\\\")|[^\"])*\"
COMMENT (\/\*((\*[^/]?)|[^*])*(\*\/))|(\/\/.*)

%%
(" "|\t|\v|\r|\n|\f) /* skip whitespace */

    /* Keywords */
array                                { return TOKEN_ARRAY; }
auto                                 { return TOKEN_AUTO; }
boolean                              { return TOKEN_BOOLEAN_TYPE; }
carray                               { return TOKEN_CARRAY; }
char                                 { return TOKEN_CHAR_TYPE; }
else                                 { return TOKEN_ELSE; }
double                               { return TOKEN_DOUBLE_TYPE; }
false                                { return TOKEN_FALSE; }
float                                { return TOKEN_FLOAT_TYPE; }
for                                  { return TOKEN_FOR; }
if                                   { return TOKEN_IF; }
while                                { return TOKEN_WHILE; }
print                                { return TOKEN_PRINT; }
return                               { return TOKEN_RETURN; }
void                                 { return TOKEN_VOID; }
integer                              { return TOKEN_INTEGER_TYPE; }
string                               { return TOKEN_STRING_TYPE; }
function                             { return TOKEN_FUNCTION; }
true                                 { return TOKEN_TRUE; }

({LETTER}|_)+({DIGIT}|{LETTER}|_)*   { return TOKEN_IDENT; }

{CHAR}                               { return TOKEN_CHAR_LITERAL; }
{STRING}                             { return TOKEN_STRING_LITERAL; }

    /* Punctuation */
\:                                   { return TOKEN_COLON; }
\;                                   { return TOKEN_SEMICOLON; }
\,                                   { return TOKEN_COMMA; }
\=                                   { return TOKEN_ASSIGN; }
\{                                   { return TOKEN_LBRACE; }
\}                                   { return TOKEN_RBRACE; }
\[                                   { return TOKEN_L_SQ_BRACKET; }
\]                                   { return TOKEN_R_SQ_BRACKET; }
\(                                   { return TOKEN_LPAREN; }
\)                                   { return TOKEN_RPAREN; }
\<                                   { return TOKEN_LESS; }
\>                                   { return TOKEN_GREATER; }
\^                                   { return TOKEN_EXPONENT; }
\!                                   { return TOKEN_NOT; }
\%                                   { return TOKEN_MODULO; }
\#                                   { return TOKEN_HASH; }
"&&"                                 { return TOKEN_AND; }
"||"                                 { return TOKEN_OR; }

\+                                   { return TOKEN_PLUS; }
\-                                   { return TOKEN_MINUS; }
\*                                   { return TOKEN_MUL; }
\/                                   { return TOKEN_DIV; }

{COMMENT}

(0x)+([0-9]|[a-f]|[A-F])*            { return TOKEN_HEXADECIMAL; }
(0b)+(0|1)*                          { return TOKEN_BINARY; }
{DIGIT}+(\.({DIGIT})+)?              { return TOKEN_DECIMAL; }
.                                    { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
