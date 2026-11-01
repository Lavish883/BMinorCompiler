#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expr.h"

struct expr * expr_create( expr_t kind, struct expr *left, struct expr *right )
{
    struct expr* expr = calloc(1, sizeof(struct expr));
    if(!expr)
        return NULL;

    expr->kind = kind;
    expr->left = left;
    expr->right = right;

    return expr;
}

struct expr * expr_create_name( const char *n )
{
    struct expr* expr = expr_create(EXPR_NAME, NULL, NULL);
    if(!expr)
        return NULL;

    expr->name = n;
    return expr;
}

struct expr * expr_create_integer_literal( int c )
{
    struct expr* expr = expr_create(EXPR_INTEGER_LITERAL, NULL, NULL);
    if(!expr)
        return NULL;

    expr->literal_value = c;
    return expr;
}

struct expr * expr_create_boolean_literal( int c )
{
    struct expr* expr = expr_create(EXPR_BOOLEAN_LITERAL, NULL, NULL);
    if(!expr)
        return NULL;

    expr->literal_value = c;
    return expr;
}

struct expr * expr_create_char_literal( char c )
{
    struct expr* expr = expr_create(EXPR_CHAR_LITERAL, NULL, NULL);
    if(!expr)
        return NULL;

    expr->literal_value = c;
    return expr;
}

struct expr * expr_create_string_literal( const char *str )
{
    struct expr* expr = expr_create(EXPR_STRING_LITERAL, NULL, NULL);
    if(!expr)
        return NULL;

    expr->string_literal = strdup(str);
    return expr;
}

void expr_print( struct expr *e )
{
    if(!e) return;

    // Handle special cases first
    if(e->kind == EXPR_GRP) {
        printf("(");
        expr_print(e->left);
        printf(")");
    } else if(e->kind == EXPR_SUBSCRIPT) {
        expr_print(e->left);
        printf("[");
        expr_print(e->right);
        printf("]");
    } else if(e->kind == EXPR_CALL) {
        expr_print(e->left);
        printf("(");

        for(e = e->right; e != NULL; e = e->right) {
            expr_print(e->left);
            if(e->right)
                printf(",");
        }

        printf(")");
    }

    // Handle prefix operators
    else if(e->kind == EXPR_NEG) {
        printf("-");
        expr_print(e->left);
    } else if(e->kind == EXPR_NOT) {
        printf("!");
        expr_print(e->left);
    } else if(e->kind == EXPR_LEN) {
        printf("#");
        expr_print(e->left);
    } else {
        // Handle infix operators
        expr_print(e->left);

        switch(e->kind) {
            case EXPR_ASSIGN:
                printf(" = ");
                break;
            case EXPR_OR:
                printf(" || ");
                break;
            case EXPR_AND:
                printf(" && ");
                break;
            case EXPR_LT:
                printf(" < ");
                break;
            case EXPR_LE:
                printf(" <= ");
                break;
            case EXPR_GT:
                printf(" > ");
                break;
            case EXPR_GE:
                printf(" >= ");
                break;
            case EXPR_EQ:
                printf(" == ");
                break;
            case EXPR_NEQ:
                printf(" != ");
                break;
            case EXPR_ADD:
                printf(" + ");
                break;
            case EXPR_SUB:
                printf(" - ");
                break;
            case EXPR_MUL:
                printf(" * ");
                break;
            case EXPR_DIV:
                printf(" / ");
                break;
            case EXPR_MOD:
                printf(" % ");
                break;
            case EXPR_EXP:
                printf(" ^ ");
                break;
            case EXPR_INC:
                printf("++");
                break;
            case EXPR_DEC:
                printf("--");
                break;
            case EXPR_NAME:
                printf("%s", e->name);
                break;
            case EXPR_INTEGER_LITERAL:
                printf("%d", e->literal_value);
                break;
            case EXPR_BOOLEAN_LITERAL:
                printf("%s", e->literal_value ? "true" : "false");
                break;
            case EXPR_CHAR_LITERAL:
                printf("%c", e->literal_value);
                break;
            case EXPR_STRING_LITERAL:
                printf("%s", e->string_literal);
                break;
        }

        expr_print(e->right);
    }
}
