
#ifndef SYMBOL_H
#define SYMBOL_H

#include "type.h"

typedef enum {
    SYMBOL_LOCAL,
    SYMBOL_PARAM,
    SYMBOL_GLOBAL
} symbol_t;

struct symbol {
    symbol_t kind;
    struct type* type;
    char* name;
    int which;
};

void scope_enter();
void scope_exit();
int scope_level();
void scope_bind(const char* name, struct symbol* sym);
struct symbol* scope_lookup_current(const char* name);
struct symbol* scope_lookup(const char* name);
struct symbol* symbol_create(symbol_t kind, struct type* type, char* name);

#endif
