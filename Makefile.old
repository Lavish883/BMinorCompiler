CC = gcc
CFLAGS = -Wall -Wextra -std=c2x -g -fsanitize=address -Wno-implicit-fallthrough -Wno-unused-function -Wno-implicit-function-declaration

TARGET = compiler
CDIR = $(shell pwd)

SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
DEPS = $(wildcard *.h)

all: make_scanner_from_flex $(TARGET)

make_scanner_from_flex:
	flex scanner.flex
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

make_then_run: $(TARGET) run

run:
	./$(TARGET)
clean:
	rm -f $(OBJS) $(TARGET) || true
	rm *.yy.* || true
	cd tests/scanner && find . -type f -name "*.out" -delete
test_scanner:
	cd tests/scanner && ./run_all_tests.sh $(CDIR)/$(TARGET) true
.PHONY: all make_then_run clean run test_scanner
