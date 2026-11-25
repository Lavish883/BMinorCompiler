#include "decl.h"
#include "expr.h"
#include "hash_table.h"
#include "stmt.h"
#include "symbol.h"
#include "type.h"
#include "stack.h"

typedef struct stack Stack;
typedef struct hash_table HASH_TABLE;

Stack* symbol_stack = NULL;

void scope_enter() {
    if (!symbol_stack) {
        symbol_stack = stack_create();
    }
    HASH_TABLE* new_table = hash_table_create(0, 0);
    stack_push(symbol_stack, new_table);
}
void scope_exit() {
    if (!symbol_stack || scope_level() == 0) {
        printf("Error: No scope to exit.\n");
        exit(1);
    }
    HASH_TABLE* current_table = stack_pop(symbol_stack);
    hash_table_delete(current_table);
}
int scope_level() {
    if (!symbol_stack) return 0;
    return (int)stack_size(symbol_stack);
}
void scope_bind(const char* name, struct symbol* sym) {
    if (!symbol_stack || scope_level() == 0) {
        printf("Error: No current scope to bind symbol.\n");
        exit(1);
    }
    HASH_TABLE* current_table = stack_item(stack_size(symbol_stack) - 1);
    if (!current_table) {
        printf("Error: No current scope to bind symbol.\n");
        exit(1);
    }
    hash_table_insert(current_table, name, sym);
}
struct symbol* scope_lookup_current(const char* name) {
    if (scope_level() == 0) return NULL;
    HASH_TABLE* current_table = stack_item(stack_size(symbol_stack) - 1);
    if (!current_table) return NULL;
    void* result = hash_table_lookup(current_table, name);
    return (struct symbol*)result;
}
struct symbol* scope_lookup(const char* name) {
    if (scope_level() == 0) return NULL;
    for (int i = scope_level() - 1; i >= 0; i--) {
        HASH_TABLE* table = stack_item(i);
        if (!table) return NULL;
        void* result = hash_table_lookup(table, name);
        if (result != NULL) {
            return (struct symbol*)result;
        }
    }
    return NULL;
}

struct symbol* symbol_create(symbol_t kind,
                             struct type* type,
                             char* name) {
    struct symbol* s = (struct symbol*)malloc(sizeof(struct symbol));
    if (s == NULL) {
        printf("malloc failed while creating symbol");
        exit(1);
    }
    s->kind = kind;
    s->type = type;
    s->name = name;
}
