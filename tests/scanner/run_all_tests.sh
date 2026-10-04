#!/bin/sh

if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: $0 [compiler_path]"
    exit 1
fi

# $1 compiler path
# $2 true if you only want to show errors 

for testfile in good*.bminor
do
	if $1 -f $testfile -s > $testfile.out
	then
		if [ "$2" != "true" ]; then 
			echo "$testfile success (as expected)"
		fi
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
		if [ "$2" != "true" ]; then 
			echo "$testfile failure (as expected)"
		fi
	fi
done
