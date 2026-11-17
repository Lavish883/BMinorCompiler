#include <stdlib.h>
#include <stdbool.h>
#include <string.h> 
#include "type.h"
#include "symbol.h"

struct type *type_copy(struct type *t);
void type_delete(struct type *t);

bool type_equals(struct type *a, struct type *b)
{
    // invalid pointers
    if (a == NULL || b == NULL) {
        abort();
    }
    // different root types
    if (a->kind != b->kind) {
        return false;
    }

    // array subtypes
    if(a->kind == TYPE_ARRAY) {
        return type_equals(a->subtype, b->subtype);
    }
    // check function input/output types
    if(a->kind == TYPE_FUNCTION) {
        // Check output types
        if(!type_equals(a->subtype, b->subtype)) {
            return false;
        }

        // Check input types
        struct param_list *a_params = a->params;
        struct param_list *b_params = b->params;
        while(a_params != NULL && b_params != NULL) {
            if(!type_equals(a_params->type, b_params->type)) {
                return false;
            }
            a_params = a_params->next;
            b_params = b_params->next;
        }
        if(a_params != NULL || b_params != NULL) {
            return false;
        }
    }
    return true;
}

struct symbol* symbol_copy(struct symbol *s){
    struct symbol *copy = malloc(sizeof(struct symbol));
    if(s == NULL || copy == NULL){
        abort();
    }
    copy->kind = s->kind;
    copy->type = type_copy(s->type);
    copy->name = strdup(s->name);
    copy->which = s->which;
    return copy;
}

struct param_list *param_list_copy(struct param_list *p){
    if(p == NULL){
        return NULL;
    }
    struct param_list *copy = malloc(sizeof(struct param_list));
    if(copy == NULL){
        abort();
    }
    copy->name = strdup(p->name);
    copy->type = type_copy(p->type);
    copy->symbol = symbol_copy(p->symbol);
    copy->next = param_list_copy(p->next);
    return copy;
}

struct type* type_copy(struct type *t){
    if(t == NULL){
        return NULL;
    }
    struct type *copy = malloc(sizeof(struct type));
    if(copy == NULL){
        abort();
    }
    copy->kind = t->kind;
    copy->subtype = type_copy(t->subtype);
    copy->params = param_list_copy(t->params);
    return copy;
}

void symbol_delete(struct symbol *s){
    if(s == NULL){
        return;
    }
    free(s->name);
    type_delete(s->type);
    free(s);
}

void param_list_delete(struct param_list *p){
    if(p == NULL){
        return;
    }
    free(p->name);
    type_delete(p->type);
    symbol_delete(p->symbol);
    param_list_delete(p->next);
    free(p);
}

void type_delete(struct type *t){
    if(t == NULL){
        return;
    }
    type_delete(t->subtype);
    param_list_delete(t->params);
    free(t);
}