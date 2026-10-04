CC     = gcc
CFLAGS = -Wall -Wextra -g -fsanitize=address -Wno-implicit-fallthrough -Wno-unused-function -Wno-implicit-function-declaration

OBJS   = main.o lex.yy.o hash_table.o library.o

all: compiler

compiler: $(OBJS)
	$(CC) $(CFLAGS) -o compiler $(OBJS)

main.o: main.c token.h
	$(CC) $(CFLAGS) -c main.c

lex.yy.o: lex.yy.c token.h
	$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c: scanner.flex
	flex scanner.flex

hash_table.o: hash_table.c hash_table.h
	$(CC) $(CFLAGS) -c hash_table.c

library.o: library.c
	$(CC) $(CFLAGS) -c library.c

run: compiler
	./compiler

make_then_run: run

test_scanner: compiler
	cd tests/scanner && ./run_all_tests.sh ../../compiler true

clean:
	rm -f $(OBJS) compiler lex.yy.c
	find tests/scanner -type f -name "*.out" -delete

.PHONY: all run make_then_run test_scanner clean
