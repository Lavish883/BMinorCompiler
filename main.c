#include <getopt.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

#include "parser.h"

extern FILE *yyin;
extern int yylex();
extern char *yytext;
extern int yylineno;
extern int yyparse();
extern const char* get_token_name(int tok);

bool scan() {
    bool had_error = false;

    printf("Beginning scanning\n");
    while (1) {
        int t = yylex();
        if (t == TOKEN_EOF)
            break;
        if (t == TOKEN_ERROR) {
            printf("[ERROR] Unrecognized token: %s, Line Number: %d\n", yytext,
                   yylineno);
            had_error = true;
            continue;
        }
        printf("Token: %s, Text: %s, Line Number: %d\n", get_token_name(t), yytext,
               yylineno);
    }

    return had_error;
}

bool parse() {
    printf("Beginning parse\n");

    if (yyparse() == 0 ) {
		printf("Parse successful!\n");
		return false;
	}

	printf("Parse failed.\n");
	return true;
}

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
    
    bool had_error;
    
    if (scan_flag && parse_flag) {
        printf("Passed both scan flag and parse flag, undefined behavior\n");
        return 1;
    }
    if (scan_flag) {
        printf("Running in scan mode.\n");
        had_error = scan();
    } else if (parse_flag) {
        had_error = parse();
    } else {
        printf("[ERROR] No flags passed, exiting. Please pass a scan or parse "
               "flag.");
    }

    printf("\n======[FINISHED TESTS AT %s]======\n", file_name);
    return had_error ? 1 : 0;
}
