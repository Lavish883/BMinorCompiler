#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "token.h"

#define tx(s) #s
#define ts ,
static const char* token_names[] = { TOKS(tx, ts,) };
#undef tx
#undef ts

extern FILE* yyin;
extern token_t yylex(void);
extern char* yytext;
extern int yylineno;

int main(int argc, char* argv[]) {
    int had_error = 0, scan_show = 0, parse_do = 0;

    //////////////// args begin
    if (argc < 3) {
        had_error = 1;
        fputs("driver error: Bad arguments\n", stdout);
        goto end;
    }

    if (strcmp(argv[1], "--scan") == 0) scan_show = 1;
    if (strcmp(argv[1], "--parse") == 0) parse_do = 1;

    #define file_name argv[2]
    //////////////// args end

    //////////////// scanner begin
    yyin = fopen(file_name, "r");
    if (yyin == NULL) {
        printf("driver error: Could not open file named: `%s`!\n", file_name);
        return 1;
    }
    if (scan_show) printf("======[STARTING TESTS AT `%s`]======\n\n", file_name);
    for (;;) {
        token_t t = yylex();
        if (t == TOKEN_EOF) break;
        if (t == TOKEN_ERROR) {
            printf("scan error: Unrecognized token: `%s`, Line Number: %d\n", yytext, yylineno);
            had_error = 1;
            continue;
        }
        else if (scan_show) printf("Token: %s, Text: `%s`, Line Number: %d\n", token_names[t], yytext, yylineno);
    }
    if (scan_show) printf("\n======[FINISHED TESTS AT `%s`]======\n", file_name);
    //////////////// scanner end


    end:
    return had_error ? 1 : 0;
}
