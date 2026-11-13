#include <stdio.h>
#include <stdlib.h>
#include "type.h"

char* type_to_str_mapping[] = {
    "void",
    "boolean",
    "char",
    "integer",
    "string",
    "array",
    "function",
    "auto",
    "carray",
    "double"
};

struct type* type_create(type_t kind, struct type* subtype, struct param_list* params, int array_size, bool size_defined) {
    struct type* t = malloc(sizeof(struct type));
    if (!t) {
        printf("Error: failed to allocate memory for type\n");
        exit(1);
    }
    t->kind = kind;
    t->subtype = subtype;
    t->params = params;
    t->array_size = array_size;
    t->size_defined = size_defined;
    return t;
}

void type_print(struct type* t, int indent) {
    if (!t) return;
    printf("%s", type_to_str_mapping[t->kind]);
    if (t->kind == TYPE_CARRAY || t->kind == TYPE_ARRAY) {
        printf(" [");
        if (t->size_defined) {
            printf("%d", t->array_size);
        }
        printf("] ");
    }
    if (t->subtype != NULL) {
        printf(" ");
    }
    type_print(t->subtype, indent);
    if (t->kind == TYPE_FUNCTION) {
        printf(" (");
        param_list_print(t->params, indent);
        printf(") = \n");
    }
}