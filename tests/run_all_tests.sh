#!/bin/sh
# set -xe

# Usage: $0 TEST_DIR ERRORS_ONLY BINARY [ARG...]

if [ "$#" -lt 3 ]; then
    printf 'Usage: %s TEST_DIR ERRORS_ONLY BINARY [ARG...]\n' "$0" >&2
    exit 1
fi

testdir=$1
errors_only=$2
binary=$3
shift 3

if [ ! -d "$testdir" ]; then
    printf 'Not a directory: %s\n' "$testdir" >&2
    exit 1
fi

for testfile in "$testdir"/bad*.bminor
do
    [ -f "$testfile" ] || continue

    if "$binary" "$@" "$testfile" > "$testfile.out" 2>&1; then
        printf '\033[31m[!!] %s\t success (INCORRECT)\033[0m\n' "$testfile"
    else
        if [ "$errors_only" != "true" ]; then
            printf '\033[32m[OK]\033[0m %s\t failure (as expected)\n' "$testfile"
        fi
    fi
done

for testfile in "$testdir"/good*.bminor
do
    [ -f "$testfile" ] || continue

    if "$binary" "$@" "$testfile" > "$testfile.out" 2>&1; then
        if [ "$errors_only" != "true" ]; then
            printf '\033[32m[OK]\033[0m %s\t success (as expected)\n' "$testfile"
        fi
    else
        printf '\033[31m[!!] %s\t failure (INCORRECT)\033[0m\n' "$testfile"
    fi
done
