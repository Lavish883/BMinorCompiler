
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

struct symbol* symbol_create(symbol_t kind, struct type* type, char* name);
void scope_bind(const char* name, struct symbol* sym);
struct symbol* scope_lookup_current(const char* name);
struct symbol* scope_lookup(const char* name);

#endif
