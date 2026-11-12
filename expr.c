#include <stdio.h>
#include <stdlib.h>
#include "expr.h"

struct expr* expr_create( expr_t kind, struct expr *left, struct expr *right ) {
    struct expr* e = malloc(sizeof(struct expr));
    if (!e) {
        printf("Error: failed to allocate memory for expr\n");
        exit(1);
    }
    e->kind = kind;
    e->left = left;
    e->right = right;
    return e;
}
struct expr* expr_create_array_literal( struct expr *elements ) {
    struct expr* e = expr_create(EXPR_ARRAY_LITERAL, NULL, NULL);
    e->next = elements;
    return e;
}

struct expr* expr_create_name( const char *n ) {
    struct expr* e = expr_create(EXPR_NAME, NULL, NULL);
    e->name = n;
    return e;
}

struct expr* expr_create_integer_literal( int c ) {
    struct expr* e = expr_create(EXPR_INTEGER_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_double_literal( double c ) {
    struct expr* e = expr_create(EXPR_DOUBLE_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_boolean_literal( int c ) {
    struct expr* e = expr_create(EXPR_BOOLEAN_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_char_literal( char c ) {
    struct expr* e = expr_create(EXPR_CHAR_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_string_literal( const char *str ) {
    struct expr* e = expr_create(EXPR_STRING_LITERAL, NULL, NULL);
    e->string_literal = str;
    return e;
}
