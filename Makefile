CC     = gcc
CFLAGS = -Wall -Wextra -g -fsanitize=address -Wno-implicit-fallthrough -Wno-unused-function -Wno-implicit-function-declaration

# used in_module_exercise 7 to update the makefile to use bison

bminor: main.o scanner.o parser.o
	$(CC) $(CFLAGS) main.o scanner.o parser.o -o bminor -lm

%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@

scanner.c: scanner.flex parser.h
	flex -oscanner.c scanner.flex

parser.c parser.h: parser.bison
	bison --defines=parser.h --output=parser.c -v parser.bison

test_scanner: bminor
	cd tests/scanner && ./run_all_tests.sh ../../bminor true

clean:
	rm -f parser.[ch] parser.output scanner.c *.o bminor
	find tests/scanner -type f -name "*.out" -delete

.PHONY: all run make_then_run test_scanner clean