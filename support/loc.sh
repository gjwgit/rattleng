#!/bin/bash
#
# Graham Williams 20250910
#
# Count the number of lines of code in a file
#
# Check if exactly one argument is provided.

IGNORE=false # Return an error if any files have more than N loc.
MAX=300 # Value of N loc.
FUZZ=310 # Return error if >FUZZ.
CONCATE=false # Whether to simply count all lines across all files.
CLEAN=false

# Function to display help

show_help() {
    echo "Usage: $0 [options] <files>"
    echo ""
    echo "Options:"
    echo "  -c, --clean            Just filter the file to remove lines not counted."
    echo "  -i, --ignore           Ignore errors related to the line count threshold."
    echo "  -t, --total            Concatenate all supplied files and count total lines after cleansing."
    echo "  -n, --max-lines <n>    Set the maximum number of allowed lines (default: ${MAX})."
    echo "  -f, --fuzz-lines <n>   Set the maximum number of allowed lines before error (default: ${FUZZ})."
    echo "  -h, --help             Show this help message."
    exit 0
}

# Function to cleanse lines.

cleanse_lines() {
    sed '1d' "$1" |
	grep -v '^$' | # Remove empty lines
	grep -v '^[[:space:]]*//' | # Remove comment only lines
	grep -v '^\(import\|library\)' | # Remove library and import statements
	grep -v '^\s*@' | # Remove directives
	grep -v '^\s*[\}\)]' | # Remove linest that start with a bracket
	grep -v '^\s*\]' | # Needed this as special case
	grep -v '^\s*(\?|:) \[' | # Remove lines that consist of '? [' or  ': ['
	grep -v '\s*\w*: \[' | # Remove  parameter list lines like `   names: [`
	grep -v "^\s*['][^']*[']" | # Remove lines that are only a string.
	grep -v "^\s*\w*:\s*$" | # Remove lines that are only a parameter name.
	cat
}

wc_cleanse_lines() {
    cleanse_lines "$1" | wc -l
}



# Check for no arguments.

if [ "$#" -eq 0 ]; then
    show_help
fi

# Parse input arguments.

while [[ "$1" != "" ]]; do
    case $1 in
	-c | --clean)
	    CLEAN=true
	    shift
	    ;;
        -i | --ignore)
            IGNORE=true
            shift
            ;;
        -t | --total)
            CONCATE=true
            shift
            ;;
        -n | --max-lines)
            shift
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                MAX=$1
                shift
            fi
            ;;
        -f | --fuzz-lines)
            shift
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                FUZZ=$1
                shift
            fi
            ;;
        -h | --help)
            show_help
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

# 20260324 gjw Ignore files listed in .locignore

# Read .locignore patterns into an array

if [ -e .locignore ]; then
    declare -a IGNORE_PATTERNS
    while IFS= read -r pattern; do
	[[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
	IGNORE_PATTERNS+=("$pattern")
    done < .locignore

    # Handle last line if it doesn't end with a newline

    if [[ -n "$pattern" && "$pattern" != \#* ]]; then
	IGNORE_PATTERNS+=("$pattern")
    fi

fi

# Filter FILES array

declare -a FILTERED_FILES
for file in "${FILES[@]}"; do
    should_ignore=0
    for pattern in "${IGNORE_PATTERNS[@]}"; do
        if [[ "$file" == *"$pattern"* ]]; then
            should_ignore=1
            break
        fi
    done
    [[ $should_ignore -eq 0 ]] && FILTERED_FILES+=("$file")
done

FILES=("${FILTERED_FILES[@]}")

if [ "$CLEAN" = true ]; then
    for file in "${FILES[@]}"; do
        cleanse_lines "$file"
    done
    exit 0
fi

if [ "$CONCATE" = true ]; then
    # Concatenate all files and get total line count after cleansing then exit
    TOTAL_LINES=0
    for file in "${FILES[@]}"; do
        LINES=$(wc_cleanse_lines "$file")
        TOTAL_LINES=$((TOTAL_LINES + LINES))
    done
    echo "$TOTAL_LINES"
    exit 0
fi

# Check individual files for line count.

ERROR=false

if (( MAX > 0 )); then
    for file in "${FILES[@]}"; do
        LINES=$(wc_cleanse_lines "$file")
        if (( LINES > MAX )); then
            printf "%4d %s\n" "$LINES" "$file"
            if (( LINES > FUZZ )); then
		ERROR=true
	    fi
        fi
    done
else
    for file in "${FILES[@]}"; do
        LINES=$(wc_cleanse_lines "$file")
        printf "%4d %s\n" "$LINES" "$file"
    done
fi

# Set exit status based on error occurrence
if [ "$ERROR" = true ]; then
    if [ "$IGNORE" = true ]; then
        exit 0
    else
        exit 1
    fi
fi

exit 0
