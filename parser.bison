%require "3.0"

%{
int yylex(void);
void yyerror(const char *message);
extern const char *input_filename;
extern int yylineno;
void print_scan_error(void);
#include "decl.h"
#include "type.h"
#include "stmt.h"
#include "expr.h"
#include "param_list.h"
extern struct decl* parser_result;
%}


%define parse.error verbose
%define parse.lac full
%expect 0
%start program

%union {
  struct decl* decl;
  struct stmt* stmt;
  struct type* type;
  struct expr* expr;
  struct param_list* param_list;

  char* ident; 
  int integer_literal;
  double double_literal;
  char char_literal;
  char* string_literal;
  int boolean_literal;
}

%type <decl> program decl_list decl obj_decl
%type <stmt> stmt block block_items matchd_stmt unmatchd_stmt for_headr
%type <type> func_type obj_type return_type param_type primitive_type
%type <expr> expr initializer_opt initializer brace_initializer expr_opt args_opt args assig logic_or logic_and cmp addtv multv power unary postfix access primary
%type <param_list> params_opt params_list param
%type <integer_literal> array_size

%token TOKEN_EOF 0             "end of file"
%token TOKEN_ERROR             "lexical error"
%token <ident> TOKEN_IDENT             "identifier"
%token <integer_literal> TOKEN_INTEGER_LITERAL   "integer literal"
%token <double_literal> TOKEN_DOUBLE_LITERAL    "double literal"
%token <char_literal> TOKEN_CHAR_LITERAL      "character literal"
%token <string_literal> TOKEN_STRING_LITERAL    "string literal"
%token TOKEN_ARRAY             "array"
%token TOKEN_CARRAY            "carray"
%token TOKEN_AUTO              "auto"
%token <type> TOKEN_BOOLEAN_TYPE      "boolean"
%token <type> TOKEN_CHAR_TYPE         "char"
%token <type> TOKEN_DOUBLE_TYPE       "double"
%token <type> TOKEN_INTEGER_TYPE      "integer"
%token <type> TOKEN_STRING_TYPE       "string"
%token TOKEN_VOID              "void"
%token TOKEN_FUNCTION          "function"
%token TOKEN_IF                "if"
%token TOKEN_ELSE              "else"
%token TOKEN_FOR               "for"
%token TOKEN_PRINT             "print"
%token TOKEN_RETURN            "return"
%token <boolean_literal> TOKEN_TRUE              "true"
%token <boolean_literal> TOKEN_FALSE             "false"
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

program : decl_list
      { parser_result = $1; }
    ;

decl_list
    : %empty
      { $$ = 0; }
    | decl decl_list
      { $$ = $1; $1->next = $2; }
    ;

/* only top level functions: blocks take obj_decl, so definitions can't nest */
decl
    : obj_decl
    | TOKEN_IDENT TOKEN_COLON func_type TOKEN_SEMICOLON
      { $$ = decl_create($1, $3, 0, 0, 0); }
    | TOKEN_IDENT TOKEN_COLON func_type TOKEN_ASSIGN block
      { $$ = decl_create($1, $3, 0, $5, 0); }
    ;

obj_decl
    : TOKEN_IDENT TOKEN_COLON obj_type initializer_opt TOKEN_SEMICOLON
      { $$ = decl_create($1, $3, $4, 0, 0); }
    ;

primitive_type
    : TOKEN_INTEGER_TYPE
      { $$ = type_create(TYPE_INTEGER, 0, 0, 0, 0); }
    | TOKEN_DOUBLE_TYPE
      { $$ = type_create(TYPE_DOUBLE, 0, 0, 0, 0); }
    | TOKEN_BOOLEAN_TYPE
      { $$ = type_create(TYPE_BOOLEAN, 0, 0, 0, 0); }
    | TOKEN_CHAR_TYPE
      { $$ = type_create(TYPE_CHARACTER, 0, 0, 0, 0); }
    | TOKEN_STRING_TYPE
      { $$ = type_create(TYPE_STRING, 0, 0, 0, 0); }
    ;

obj_type
    : primitive_type
    | TOKEN_AUTO
      { $$ = type_create(TYPE_AUTO, 0, 0, 0, 0); }
    | TOKEN_ARRAY  TOKEN_L_SQ_BRACKET array_size TOKEN_R_SQ_BRACKET obj_type
      { $$ = type_create(TYPE_ARRAY, $5, 0, $3, 1); }
    | TOKEN_CARRAY TOKEN_L_SQ_BRACKET array_size TOKEN_R_SQ_BRACKET obj_type
      { $$ = type_create(TYPE_CARRAY, $5, 0, $3, 1); }  
    ;

