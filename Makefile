
### assignment number
ASSIGN = 2

### strict flags for develompent and testing
# CC       = gcc -std=c17 -Wall -Wextra -Weverything -Wno-unsafe-buffer-usage -Wno-unused-macros -Wno-pre-c11-compat -Wno-declaration-after-statement -Wno-unused-const-variable -pedantic -Wc11-extensions -fno-gnu89-inline

### NOTE: use this for submission (we want most compliance from grader's compiler)
CC      = gcc

ARTIFACT = bminor

# BSD/MacOS compat
FLEX = flex
BISON = bison

### NOTE: keep artifact the first recipe
$(ARTIFACT): scanner.out.o parser.out.o main.o
	$(CC) $^ -o $@ -lm

### out recipes
scanner.out.c: scanner.flex parser.out.h
	$(FLEX) -o $@ $<

scanner.out.o main.o: parser.out.h

parser.out.o: parser.out.c parser.out.h

%.out.c %.out.h: %.bison
	$(BISON) -d -o $*.out.c $<

%.o: %.c
	$(CC) -c $< -o $@

### phony recipes
.PHONY: zip FORCE_PHONY
FORCE_PHONY: # turn phony into a dependency

### NOTE: change this to match the current assignment
test: test_parse FORCE_PHONY

### NOTE: auto generate all tests like "test_scanner", "test_parser", etc
test_%: tests/% $(ARTIFACT) FORCE_PHONY
	@ find tests -type f \( -name '*.out' \) -delete
	@ sh tests/run_all_tests.sh $< false ./$(ARTIFACT) --$*

clean: FORCE_PHONY
	find . -type f \( -name '*.out.*' -o -name '*.out' -o -name '*.o' -o -name '$(ARTIFACT)' \) -delete -print
	rm -r $(ZIPNAME) $(ZIPNAME).zip || true

rebuild: FORCE_PHONY
	$(MAKE) clean
	$(MAKE)

ZIPNAME = Group1_CC_A$(ASSIGN)
zip: Makefile main.c scanner.flex parser.bison tests README.md
	rm -r $(ZIPNAME) $(ZIPNAME).zip || true
	mkdir $(ZIPNAME)
	cp -r $^ $(ZIPNAME)
	zip -r $(ZIPNAME).zip $(ZIPNAME)
