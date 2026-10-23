%require "3.0"

%{
int yylex(void);
void yyerror(const char *message);
extern const char *input_filename;
extern int yylineno;
extern char *yytext;
%}

%define parse.error verbose
%define parse.lac full
%expect 0
%start transl_unit

%token TOKEN_EOF 0             "end of file"
%token TOKEN_ERROR             "lexical error"
%token TOKEN_IDENT             "identifier"
%token TOKEN_INTEGER_LITERAL   "integer literal"
%token TOKEN_DOUBLE_LITERAL    "double literal"
%token TOKEN_CHAR_LITERAL      "character literal"
%token TOKEN_STRING_LITERAL    "string literal"
%token TOKEN_ARRAY             "array"
%token TOKEN_CARRAY            "carray"
%token TOKEN_AUTO              "auto"
%token TOKEN_BOOLEAN_TYPE      "boolean"
%token TOKEN_CHAR_TYPE         "char"
%token TOKEN_DOUBLE_TYPE       "double"
%token TOKEN_INTEGER_TYPE      "integer"
%token TOKEN_STRING_TYPE       "string"
%token TOKEN_VOID              "void"
%token TOKEN_FUNCTION          "function"
%token TOKEN_IF                "if"
%token TOKEN_ELSE              "else"
%token TOKEN_FOR               "for"
%token TOKEN_PRINT             "print"
%token TOKEN_RETURN            "return"
%token TOKEN_TRUE              "true"
%token TOKEN_FALSE             "false"
%token TOKEN_FLOAT_TYPE        "float"
%token TOKEN_WHILE             "while"
%token TOKEN_INCREMENT         "++"
%token TOKEN_DECREMENT         "--"
%token TOKEN_LESS_EQUAL        "<="
%token TOKEN_GREATER_EQUAL     ">="
%token TOKEN_EQUAL             "=="
%token TOKEN_NOT_EQUAL         "!="
%token TOKEN_AND               "&&"
%token TOKEN_OR                "||"
%token TOKEN_COLON             ":"
%token TOKEN_SEMICOLON         ";"
%token TOKEN_COMMA             ","
%token TOKEN_ASSIGN            "="
%token TOKEN_LBRACE            "{"
%token TOKEN_RBRACE            "}"
%token TOKEN_L_SQ_BRACKET      "["
%token TOKEN_R_SQ_BRACKET      "]"
%token TOKEN_LPAREN            "("
%token TOKEN_RPAREN            ")"
%token TOKEN_PLUS              "+"
%token TOKEN_MINUS             "-"
%token TOKEN_MUL               "*"
%token TOKEN_EXPONENT          "^"
%token TOKEN_DIV               "/"
%token TOKEN_MODULO            "%"
%token TOKEN_GREATER           ">"
%token TOKEN_LESS              "<"
%token TOKEN_NOT               "!"
%token TOKEN_HASH              "#"

%%

transl_unit
    : %empty
    | transl_unit extern_decl
    ;

extern_decl
    : decl
    | TOKEN_IDENT TOKEN_COLON func_type TOKEN_ASSIGN block
    ;

decl
    : TOKEN_IDENT TOKEN_COLON obj_type initzr_opt TOKEN_SEMICOLON
    | TOKEN_IDENT TOKEN_COLON func_type TOKEN_SEMICOLON
    ;

primitive_type
    : TOKEN_INTEGER_TYPE
    | TOKEN_DOUBLE_TYPE
    | TOKEN_BOOLEAN_TYPE
    | TOKEN_CHAR_TYPE
    | TOKEN_STRING_TYPE
    ;

obj_type
    : primitive_type
    | TOKEN_AUTO
    | TOKEN_ARRAY  TOKEN_L_SQ_BRACKET expr TOKEN_R_SQ_BRACKET obj_type
    | TOKEN_CARRAY TOKEN_L_SQ_BRACKET expr TOKEN_R_SQ_BRACKET obj_type
    ;

