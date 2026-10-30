#include "decl.h"
#include "type.h"
#include "stmt.h"
#include "expr.h"


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
    }
}
