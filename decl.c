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
    d->next = next;
    return d;
}

void decl_print(struct decl* d, int indent) {
    if (!d) return;
    printf("%s: ", d->name);
    type_print(d->type, indent);

    if (d->value != NULL) {
        printf(" = ");
        expr_print(d->value, indent);
        printf(";\n");
    }
    
    if (d->code != NULL) {
        stmt_print(d->code, indent);
    }

    decl_print(d->next, indent);
}