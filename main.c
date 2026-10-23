#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "parser.out.h"

extern FILE *yyin;
extern char *yytext;
extern int yylineno;
int yylex(void);
extern const char *const token_names[];

int main(int argc, char* argv[]) {
    if (argc < 3) {
        fprintf(stderr,
            "Usage:\n"
                "\t%s --scan BMINOR_SOURCE_FILE\n"
                "\t%s --parse BMINOR_SOURCE_FILE\n"
        , argv[0], argv[0]);
        return 1;
    }
    #define file_name argv[2]

    yyin = fopen(file_name, "r");
    if (yyin == NULL) {
        perror(file_name);
        return 1;
    }

    int had_error = 0;

    if (strcmp(argv[1], "--scan") == 0) {
        for (;;) {
            const int token = yylex();
            if (token == TOKEN_EOF) break;
            if (token == TOKEN_ERROR) {
                fprintf(stderr, "scan error: unrecognized token:`%s`, line:%d\n", yytext, yylineno);
                had_error = 1;
                continue;
            }
            fprintf(stderr, "token:'%s', text:`%s`, line:%d\n", token_names[token], yytext, yylineno);
        }
    }

    if (strcmp(argv[1], "--parse") == 0) {
        had_error = yyparse() != 0;

        if (fclose(yyin) == EOF) {
            perror(argv[2]);
            had_error = 1;
        }

        if (!had_error) puts("parse successful");
    }

    return had_error ? 1 : 0;
}