array_size:
    %empty
    { $$ = NOT_DEFINED_LENGTH_MAGIC_NUMBER; }
    | TOKEN_INTEGER_LITERAL
    ;

func_type
    : TOKEN_FUNCTION return_type TOKEN_LPAREN params_opt TOKEN_RPAREN
        { $$ = type_create(TYPE_FUNCTION, $2, $4, 0, 0); }
    ;

return_type
    : primitive_type
    | TOKEN_AUTO
      { $$ = type_create(TYPE_AUTO, 0, 0, 0, 0); }
    | TOKEN_VOID
      { $$ = type_create(TYPE_VOID, 0, 0, 0, 0); }
    ;

params_opt
    : %empty
    { $$ = 0; }
    | params_list
    ;

params_list
    : param
    | param TOKEN_COMMA params_list
      { $$ = $1; $1->next = $3; }
    ;

param
    : TOKEN_IDENT TOKEN_COLON param_type
      { $$ = param_list_create($1, $3, 0); }
    ;

param_type
    : primitive_type
    | TOKEN_ARRAY  TOKEN_L_SQ_BRACKET TOKEN_R_SQ_BRACKET param_type
      { $$ = type_create(TYPE_ARRAY, $4, 0, 0, 0); }
    | TOKEN_CARRAY TOKEN_L_SQ_BRACKET TOKEN_R_SQ_BRACKET param_type
      { $$ = type_create(TYPE_CARRAY, $4, 0, 0, 0); }
    | func_type
    ;

/* opt means optional,
 * this accounts for both declaration and initialization
 */
initializer_opt
    : %empty
      { $$ = 0; }
    | TOKEN_ASSIGN initializer
      { $$ = $2; }
    ;

initializer
    : expr
    | TOKEN_LBRACE brace_initializer TOKEN_RBRACE
        {$$ = expr_create_array_init($2); }
    ;

/* braced initlizers are nonempty & have no trailing comma */
brace_initializer
    : initializer
        {$$ = expr_create_array_item($1, 0); }
    |  initializer TOKEN_COMMA brace_initializer
        { $$ = expr_create_array_item($1, $3); }
    ;

block
    : TOKEN_LBRACE block_items TOKEN_RBRACE
      { $$ =  stmt_create(STMT_BLOCK, 0, 0, 0, 0, $2, 0, 0); }
    ;

block_items
    : %empty
    { $$ = 0; }
    | obj_decl block_items
     {$$ = stmt_create(STMT_DECL, $1, 0, 0, 0, 0, 0, $2); }
    | stmt block_items
     {$$ = $1; $1->next = $2; }
    ;

/* obj_decl is a block item, never a bare if/else/for body (Q3.0) */
stmt
    : matchd_stmt
    | unmatchd_stmt
    ;

/* "matched" => no if remains available got following else */
matchd_stmt
    : block
    | expr TOKEN_SEMICOLON
        {$$ = stmt_create(STMT_EXPR, 0, 0, $1, 0, 0, 0, 0); }
    | TOKEN_PRINT args_opt TOKEN_SEMICOLON
        {$$ = stmt_create(STMT_PRINT, 0, 0, $2, 0, 0, 0, 0); }
    | TOKEN_RETURN expr_opt TOKEN_SEMICOLON
        {$$ = stmt_create(STMT_RETURN, 0, 0, $2, 0, 0, 0, 0); }
    | TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN matchd_stmt TOKEN_ELSE matchd_stmt
        {$$ = stmt_create(STMT_IF_ELSE, 0, 0, $3, 0, $5, $7, 0); }
    | for_headr matchd_stmt
        {$$ = $1; $1->body = $2; }
    ;

unmatchd_stmt
    : TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN stmt
        {$$ = stmt_create(STMT_IF, 0, 0, $3, 0, $5, 0, 0); }
    | TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN matchd_stmt TOKEN_ELSE unmatchd_stmt
        {$$ = stmt_create(STMT_IF_ELSE, 0, 0, $3, 0, $5, $7, 0); }
    | for_headr unmatchd_stmt
        {$$ = $1; $1->body = $2; }
    ;

for_headr
    : TOKEN_FOR TOKEN_LPAREN expr_opt TOKEN_SEMICOLON expr_opt TOKEN_SEMICOLON expr_opt TOKEN_RPAREN
        {$$ = stmt_create(STMT_FOR, 0, $3, $5, $7, 0, 0, 0); }
    ;

