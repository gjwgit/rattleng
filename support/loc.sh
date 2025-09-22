#!/bin/bash
#
# Graham Williams 20250910
#
# Count the number of lines of code in a file
#
# Check if exactly one argument is provided.

if [ "$#" -ne 1 ]; then
    echo "Counts lines of code in a file"
    echo "Usage: $0 <filename.dart>"
    exit 1
fi

FILE="$1"

# Check if the file exists

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' does not exist."
    exit 1
fi

# Check if the file has .dart extension (case-insensitive).

FILE_LOWER=$(echo "$FILE" | tr '[:upper:]' '[:lower:]')
if [[ "$FILE_LOWER" != *.dart ]]; then
    echo "Error: File '$FILE' is not a dart file."
    exit 1
fi

cat "${FILE}" |
    grep -v "^\s*$" |
    grep -v "^\s*//" |
    sed "/\/\*/,/\*\//d" |
    sed "/'''/,/'''/d" |
    sed '/^[[:space:]]*[})]*[,;]*$/d' |
    grep -v '^ *], *$' |
    wc -l
