#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include <getopt.h>

#include "token.h"

extern FILE* yyin;
extern int yylex();
extern char* yytext;

int main(int argc, char* argv[]) {
	// Get all the flags for the program
	int opt;
	bool scan_info_flag = false;  // Means output scan info
    char* file_name = NULL;

	while ((opt = getopt(argc, argv, "sf:")) != -1) {
		switch (opt) {
			case 's': {
				scan_info_flag = true;
				break;
			}
            case 'f': {
                file_name = optarg;
                break;
            }
		}
	}

    if (file_name == NULL) {
        printf("Make sure to specify a file by using -f FILE_NAME\n");
        return -1;
    }

    yyin = fopen(file_name, "r");
	if (yyin == NULL) {
		printf("Could not open file named: %s!\n", file_name);
		return 1;
	}

	while (1) {
		token_t t = yylex();
		if (t == TOKEN_EOF) break;
		if (scan_info_flag) {
			printf("token: %d text: %s\n", t, yytext);
		}
	}
}