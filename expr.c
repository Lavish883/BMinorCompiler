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