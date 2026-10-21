#include <getopt.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

#include "token.h"

#define tx(s) #s
#define ts ,
static const char *token_names[] = {TOKS(tx, ts, )};
#undef tx
#undef ts

extern FILE *yyin;
extern int yylex();
extern char *yytext;
extern int yylineno;

bool had_error;

void scan() {
    printf("Beginning scanning");
    while (1) {
        token_t t = yylex();
        if (t == TOKEN_EOF)
            break;
        if (t == TOKEN_ERROR) {
            printf("[ERROR] Unrecognized token: %s, Line Number: %d\n", yytext,
                   yylineno);
            had_error = true;
            continue;
        }
        printf("Token: %s, Text: %s, Line Number: %d\n", token_names[t], yytext,
               yylineno);
    }
}

void parse() {}

int main(int argc, char *argv[]) {
    // Get all the flags for the program
    int opt;
    int scan_flag = 0;  // Means behave just as a scanner (assignment #1)
    int parse_flag = 0; // Means behave just as a parser (assignment #2)

    char *file_name = NULL;

    struct option arg_options[] = {
        {.name = "scan", .has_arg = 0, .flag = &scan_flag, .val = true},
        {.name = "parse", .has_arg = 0, .flag = &parse_flag, .val = true},
        {0, 0, 0, 0}};

    while ((opt = getopt_long(argc, argv, "sp", arg_options, NULL)) != -1) {
        switch (opt) {
        case 0: {
            break;
        }
        case 's': {
            scan_flag = 1;
            break;
        }
        case 'p': {
            parse_flag = 1;
            break;
        }
        }
    }

    // printf("s:%d p:%d", scan_flag, parse_flag);
    if (optind < argc) {
        file_name = argv[optind];
    }
    if (file_name == NULL) {
        printf("Make sure to specify a file as argument\n");
        return -1;
    }

    yyin = fopen(file_name, "r");
    if (yyin == NULL) {
        printf("Could not open file named: %s!\n", file_name);
        return 1;
    }
    printf("======[STARTING TESTS AT %s]======\n\n", file_name);

    bool had_error = false;

    if (scan_flag) {
        if (parse_flag) {
            printf("Passed both scan flag and parse flag, undefined behavior");
            return 1;
        }
        printf("Running in scan mode.");
        scan();
    }
    if (parse_flag) {
        parse();
    } else {
        printf("[ERROR] No flags passed, exiting. Please pass a scan or parse "
               "flag.");
    }

    printf("\n======[FINISHED TESTS AT %s]======\n", file_name);
    return had_error ? 1 : 0;
}
