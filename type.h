#ifndef TYPE_H
#define TYPE_H
#define NOT_DEFINED_LENGTH_MAGIC_NUMBER -8080

#include "param_list.h"
#include <stdbool.h>

typedef enum {
	TYPE_VOID,
	TYPE_BOOLEAN,
	TYPE_CHARACTER,
	TYPE_INTEGER,
	TYPE_STRING,
	TYPE_ARRAY,
	TYPE_FUNCTION,
	TYPE_AUTO,
	TYPE_CARRAY,
	TYPE_DOUBLE
} type_t;

extern char* type_to_str_mapping[];

struct type {
	type_t kind;
	struct param_list *params;
	struct type *subtype;
	int array_size;
	bool size_defined;
};

struct type * type_create( type_t kind, struct type *subtype, struct param_list *params, int array_size, bool size_defined);
void          type_print( struct type *t, int indent );

#endif
