#!/bin/sh

if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: $0 [compiler_path]"
    exit 1
fi

echo $1

for testfile in good*.bminor
do
	if $1 -f $testfile -s > $testfile.out
	then
		echo "$testfile success (as expected)"
	else
		echo "$testfile failure (INCORRECT)"
	fi
done

for testfile in bad*.bminor
do
	if $1 -f $testfile -s > $testfile.out
	then
		echo "$testfile success (INCORRECT)"
	else
		echo "$testfile failure (as expected)"
	fi
done
