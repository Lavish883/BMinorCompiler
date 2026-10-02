%option   yylineno
%{
#include "token.h"
%}
DIGIT [0-9]
LETTER [a-zA-Z]
ASCII_CHAR [\x00-\x7F]
HEX_DIGIT [0-9a-fA-F]
%%
(" "|\t|\n|\r) /* skip whitespace */
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

({LETTER}|_)+({DIGIT}|{LETTER}|_)*       { return TOKEN_IDENT; }

\'([^\'\\\n]|\\.|\\0x{HEX_DIGIT}{2})\'                     { return TOKEN_CHAR_LITERAL; }
\"([^\"\\\n]|\\.|\\0x{HEX_DIGIT}{2})*\"                   {return handle_string_matching(); }
    /* Punctuation */
:                                    { return TOKEN_COLON; }
;                                    { return TOKEN_SEMICOLON; }
,                                    { return TOKEN_COMMA;     }
=                                    { return TOKEN_ASSIGN; }
\{                                    { return TOKEN_LBRACE; }
\}                                    { return TOKEN_RBRACE; }
\[                                   { return TOKEN_L_SQ_BRACKET; }
\]                                   { return TOKEN_R_SQ_BRACKET; }
\(                                    { return TOKEN_LPAREN; }
\)                                    { return TOKEN_RPAREN; }
\+                                   { return TOKEN_PLUS; }
\-                                   { return TOKEN_MINUS; }
\*                                   { return TOKEN_MUL; }
\^                                   { return TOKEN_EXPONENT; }
\/                                   { return TOKEN_DIV; }
%                                   { return TOKEN_MODULO; }
\>                                   { return TOKEN_GREATER; }
\<                                   { return TOKEN_LESS; }
!                                   { return TOKEN_NOT; }
\+\+                                 {return TOKEN_INCREMENT; }
\-\-                                 {return TOKEN_DECREMENT;}
\>= {return TOKEN_GREATER_EQUAL; }
\<= {return TOKEN_LESS_EQUAL; }
== { return TOKEN_EQUAL;}
!= { return TOKEN_NOT_EQUAL; }
# { return TOKEN_HASH;}
&& {return TOKEN_AND;}
\|\| {return TOKEN_OR;}
(0x)+([0-9]|[a-f]|[A-F])*            { return TOKEN_HEXADECIMAL; }
(0b)+(0|1)*                          { return TOKEN_BINARY; }
(-)?{DIGIT}+((\.){DIGIT}+)?(e|E)(\+|\-)?{DIGIT}+      { return TOKEN_DECIMAL; }
(-)?{DIGIT}*(\.({DIGIT})+)?          { return TOKEN_DECIMAL; }

"//".*                               { /* Single line comment */}
"/*"                                 { handle_multi_line_comment(); }
.                                    { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
void fatal_error(char* str) {printf("%s\n", str);}
void handle_multi_line_comment() {
    // Here means we found a multiline comment
    int prev_char = 0;
    int current_char;

    while ((current_char = input()) != EOF && current_char != 0) {
        if (prev_char == '*' && current_char == '/') {
            return;
        }
        if (current_char == '\n') {
            yylineno += 1;
        }
        prev_char = current_char;
    }
    printf("Error: Unmatched multiline comment");
}

int handle_string_matching() {
    int actual_str_length = 0;
    int i = 1;

    while(i < yyleng - 1) {
        if (yytext[i] == '\\') {
            if (yytext[i+1] == '0' && yytext[i+2] == 'x') {
                i += 4; // Skip hex numbers as chars
                continue;
            } else {
                i += 2;    // Skip escape chars
                continue;
            }
        }
        i += 1;
        actual_str_length++;
    }
    
    if (actual_str_length > 255) {
        printf("Error: String literal exceeds 255 characters\n");
        return TOKEN_ERROR;
    }
    printf("length %d\n", actual_str_length);
    return TOKEN_STRING_LITERAL; 
}