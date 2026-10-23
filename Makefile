
### assignment number
ASSIGN = 2

### strict flags for develompent and testing
CC       = gcc -std=c17 -Wall -Wextra -Weverything -Wno-unsafe-buffer-usage -Wno-unused-macros -Wno-pre-c11-compat -Wno-declaration-after-statement -Wno-unused-const-variable -pedantic -Wc11-extensions -fno-gnu89-inline

### NOTE: use this for submission (we want most compliance from grader's compiler)
# CC      = gcc

ARTIFACT = bminor

### NOTE: keep artifact the first recipe
$(ARTIFACT): scanner.out.o main.o
	$(CC) $^ -o bminor -lm

### out recipes
scanner.out.c: scanner.flex token.h
	flex -o $@ $<

%.o: %.c
	$(CC) -c $< -o $@


### phony recipes
.PHONY: clean test scan_test FORCE_PHONY
FORCE_PHONY:

### NOTE: change this to match the current assignment
test: test_scan

### NOTE: auto generate all tests like "test_scanner", "test_parser", etc
test_%: tests/% $(ARTIFACT) FORCE_PHONY
	find tests -type f \( -name '*.out' \) -delete
	sh tests/run_all_tests.sh $< true ./$(ARTIFACT) --$*

clean:
	find . -type f \( -name '*.out.*' -o -name '*.out' -o -name '*.o' -o -name '$(ARTIFACT)' \) -delete -print
	rm -r $(ZIPNAME) || true

rebuild:
	$(MAKE) clean
	$(MAKE)

ZIPNAME = Group1_CC_A$(ASSIGN)
zip: Makefile main.c scanner.flex token.h tests
	rm -r $(ZIPNAME) || true
	mkdir $(ZIPNAME)
	cp -r $^ $(ZIPNAME)
	zip -r $(ZIPNAME).zip $(ZIPNAME)
