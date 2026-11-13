#ifndef EXPR_H
#define EXPR_H

#include "symbol.h"

typedef enum {
	EXPR_ADD,
	EXPR_SUB,
	EXPR_ASSIGN,
	EXPR_OR,
	EXPR_AND,
	EXPR_LESS,
	EXPR_LESS_EQUAL,
	EXPR_GREATER,
	EXPR_GREATER_EQUAL,
	EXPR_EQUAL,
	EXPR_NOT_EQUAL,
	EXPR_MUL,
	EXPR_DIV,
	EXPR_MODULO,
	EXPR_POWER,
	EXPR_POSITIVE,
	EXPR_NEGATIVE,
	EXPR_NOT,
	EXPR_HASH,
	EXPR_POST_INC,
	EXPR_POST_DEC,
	EXPR_ARRAY_ACCESS,
	EXPR_NAME,
	EXPR_INTEGER_LITERAL,
	EXPR_DOUBLE_LITERAL,
	EXPR_BOOLEAN_LITERAL,
	EXPR_CHAR_LITERAL,
	EXPR_STRING_LITERAL,
	EXPR_ARRAY_INIT,
	EXPR_ARRAY_ITEM,
	EXPR_CALL,
	EXPR_ARG
} expr_t;

struct expr {
	/* used by all kinds of exprs */
	expr_t kind;
	struct expr *left;
	struct expr *right;

	/* used by various leaf exprs */
	const char *name;
	int literal_value;
	double double_literal;
	const char * string_literal;
	struct symbol *symbol;
	struct expr *next;  /* used for array literal elements */
};

struct expr * expr_create( expr_t kind, struct expr *left, struct expr *right );

struct expr * expr_create_name( const char *n );
struct expr * expr_create_integer_literal( int c );
struct expr * expr_create_double_literal( double c );
struct expr * expr_create_boolean_literal( int c );
struct expr * expr_create_char_literal( char c );
struct expr * expr_create_string_literal( const char *str );
// Added new one to deal with array literal
struct expr * expr_create_array_init( struct expr *elements );
struct expr * expr_create_array_item( struct expr *element, struct expr *next );

void expr_print( struct expr *e, int indent );

#endif
