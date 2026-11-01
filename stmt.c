#include <stdio.h>
#include <stdlib.h>
#include "stmt.h"

struct stmt * stmt_create( stmt_t kind, struct decl *decl,
                           struct expr *init_expr, struct expr *expr,
                           struct expr *next_expr, struct stmt *body,
                           struct stmt *else_body, struct stmt *next )
{
    struct stmt* stmt = malloc(sizeof(struct stmt));
    if(!stmt)
        return NULL;

    stmt->kind      = kind;
    stmt->decl      = decl;
    stmt->init_expr = init_expr;
    stmt->expr      = expr;
    stmt->next_expr = expr;
    stmt->body      = body;
    stmt->else_body = else_body;
    stmt->next      = next;

    return stmt;
}

void stmt_print( struct stmt *s, int level ) {
    if (!s) return;

    switch (s->kind)
    {
        case STMT_EXPR:
            expr_print(s->expr, level);
            printf(";\n");
            break;
        case STMT_DECL:
            decl_print(s->expr, level);
            printf(";\n");
            break;
        case STMT_IF_ELSE:
            printf("if (");
            expr_print(s->expr, level);
            printf(" ) ");
            stmt_print(s->body, level + 1);
            if (s->else_body) {
                printf("else ");
                stmt_print(s->else_body, level + 1);
            }
            break;
        case STMT_FOR:
            printf("for (");
            if (s->init_expr) {
                expr_print(s->init_expr);
                printf(";");
            }
            if (s->expr) {
                expr_print(s->expr);
                printf(";");
            }
            if (s->next_expr) {
                expr_print(s->next_expr);
            }
            printf(") ");
            stmt_print(s->body, level + 1);
            break;
        case STMT_PRINT:
            printf("print ");
            expr_print(s->expr, level);
            printf(";\n");
            break;
        case STMT_RETURN:
            printf("return ");
            expr_print(s->expr, level);
            printf(";\n");
            break;
        case STMT_BLOCK:
            printf("{\n");
            while (s) {
                stmt_print(s, level);
                s = s->next;
            }
            printf("\n}\n");
            break;
    }
}