func_type
    : TOKEN_FUNCTION return_type TOKEN_LPAREN params_opt TOKEN_RPAREN
    ;

return_type
    : primitive_type
    | TOKEN_AUTO
    | TOKEN_VOID
    ;

params_opt
    : %empty
    | params
    ;

params
    : param
    | params TOKEN_COMMA param
    ;

param
    : TOKEN_IDENT TOKEN_COLON param_type
    ;

param_type
    : primitive_type
    | TOKEN_ARRAY  TOKEN_L_SQ_BRACKET TOKEN_R_SQ_BRACKET param_type
    | TOKEN_CARRAY TOKEN_L_SQ_BRACKET TOKEN_R_SQ_BRACKET param_type
    | func_type
    ;

initzr_opt
    : %empty
    | TOKEN_ASSIGN initzr
    ;

initzr
    : expr
    | TOKEN_LBRACE initzrs TOKEN_RBRACE
    ;

/* braced initlizers are nonempty & have no trailing comma */
initzrs
    : initzr
    | initzrs TOKEN_COMMA initzr
    ;

block
    : TOKEN_LBRACE block_items TOKEN_RBRACE
    ;

block_items
    : %empty
    | block_items decl
    | block_items stmt
    ;

/* decl is block item; never bare if/else/for bodyy */
stmt
    : matchd_stmt
    | unmatchd_stmt
    ;

/* "matched" => no if remains available got following else */
matchd_stmt
    : block
    | expr TOKEN_SEMICOLON
    | TOKEN_PRINT args_opt TOKEN_SEMICOLON
    | TOKEN_RETURN expr_opt TOKEN_SEMICOLON
    | TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN matchd_stmt TOKEN_ELSE matchd_stmt
    | for_headr matchd_stmt
    ;

unmatchd_stmt
    : TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN stmt
    | TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN matchd_stmt TOKEN_ELSE unmatchd_stmt
    | for_headr unmatchd_stmt
    ;

for_headr
    : TOKEN_FOR TOKEN_LPAREN expr_opt TOKEN_SEMICOLON expr_opt TOKEN_SEMICOLON expr_opt TOKEN_RPAREN
    ;

expr_opt
    : %empty
    | expr
    ;

args_opt
    : %empty
    | args
    ;

args
    : expr
    | args TOKEN_COMMA expr
    ;

/* precedence encoded entirely by productions (low->high) */
expr
    : assig
    ;

assig
    : logic_or
    | logic_or TOKEN_ASSIGN assig
    ;

logic_or
    : logic_and
    | logic_or TOKEN_OR logic_and
    ;

logic_and
    : cmp
    | logic_and TOKEN_AND cmp
    ;

cmp
    : addtv
    | cmp TOKEN_LESS addtv
    | cmp TOKEN_LESS_EQUAL addtv
    | cmp TOKEN_GREATER addtv
    | cmp TOKEN_GREATER_EQUAL addtv
    | cmp TOKEN_EQUAL addtv
    | cmp TOKEN_NOT_EQUAL addtv
    ;

addtv
    : multv
    | addtv TOKEN_PLUS multv
    | addtv TOKEN_MINUS multv
    ;

multv
    : power
    | multv TOKEN_MUL power
    | multv TOKEN_DIV power
    | multv TOKEN_MODULO power
    ;

power
    : unary
    | unary TOKEN_EXPONENT power
    ;

/* prefix operators nest right->left and bind more tightly than ^ */
unary
    : postfix
    | TOKEN_PLUS unary
    | TOKEN_MINUS unary
    | TOKEN_NOT unary
    | TOKEN_HASH unary
    ;

postfix
    : access
    | postfix TOKEN_INCREMENT
    | postfix TOKEN_DECREMENT
    ;

access
    : primary
    | access TOKEN_L_SQ_BRACKET expr TOKEN_R_SQ_BRACKET
    | access TOKEN_LPAREN args_opt TOKEN_RPAREN
    ;

