#include <stdio.h>
#include <stdlib.h>

#include "stmt.h"
#include "helpers.h"

struct stmt* stmt_create(stmt_t kind, struct decl* decl, struct expr* init_expr,
						 struct expr* expr, struct expr* next_expr,
						 struct stmt* body, struct stmt* else_body,
						 struct stmt* next) {
	struct stmt* s = malloc(sizeof(struct stmt));
	if (!s) {
		printf("Error: failed to allocate memory for stmt\n");
		exit(1);
	}
	s->kind = kind;
	s->decl = decl;
	s->init_expr = init_expr;
	s->expr = expr;
	s->next_expr = next_expr;
	s->body = body;
	s->else_body = else_body;
	s->next = next;
	return s;
}

void print_if_and_for_body(struct stmt* body, int level) {
	if (body && body->kind == STMT_BLOCK) {
		// Gets rid of the curly braces since we already printed them before
		// calling this function
		stmt_print(body->body, level);
	} else {
		stmt_print(body, level);
	}
}

void stmt_print(struct stmt* s, int level) {
	if (!s) return;
	indent(level);
	switch (s->kind) {
		case STMT_EXPR:
			expr_print(s->expr, 0);
			printf(";\n");
			break;
		case STMT_DECL:
			decl_print(s->decl, 0);	 // handles its own semicolon and newline
			break;
		case STMT_IF:
			printf("if (");
			expr_print(s->expr, 0);
			printf(") {\n");
			print_if_and_for_body(s->body, level + 1);
			indent(level);
			printf("}\n");
			break;
		case STMT_IF_ELSE:
			printf("if (");
			expr_print(s->expr, 0);
			printf(") {\n");
			print_if_and_for_body(s->body, level + 1);
			indent(level);
			printf("}");
			if (s->else_body) {
				printf(" else {\n");
				print_if_and_for_body(s->else_body, level + 1);
				indent(level);
				printf("}");
			}
			printf("\n");
			break;
		case STMT_FOR:
			// "for (i = 0; i < 10; i++)", and "for (;;)" when all parts are empty
			printf("for (");
			if (s->init_expr) expr_print(s->init_expr, 0);
			printf(";");
			if (s->expr) {
				printf(" ");
				expr_print(s->expr, 0);
			}
			printf(";");
			if (s->next_expr) {
				printf(" ");
				expr_print(s->next_expr, 0);
			}
			printf(") {\n");
			print_if_and_for_body(s->body, level + 1);
			indent(level);
			printf("}\n");
			break;
		case STMT_PRINT:
			printf("print");
			if (s->expr) {
				printf(" ");
				expr_print(s->expr, 0);
			}
			printf(";\n");
			break;
		case STMT_RETURN:
			printf("return");
			if (s->expr) {
				printf(" ");
				expr_print(s->expr, 0);
			}
			printf(";\n");
			break;
		case STMT_BLOCK:
			printf("{\n");
			stmt_print(s->body, level + 1);
			indent(level);
			printf("}\n");
			break;
	}
	stmt_print(s->next, level);
}