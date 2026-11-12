#include <stdio.h>
#include <stdlib.h>
#include "type.h"


struct type* type_create( type_t kind, struct type *subtype, struct param_list *params ) {
    struct type* t =  malloc(sizeof(struct type));
    if (!t) {
        printf("Error: failed to allocate memory for type\n");
        exit(1);
    }
    t->kind = kind;
    t->subtype = subtype;
    t->params = params;
    return t;
}
