#include <stdio.h>
#include <stdlib.h>
#include "param_list.h"
#include "symbol.h"

struct param_list* param_list_create(char* name, struct type* type, struct param_list* next) {
    struct param_list* p = malloc(sizeof(struct param_list));
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

void param_list_print(struct param_list* a, int indent) {
    if (!a) return;
    printf("%s: ", a->name);
    type_print(a->type, indent);
    if (a->next) {
        printf(", ");
        param_list_print(a->next, indent);
    }
}

void param_list_resolve(struct param_list* p_list, int which) {
    if (!p_list) return;
    p_list->symbol = symbol_create(1, p_list->type, p_list->name);
    p_list->symbol->which = which;
    scope_bind(p_list->name, p_list->symbol);
    param_list_resolve(p_list->next, which + 1);
}

void foo(int bar) {
    bar++;
    printf(bar);
}

int main() {
    int bar = 3;
    int baz = 4;
    foo(4);
}

// main
//     int_decl baz 4
//     call foo
//         arg1 4
//
// fn_decl param_list
