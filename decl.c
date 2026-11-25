#include <stdio.h>
#include <stdlib.h>
#include "decl.h"
#include "type.h"
#include "helpers.h"

struct decl* decl_create(char* name, struct type* type, struct expr* value, struct stmt* code, struct decl* next) {
    struct decl* d = malloc(sizeof(struct decl));
    if (!d) {
        printf("Error: failed to allocate memory for decl\n");
        exit(1);
    }
    d->name = name;
    d->type = type;
    d->value = value;
    d->code = code;
    d->symbol = NULL;
    d->next = next;
    return d;
}

void decl_print(struct decl* d, int indent) {
    if (!d) return;
    printf("%s: ", d->name);
    type_print(d->type, indent);

    if (d->value != NULL && d->code == NULL) {
        printf(" = ");
        expr_print(d->value, indent);
        printf(";\n");
    } else if (d->code != NULL) {
        printf(" =\n");
        stmt_print(d->code, indent);
    } else {
        printf(";\n");
    }

    decl_print(d->next, indent);
}

void decl_resolve(struct decl* d) {
    if (!d) return;
    symbol_t kind = scope_level() > 1 ? SYMBOL_LOCAL : SYMBOL_GLOBAL;
    d->symbol = symbol_create(kind, d->type, d->name);
    expr_resolve(d->value);
    scope_bind(d->name, d->symbol);
    if (d->code) {
        scope_enter();
        param_list_resolve(d->type->params);
        stmt_resolve(d->code);
        scope_exit();
    }
    decl_resolve(d->next);
}
