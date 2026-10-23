#define TOKS(x, s, ls)  \
    x(EOF) s \
    x(ARRAY) s \
    x(AUTO) s \
    x(BOOLEAN_TYPE) s \
    x(CHAR_TYPE) s \
    x(DOUBLE_TYPE) s \
    x(ELSE) s \
    x(FALSE) s \
    x(FLOAT_TYPE) s \
    x(FOR) s \
    x(FUNCTION) s \
    x(IF) s \
    x(INTEGER_TYPE) s \
    x(PRINT) s \
    x(RETURN) s \
    x(STRING_TYPE) s \
    x(TRUE) s \
    x(VOID) s \
    x(WHILE) s \
    x(CHAR_LITERAL) s \
    x(STRING_LITERAL) s \
    x(INTEGER_LITERAL) s \
    x(DOUBLE_LITERAL) s \
    x(PLUS) s \
    x(MINUS) s \
    x(NOT) s \
    x(INCREMENT) s \
    x(DECREMENT) s \
    x(IDENT) s \
    x(EXPONENT) s \
    x(MUL) s \
    x(DIV) s \
    x(MODULO) s \
    x(LESS) s \
    x(LESS_EQUAL) s \
    x(GREATER) s \
    x(GREATER_EQUAL) s \
    x(EQUAL) s \
    x(NOT_EQUAL) s \
    x(AND) s \
    x(OR) s \
    x(ASSIGN) s \
    x(COLON) s \
    x(SEMICOLON) s \
    x(COMMA) s \
    x(LPAREN) s \
    x(RPAREN) s \
    x(L_SQ_BRACKET) s \
    x(R_SQ_BRACKET) s \
    x(LBRACE) s \
    x(RBRACE) s \
    x(CARRAY) s \
    x(HASH) s \
    x(ERROR) ls

#define tx(s) TOKEN_##s
#define ts ,
typedef enum { TOKS(tx, ts,) } token_t;
#undef tx
#undef ts
