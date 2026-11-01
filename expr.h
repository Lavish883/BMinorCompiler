#ifndef EXPR_H
#define EXPR_H

//#include "symbol.h"

typedef enum {
    EXPR_ASSIGN,
    EXPR_OR,
    EXPR_AND,
    EXPR_LT,
    EXPR_LE,
    EXPR_GT,
    EXPR_GE,
    EXPR_EQ,
    EXPR_NEQ,
    EXPR_ADD,
    EXPR_SUB,
    EXPR_MUL,
    EXPR_DIV,
    EXPR_MOD,
    EXPR_EXP,
    EXPR_NEG,
    EXPR_NOT,
    EXPR_LEN,
    EXPR_INC,
    EXPR_DEC,
    EXPR_GRP,
    EXPR_SUBSCRIPT,
    EXPR_CALL,
    EXPR_ARG,

    // Leaf nodes
    EXPR_NAME,
    EXPR_INTEGER_LITERAL,
    EXPR_BOOLEAN_LITERAL,
    EXPR_CHAR_LITERAL,
    EXPR_STRING_LITERAL,
} expr_t;

struct expr {
	/* used by all kinds of exprs */
	expr_t kind;
	struct expr *left;
	struct expr *right;

	/* used by various leaf exprs */
	const char *name;
	int literal_value;
	const char * string_literal;
	struct symbol *symbol;
};

struct expr * expr_create( expr_t kind, struct expr *left, struct expr *right );

struct expr * expr_create_name( const char *n );
struct expr * expr_create_integer_literal( int c );
struct expr * expr_create_boolean_literal( int c );
struct expr * expr_create_char_literal( char c );
struct expr * expr_create_string_literal( const char *str );

void expr_print( struct expr *e );

#endif
