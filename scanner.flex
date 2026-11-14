%option yylineno
%{
#include "parser.out.h"
#include <string.h>
#include <errno.h>
#include <math.h>
int get_string_token();
int is_valid_multiline_comment();
int get_ident_token();
int get_integer_token(const char *digits, int base);
int get_double_token();
static char decode_char_literal(const char *text);
static int scan_error(const char *reason, int line, int show_text);
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
false { 
    yylval.boolean_literal = 0;
    return TOKEN_FALSE;
}
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
true { 
    yylval.boolean_literal = 1;
    return TOKEN_TRUE; 
}

({LETTER}|_)+({DIGIT}|{LETTER}|_)*       { return get_ident_token(); }

\'([^\'\\\n]|\\.|\\0x{HEX_DIGIT}{2})\'       {
    yylval.char_literal = decode_char_literal(yytext);
    return TOKEN_CHAR_LITERAL;
}

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

0x{HEX_DIGIT}+   { return get_integer_token(yytext + 2, 16); }

0b(0|1)+ { return get_integer_token(yytext + 2, 2); }

0[xb]({DIGIT}|{LETTER}|_)*           { return scan_error("malformed integer literal", yylineno, 1); } /* Malformed 0x/0b literal (0x, 0x0x1, 0b012) */

{DIGIT}+((\.){DIGIT}+)?(e|E)(\+|\-)?{DIGIT}+  { return get_double_token(); }

{DIGIT}+ { return get_integer_token(yytext, 10); }

{DIGIT}+\.{DIGIT}+ { return get_double_token(); }


"//".*                               { /* Single line comment */}
"/*"                                 { int start_line = yylineno;
                                       if (!is_valid_multiline_comment()) return scan_error("unterminated comment", start_line, 0); }
.                                    { return scan_error("unrecognized token", yylineno, 1); }
%%
int yywrap() { return 1; }
int is_valid_multiline_comment() {
    // Here means we found a multiline comment
    int prev_char = 0;
    int current_char;

    while ((current_char = input()) != EOF && current_char != 0) {
        if (prev_char == '*' && current_char == '/') {
            return 1;
        }
        prev_char = current_char;
    }
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
        return scan_error("string literal longer than 255 characters", yylineno, 0);
    }
    // printf("length %d\n", actual_str_length);
    yylval.string_literal = strdup(yytext);
    return TOKEN_STRING_LITERAL;
}

int get_ident_token() {
    if (yyleng > 255) return scan_error("identifier longer than 255 characters", yylineno, 0);
    yylval.ident = strdup(yytext);
    return TOKEN_IDENT;
}

/* integers are signed 64-bit */
int get_integer_token(const char *digits, int base) {
    errno = 0;
    yylval.integer_literal = strtoll(digits, NULL, base);
    if (errno == ERANGE) return scan_error("integer literal out of range", yylineno, 1);
    return TOKEN_INTEGER_LITERAL;
}

/* keeps both value and source text, so the printer can make a canonical version */
int get_double_token() {
    yylval.double_literal.value = strtod(yytext, NULL);
    if (isinf(yylval.double_literal.value)) return scan_error("double literal out of range", yylineno, 1);
    yylval.double_literal.text = strdup(yytext);
    return TOKEN_DOUBLE_LITERAL;
}

static char decode_char_literal(const char *text) {
    const char *p = text + 1;
    // not an escape: the char itself
    if (*p != '\\') {
        return *p;
    }
    switch (*++p) {
        case 'a': return 7;
        case 'b': return 8;
        case 'e': return 27;
        case 'f': return 12;
        case 'n': return 10;
        case 'r': return 13;
        case 't': return 9;
        case 'v': return 11;
        case '0': if (p[1] == 'x') {
                    return (char) strtol(p + 2, NULL, 16);
                  }
                  return '0';
        default:  return *p; /* \\ \' \" and any char */
    }
}

/* why the last TOKEN_ERROR was returned, for print_scan_error() */
static const char *error_reason = "unrecognized token";
static int error_line = 0;
static int error_shows_text = 1;

static int scan_error(const char *reason, int line, int show_text) {
    error_reason = reason;
    error_line = line;
    error_shows_text = show_text;
    return TOKEN_ERROR;
}

/* call right after yylex() returns TOKEN_ERROR, while yytext still holds the token */
void print_scan_error(void) {
    fprintf(stderr, "scan error: on line %d: %s", error_line, error_reason);
    if (error_shows_text) fprintf(stderr, " `%s`", yytext);
    fputc('\n', stderr);
}
