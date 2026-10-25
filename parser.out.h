/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_OUT_H_INCLUDED
# define YY_YY_PARSER_OUT_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    TOKEN_EOF = 0,                 /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOKEN_ERROR = 258,             /* "lexical error"  */
    TOKEN_IDENT = 259,             /* "identifier"  */
    TOKEN_INTEGER_LITERAL = 260,   /* "integer literal"  */
    TOKEN_DOUBLE_LITERAL = 261,    /* "double literal"  */
    TOKEN_CHAR_LITERAL = 262,      /* "character literal"  */
    TOKEN_STRING_LITERAL = 263,    /* "string literal"  */
    TOKEN_ARRAY = 264,             /* "array"  */
    TOKEN_CARRAY = 265,            /* "carray"  */
    TOKEN_AUTO = 266,              /* "auto"  */
    TOKEN_BOOLEAN_TYPE = 267,      /* "boolean"  */
    TOKEN_CHAR_TYPE = 268,         /* "char"  */
    TOKEN_DOUBLE_TYPE = 269,       /* "double"  */
    TOKEN_INTEGER_TYPE = 270,      /* "integer"  */
    TOKEN_STRING_TYPE = 271,       /* "string"  */
    TOKEN_VOID = 272,              /* "void"  */
    TOKEN_FUNCTION = 273,          /* "function"  */
    TOKEN_IF = 274,                /* "if"  */
    TOKEN_ELSE = 275,              /* "else"  */
    TOKEN_FOR = 276,               /* "for"  */
    TOKEN_PRINT = 277,             /* "print"  */
    TOKEN_RETURN = 278,            /* "return"  */
    TOKEN_TRUE = 279,              /* "true"  */
    TOKEN_FALSE = 280,             /* "false"  */
    TOKEN_FLOAT_TYPE = 281,        /* "float"  */
    TOKEN_WHILE = 282,             /* "while"  */
    TOKEN_INCREMENT = 283,         /* "++"  */
    TOKEN_DECREMENT = 284,         /* "--"  */
    TOKEN_LESS_EQUAL = 285,        /* "<="  */
    TOKEN_GREATER_EQUAL = 286,     /* ">="  */
    TOKEN_EQUAL = 287,             /* "=="  */
    TOKEN_NOT_EQUAL = 288,         /* "!="  */
    TOKEN_AND = 289,               /* "&&"  */
    TOKEN_OR = 290,                /* "||"  */
    TOKEN_COLON = 291,             /* ":"  */
    TOKEN_SEMICOLON = 292,         /* ";"  */
    TOKEN_COMMA = 293,             /* ","  */
    TOKEN_ASSIGN = 294,            /* "="  */
    TOKEN_LBRACE = 295,            /* "{"  */
    TOKEN_RBRACE = 296,            /* "}"  */
    TOKEN_L_SQ_BRACKET = 297,      /* "["  */
    TOKEN_R_SQ_BRACKET = 298,      /* "]"  */
    TOKEN_LPAREN = 299,            /* "("  */
    TOKEN_RPAREN = 300,            /* ")"  */
    TOKEN_PLUS = 301,              /* "+"  */
    TOKEN_MINUS = 302,             /* "-"  */
    TOKEN_MUL = 303,               /* "*"  */
    TOKEN_EXPONENT = 304,          /* "^"  */
    TOKEN_DIV = 305,               /* "/"  */
    TOKEN_MODULO = 306,            /* "%"  */
    TOKEN_GREATER = 307,           /* ">"  */
    TOKEN_LESS = 308,              /* "<"  */
    TOKEN_NOT = 309,               /* "!"  */
    TOKEN_HASH = 310               /* "#"  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_OUT_H_INCLUDED  */
