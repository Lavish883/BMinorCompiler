#include <stdio.h>
#include <stdlib.h>
#include "param_list.h"

struct param_list * param_list_create( char *name, struct type *type, struct param_list *next ) {
    struct param_list *p = malloc(sizeof(struct param_list));
    if (!p) {
        printf("Error: failed to allocate memory for param_list\n");
        exit(1);
    }
    p->name = name;
    p->type = type;
    p->symbol = NULL;
    p->next = next;
    return p;
}

void param_list_print( struct param_list *a, int indent ) {
    if (!a) return;
    printf("%s: ", a->name);
    type_print(a->type, indent);
    if (a->next) {
        printf(", ");
        param_list_print(a->next, indent);
    }
}
