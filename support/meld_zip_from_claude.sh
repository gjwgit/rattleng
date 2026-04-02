#!/bin/bash

# 20260331 gjw When interacting with Claude Code we download the zip
# file for the code updates from Claude and then run this script to
# compare and merge.

# Check if a filename was provided

if [ $# -ne 0 ]; then
    echo "Usage: $0"
    exit 1
fi

appname=$(basename $PWD)

# Find the latest zip file to run meld across.

FIND_CLAUDE=$(find ~/Downloads -name "${appname}_lib*.zip" 2>/dev/null | head -1)
echo "Found ${FIND_CLAUDE}"

if [ -z "$FIND_CLAUDE" ]; then
    echo "Error: can not find the Claude zip file in Downloads ${appname}_lib.zip"
    exit 1
fi

# Create a temporary folder to work in

mkdir tmp

# Extract the zip file.

(cd tmp; unzip "${FIND_CLAUDE}")

# Run meld with the file and find result

meld tmp/lib lib

# Remove the file after meld closes

rm -rf tmp
rm -i "${FIND_CLAUDE}"