primary
    : TOKEN_IDENT
    | TOKEN_INTEGER_LITERAL
    | TOKEN_DOUBLE_LITERAL
    | TOKEN_CHAR_LITERAL
    | TOKEN_STRING_LITERAL
    | TOKEN_TRUE
    | TOKEN_FALSE
    | TOKEN_LPAREN expr TOKEN_RPAREN
    ;

%%

#include <stdio.h>

void yyerror(const char *message)
{
    if (yychar == TOKEN_ERROR) {
        fprintf(stderr, "scan error: line:%d, unrecognized token: `%s`\n", yylineno, yytext);
        return;
    }

    fprintf(stderr, "parse error: on line %d: %s\n", yylineno, message);
}

#define macro_tknzr(token) [token] = #token
const char *const token_names[] = {
    macro_tknzr(TOKEN_IDENT),
    macro_tknzr(TOKEN_INTEGER_LITERAL),
    macro_tknzr(TOKEN_DOUBLE_LITERAL),
    macro_tknzr(TOKEN_CHAR_LITERAL),
    macro_tknzr(TOKEN_STRING_LITERAL),
    macro_tknzr(TOKEN_ARRAY),
    macro_tknzr(TOKEN_CARRAY),
    macro_tknzr(TOKEN_AUTO),
    macro_tknzr(TOKEN_BOOLEAN_TYPE),
    macro_tknzr(TOKEN_CHAR_TYPE),
    macro_tknzr(TOKEN_DOUBLE_TYPE),
    macro_tknzr(TOKEN_INTEGER_TYPE),
    macro_tknzr(TOKEN_STRING_TYPE),
    macro_tknzr(TOKEN_VOID),
    macro_tknzr(TOKEN_FUNCTION),
    macro_tknzr(TOKEN_IF),
    macro_tknzr(TOKEN_ELSE),
    macro_tknzr(TOKEN_FOR),
    macro_tknzr(TOKEN_PRINT),
    macro_tknzr(TOKEN_RETURN),
    macro_tknzr(TOKEN_TRUE),
    macro_tknzr(TOKEN_FALSE),
    macro_tknzr(TOKEN_FLOAT_TYPE),
    macro_tknzr(TOKEN_WHILE),
    macro_tknzr(TOKEN_INCREMENT),
    macro_tknzr(TOKEN_DECREMENT),
    macro_tknzr(TOKEN_LESS_EQUAL),
    macro_tknzr(TOKEN_GREATER_EQUAL),
    macro_tknzr(TOKEN_EQUAL),
    macro_tknzr(TOKEN_NOT_EQUAL),
    macro_tknzr(TOKEN_AND),
    macro_tknzr(TOKEN_OR),
    macro_tknzr(TOKEN_COLON),
    macro_tknzr(TOKEN_SEMICOLON),
    macro_tknzr(TOKEN_COMMA),
    macro_tknzr(TOKEN_ASSIGN),
    macro_tknzr(TOKEN_LBRACE),
    macro_tknzr(TOKEN_RBRACE),
    macro_tknzr(TOKEN_L_SQ_BRACKET),
    macro_tknzr(TOKEN_R_SQ_BRACKET),
    macro_tknzr(TOKEN_LPAREN),
    macro_tknzr(TOKEN_RPAREN),
    macro_tknzr(TOKEN_PLUS),
    macro_tknzr(TOKEN_MINUS),
    macro_tknzr(TOKEN_MUL),
    macro_tknzr(TOKEN_EXPONENT),
    macro_tknzr(TOKEN_DIV),
    macro_tknzr(TOKEN_MODULO),
    macro_tknzr(TOKEN_GREATER),
    macro_tknzr(TOKEN_LESS),
    macro_tknzr(TOKEN_NOT),
    macro_tknzr(TOKEN_HASH)
};
#undef macro_tknzr
