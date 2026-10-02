typedef enum {
    TOKEN_EOF = 0,

    
    /* Keywords */
    TOKEN_ARRAY,
    TOKEN_AUTO,
    TOKEN_BOOLEAN_TYPE,
    TOKEN_CHAR_TYPE,
    TOKEN_ELSE,
    TOKEN_FALSE,
    TOKEN_FOR,
    TOKEN_FUNCTION,
    TOKEN_IF,
    TOKEN_INTEGER_TYPE,
    TOKEN_PRINT,
    TOKEN_RETURN,
    TOKEN_STRING_TYPE,
    TOKEN_TRUE,
    TOKEN_VOID,
    TOKEN_WHILE,

    /* Literals */
    TOKEN_CHAR_LITERAL,
    TOKEN_STRING_LITERAL,

    /* Operators */
    TOKEN_PLUS,
    TOKEN_MINUS,
    TOKEN_NOT,
    TOKEN_INCREMENT,
    TOKEN_DECREMENT,

    /* Identifiers */
    TOKEN_IDENT,

    /* Operators (continued) */
    TOKEN_EXPONENT,
    TOKEN_MUL,
    TOKEN_DIV,
    TOKEN_MODULO,
    TOKEN_LESS,
    TOKEN_LESS_EQUAL,
    TOKEN_GREATER,
    TOKEN_GREATER_EQUAL,
    TOKEN_EQUAL,
    TOKEN_NOT_EQUAL,
    TOKEN_AND,
    TOKEN_OR,
    TOKEN_ASSIGN,

    /* Literals (continued) */
    TOKEN_DECIMAL,

    /* Punctuation */
    TOKEN_COLON,
    TOKEN_SEMICOLON,
    TOKEN_COMMA,
    TOKEN_LPAREN,
    TOKEN_RPAREN,
    TOKEN_L_SQ_BRACKET,
    TOKEN_R_SQ_BRACKET,
    TOKEN_LBRACE,
    TOKEN_RBRACE,

    /* Remaining Keywords */
    TOKEN_CARRAY,
    TOKEN_DOUBLE_TYPE,
    TOKEN_FLOAT_TYPE,

    /* Remaining Literals */
    TOKEN_HEXADECIMAL,
    TOKEN_BINARY,

    /* Remaining Operators */
    TOKEN_HASH,

    /* Errors */
    TOKEN_ERROR
} token_t;