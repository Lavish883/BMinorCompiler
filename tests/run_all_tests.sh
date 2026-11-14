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

failed=0

# --print round trip: the printed program $2 must parse and print identically.
reprint_ok() {
    reprint="${2%.out}.reprint.out"
    if ! "$binary" --print "$2" > "$reprint" 2>&1; then
        printf '\033[31m[!!] %s\t printed output does not reparse (INCORRECT)\033[0m\n' "$1"
    elif ! cmp -s "$2" "$reprint"; then
        printf '\033[31m[!!] %s\t reprinted output differs (INCORRECT)\033[0m\n' "$1"
    else
        return 0
    fi
    return 1
}

for testfile in "$testdir"/bad*.bminor
do
    [ -f "$testfile" ] || continue

    if "$binary" "$@" "$testfile" > "$testfile.out" 2>&1; then
        printf '\033[31m[!!] %s\t success (INCORRECT)\033[0m\n' "$testfile"
        failed=1
    # a failure must report itself as "scan error: ...", "parse error: ...", etc
    elif ! grep -Eq '^[a-z]+ error:' "$testfile.out"; then
        printf '\033[31m[!!] %s\t failure without an "... error:" message (INCORRECT)\033[0m\n' "$testfile"
        failed=1
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
        if [ "$1" = "--print" ] && ! reprint_ok "$testfile" "$testfile.out"; then
            failed=1
        elif [ "$errors_only" != "true" ]; then
            printf '\033[32m[OK]\033[0m %s\t success (as expected)\n' "$testfile"
        fi
    else
        printf '\033[31m[!!] %s\t failure (INCORRECT)\033[0m\n' "$testfile"
        failed=1
    fi
done

# --print: every file of the sibling suites that parses (good or bad) must round trip too
if [ "$1" = "--print" ]; then
    for testfile in "$(dirname "$testdir")"/*/*.bminor
    do
        [ "$(dirname "$testfile")" = "$testdir" ] && continue
        "$binary" --print "$testfile" > "$testfile.print.out" 2>&1 || continue
        if ! reprint_ok "$testfile" "$testfile.print.out"; then
            failed=1
        elif [ "$errors_only" != "true" ]; then
            printf '\033[32m[OK]\033[0m %s\t round trip\n' "$testfile"
        fi
    done
fi

exit "$failed"
