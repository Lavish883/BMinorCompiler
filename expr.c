#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "expr.h"

struct expr* expr_create(expr_t kind, struct expr* left, struct expr* right) {
    struct expr* e = malloc(sizeof(struct expr));
    if (!e) {
        printf("Error: failed to allocate memory for expr\n");
        exit(1);
    }
    e->kind = kind;
    e->left = left;
    e->right = right;
    e->name = NULL;
    e->literal_value = 0;
    e->double_literal = 0.0;
    e->lexeme = NULL;
    e->string_literal = NULL;
    e->symbol = NULL;
    e->next = NULL;
    return e;
}
struct expr* expr_create_array_init(struct expr* elements) {
    struct expr* e = expr_create(EXPR_ARRAY_INIT, NULL, NULL);
    e->next = elements;
    return e;
}

struct expr* expr_create_array_item(struct expr* element, struct expr* next) {
    struct expr* e = expr_create(EXPR_ARRAY_ITEM, element, NULL);
    e->next = next;
    return e;
}

struct expr* expr_create_name(const char* n) {
    struct expr* e = expr_create(EXPR_NAME, NULL, NULL);
    e->name = n;
    return e;
}

struct expr* expr_create_integer_literal(long long c) {
    struct expr* e = expr_create(EXPR_INTEGER_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_double_literal(double c, const char* text) {
    struct expr* e = expr_create(EXPR_DOUBLE_LITERAL, NULL, NULL);
    e->double_literal = c;
    e->lexeme = text;
    return e;
}

struct expr* expr_create_boolean_literal(int c) {
    struct expr* e = expr_create(EXPR_BOOLEAN_LITERAL, NULL, NULL);
    e->literal_value = c;
    return e;
}

struct expr* expr_create_char_literal(char c) {
    struct expr* e = expr_create(EXPR_CHAR_LITERAL, NULL, NULL);
    e->literal_value = (unsigned char)c;  // 0..255 whether char is signed or not
    return e;
}

struct expr* expr_create_string_literal(const char* str) {
    struct expr* e = expr_create(EXPR_STRING_LITERAL, NULL, NULL);
    e->string_literal = str;
    return e;
}

// Used for simplifying code where an expr is just expr_left SOME_STRING expr_right
char* binary_operators_string[] = {
    "+",
    "-",
    "=",
    "||",
    "&&",
    "<",
    "<=",
    ">",
    ">=",
    "==",
    "!=",
    "*",
    "/",
    "%",
    "^"};

// The space for "- -x" != "--x" 
char* unary_operators_string[] = {
    "+ ",
    "- ",
    "!",
    "#"};

static void expr_print_char_literal(unsigned char c) {
    switch (c) {
        case 7: printf("'\\a'"); return;
        case 8: printf("'\\b'"); return;
        case 27: printf("'\\e'"); return;
        case 12: printf("'\\f'"); return;
        case 10: printf("'\\n'"); return;
        case 13: printf("'\\r'"); return;
        case 9: printf("'\\t'"); return;
        case 11: printf("'\\v'"); return;
        case '\\': printf("'\\\\'"); return;
        case '\'': printf("'\\''"); return;
        default: break;
    }
    if (c >= 32 && c < 127) printf("'%c'", c);
    else printf("'\\0x%02x'", c);
}

static void expr_print_double_literal(const char* s) {
    while (s[0] == '0' && isdigit((unsigned char)s[1])) s++;
    while (isdigit((unsigned char)*s)) putchar(*s++);
    if (*s == '.') {
        const char* frac = ++s;
        while (isdigit((unsigned char)*s)) s++;
        const char* end = s;
        while (end > frac + 1 && end[-1] == '0') end--;
        printf(".%.*s", (int)(end - frac), frac);
    }
    if (*s == 'e' || *s == 'E') {
        s++;
        int negative = *s == '-';
        if (*s == '-' || *s == '+') s++;
        while (s[0] == '0' && isdigit((unsigned char)s[1])) s++;
        printf("e%s%s", negative && *s != '0' ? "-" : "", s);
    }
}

void expr_print(struct expr* e, int indent) {
    if (!e) return;
    switch (e->kind) {
        case (EXPR_ARRAY_INIT): {
            printf("{ ");
            expr_print(e->next, indent);
            printf(" }");
            break;
        }
        case (EXPR_ARRAY_ITEM): {
            expr_print(e->left, indent);
            if (e->next) {
                printf(", ");
                expr_print(e->next, indent);
            }
            break;
        }
        case (EXPR_CALL): {
            expr_print(e->left, indent);
            printf("(");
            expr_print(e->right, indent);
            printf(")");
            break;
        }
        case (EXPR_ARG): {
            expr_print(e->left, indent);
            if (e->right) {
                printf(", ");
                expr_print(e->right, indent);
            }
            break;
        }
        case (EXPR_NAME): {
            printf("%s", e->name);
            break;
        }
        case (EXPR_ARRAY_ACCESS): {
            expr_print(e->left, indent);
            printf("[");
            expr_print(e->right, indent);
            printf("]");
            break;
        }
        case (EXPR_POST_INC): {
            expr_print(e->left, indent);
            printf("++");
            break;
        }
        case (EXPR_POST_DEC): {
            expr_print(e->left, indent);
            printf("--");
            break;
        }
        case (EXPR_CHAR_LITERAL): {
            expr_print_char_literal((unsigned char) e->literal_value);
            break;
        }
        case (EXPR_INTEGER_LITERAL): {
            printf("%lld", e->literal_value);
            break;
        }
        case (EXPR_DOUBLE_LITERAL): {
            expr_print_double_literal(e->lexeme);
            break;
        }
        case (EXPR_BOOLEAN_LITERAL): {
            printf("%s", e->literal_value ? "true" : "false");
            break;
        }
        case (EXPR_STRING_LITERAL): {
            printf("%s", e->string_literal);
            break;
        }
        case (EXPR_GROUP): {
            printf("(");
            expr_print(e->left, indent);
            printf(")");
            break;
        }
        // assume binary operator or unary operator
        default: {
            if (e->left != NULL && e->right != NULL) {
                expr_print(e->left, indent);
                printf(" %s ", binary_operators_string[e->kind]);
                expr_print(e->right, indent);
                break;
            }
            printf("%s", unary_operators_string[e->kind - EXPR_POSITIVE]);
            expr_print(e->left, indent);
            break;
        }
    }
    // printf(" %d \n", e->kind);
}