expr_opt
    : %empty
    { $$ = 0; }
    | expr
    ;

args_opt
    : %empty
    { $$ = 0; }
    | args
    ;


args
    : expr
    | expr TOKEN_COMMA args
      { $$ = expr_create(EXPR_ARG, $1, $3); }
    ;

/* precedence encoded entirely by productions (low->high) */
expr
    : assig
    ;

assig
    : logic_or
    | logic_or TOKEN_ASSIGN assig
    { $$ = expr_create(EXPR_ASSIGN, $1, $3); }
    ;

logic_or
    : logic_and
    | logic_or TOKEN_OR logic_and
    { $$ = expr_create(EXPR_OR, $1, $3); }
    ;

logic_and
    : cmp
    | logic_and TOKEN_AND cmp
    { $$ = expr_create(EXPR_AND, $1, $3); }
    ;

cmp
    : addtv
    | cmp TOKEN_LESS addtv
    { $$ = expr_create(EXPR_LESS, $1, $3); }
    | cmp TOKEN_LESS_EQUAL addtv
    { $$ = expr_create(EXPR_LESS_EQUAL, $1, $3); }
    | cmp TOKEN_GREATER addtv
    { $$ = expr_create(EXPR_GREATER, $1, $3); }
    | cmp TOKEN_GREATER_EQUAL addtv
    { $$ = expr_create(EXPR_GREATER_EQUAL, $1, $3); }
    | cmp TOKEN_EQUAL addtv
    { $$ = expr_create(EXPR_EQUAL, $1, $3); }
    | cmp TOKEN_NOT_EQUAL addtv
    { $$ = expr_create(EXPR_NOT_EQUAL, $1, $3); }
    ;

addtv
    : multv
    | addtv TOKEN_PLUS multv
    { $$ = expr_create(EXPR_ADD, $1, $3); }
    | addtv TOKEN_MINUS multv
    { $$ = expr_create(EXPR_SUB, $1, $3); }
    ;

multv
    : power
    | multv TOKEN_MUL power
    { $$ = expr_create(EXPR_MUL, $1, $3); }
    | multv TOKEN_DIV power
    { $$ = expr_create(EXPR_DIV, $1, $3); }
    | multv TOKEN_MODULO power
    { $$ = expr_create(EXPR_MODULO, $1, $3); }
    ;

power
    : unary
    | unary TOKEN_EXPONENT power
    { $$ = expr_create(EXPR_POWER, $1, $3); }
    ;

/* prefix operators nest right->left and bind more tightly than ^ */
unary
    : postfix
    | TOKEN_PLUS unary
    { $$ = expr_create(EXPR_POSITIVE, $2, 0); }
    | TOKEN_MINUS unary
    { $$ = expr_create(EXPR_NEGATIVE, $2, 0); }
    | TOKEN_NOT unary
    { $$ = expr_create(EXPR_NOT, $2, 0); }
    | TOKEN_HASH unary
    { $$ = expr_create(EXPR_HASH, $2, 0); }
    ;

postfix
    : access
    | postfix TOKEN_INCREMENT
    { $$ = expr_create(EXPR_POST_INC, $1, 0); }
    | postfix TOKEN_DECREMENT
    { $$ = expr_create(EXPR_POST_DEC, $1, 0); }
    ;

access
    : primary
    | access TOKEN_L_SQ_BRACKET expr TOKEN_R_SQ_BRACKET
    { $$ = expr_create(EXPR_ARRAY_ACCESS, $1, $3); }
    | access TOKEN_LPAREN args_opt TOKEN_RPAREN
    { $$ = expr_create(EXPR_CALL, $1, $3); }
    ;

primary
    : TOKEN_IDENT
    { $$ = expr_create_name($1); }
    | TOKEN_INTEGER_LITERAL
    { $$ = expr_create_integer_literal($1); }
    | TOKEN_DOUBLE_LITERAL
    { $$ = expr_create_double_literal($1); }
    | TOKEN_CHAR_LITERAL
    { $$ = expr_create_char_literal($1); }
    | TOKEN_STRING_LITERAL
    { $$ = expr_create_string_literal($1); }
    | TOKEN_TRUE
    { $$ = expr_create_boolean_literal(1); }
    | TOKEN_FALSE
    { $$ = expr_create_boolean_literal(0); }
    | TOKEN_LPAREN expr TOKEN_RPAREN
    { $$ = expr_create(EXPR_GROUP, $2, 0); }
    ;

%%

#include <stdio.h>

void yyerror(const char *message)
{
    if (yychar == TOKEN_ERROR) {
        print_scan_error();
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
