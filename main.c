#include <stdio.h>
#include "token.h"

extern FILE *yyin;
extern int yylex();
extern char *yytext;

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        printf("Please pass a file as an argument");
        return -1;
    }
    if (!yyin)
    {
        printf("Could not open file named: %s!\n", argv[1]);
        return 1;
    }
    while (1)
    {
        token_t t = yylex();
        if (t == TOKEN_EOF)
            break;
        printf("token: %d text: %s\n", t, yytext);
    }
}