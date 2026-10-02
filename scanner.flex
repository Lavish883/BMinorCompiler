%option   yylineno
%{
#include "token.h"
int get_string_token();
int is_valid_multiline_comment();
int get_ident_token();
%}
DIGIT [0-9]
LETTER [a-zA-Z]
ASCII_CHAR [\x00-\x7F]
HEX_DIGIT [0-9a-fA-F]
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

({LETTER}|_)+({DIGIT}|{LETTER}|_)*       { return get_ident_token(); }

\'([^\'\\\n]|\\.|\\0x{HEX_DIGIT}{2})\'                     { return TOKEN_CHAR_LITERAL; }
\"([^\"\\\n]|\\.|\\0x{HEX_DIGIT}{2})*\"                   { return get_string_token(); }
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
(0x)+([0-9]|[a-f]|[A-F])*            { return TOKEN_INTEGER_LITERAL; }
(0b)+(0|1)*                          { return TOKEN_INTEGER_LITERAL; }
{DIGIT}+((\.){DIGIT}+)?(e|E)(\+|\-)?{DIGIT}+      { return TOKEN_DOUBLE_LITERAL; }
{DIGIT}*(\.({DIGIT})+)?          { return TOKEN_DOUBLE_LITERAL; }
{DIGIT}+                        { return TOKEN_INTEGER_LITERAL; }


"//".*                               { /* Single line comment */}
"/*"                                 { if (!is_valid_multiline_comment()) return TOKEN_ERROR; }
.                                    { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
int is_valid_multiline_comment() {
    // Here means we found a multiline comment
    int prev_char = 0;
    int current_char;
    int beg_line_no = yylineno;

    while ((current_char = input()) != EOF && current_char != 0) {
        if (prev_char == '*' && current_char == '/') {
            return 1;
        }
        prev_char = current_char;
    }
    printf("Error: Unmatched multiline comment at line %d \n", beg_line_no);
    return 0;
}

int get_string_token() {
    int actual_str_length = 0;
    int i = 0;

    while(i < yyleng) {
        if (yytext[i] == '\\') {
            if (i < yyleng - 5  && yytext[i+1] == '0' && yytext[i+2] == 'x') {
                i += 5; // Skip hex numbers as chars
                actual_str_length++;
                continue;
            } else {
                i += 2;    // Skip escape chars
                actual_str_length++;
                continue;
            }
        }
        i += 1;
        actual_str_length++;
    }
    
    if (actual_str_length > 257) {
        printf("Error: String literal exceeds 255 characters\n");
        return TOKEN_ERROR;
    }
    // printf("length %d\n", actual_str_length);
    return TOKEN_STRING_LITERAL; 
}

int get_ident_token() {
    if (yyleng > 255) return TOKEN_ERROR;
    return TOKEN_IDENT;
}