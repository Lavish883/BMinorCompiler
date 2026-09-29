CC = gcc
CFLAGS = -Wall -Wextra -std=c2x -g -fsanitize=address -Wno-implicit-fallthrough -Wno-unused-function -Wno-implicit-function-declaration

TARGET = compiler

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
	qemu-riscv64-static ./$(TARGET) # should not be used for grading purposes
clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all make_then_run clean run