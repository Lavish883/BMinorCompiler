#!/bin/sh
# set -xe

# Usage: $0 TEST_DIR ERRORS_ONLY BINARY [ARG...]

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 TEST_DIR ERRORS_ONLY BINARY [ARG...]" >&2
    exit 1
fi

testdir=$1
errors_only=$2
binary=$3
shift 3

if [ ! -d "$testdir" ]; then
    echo "Not a directory: $testdir" >&2
    exit 1
fi

for testfile in "$testdir"/good*.bminor
do
    [ -f "$testfile" ] || continue

    if "$binary" "$@" "$testfile" > "$testfile.out"; then
        if [ "$errors_only" != "true" ]; then
            echo "$testfile success (as expected)"
        fi
    else
        echo "$testfile failure (INCORRECT)"
    fi
done

for testfile in "$testdir"/bad*.bminor
do
    [ -f "$testfile" ] || continue

    if "$binary" "$@" "$testfile" > "$testfile.out"; then
        echo "$testfile success (INCORRECT)"
    else
        if [ "$errors_only" != "true" ]; then
            echo "$testfile failure (as expected)"
        fi
    fi
done
