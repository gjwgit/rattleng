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

claude=$(find ${HOME}/Downloads -name "${appname}_lib*.zip" 2>/dev/null -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)

if [[ ! -z "$claude" ]] && [[ "$(basename $claude)" != "${appname}_lib.zip" ]]; then
    read -p "Continue with ${claude}? (y/N) " response
    if [[ "$response" != "y" ]]; then
        exit 1
    fi
fi

if [ -z "$claude" ]; then
    echo "No Claude zip file in Downloads: ${appname}_lib.zip"
    exit 1
fi

# Create a temporary folder to work in

mkdir tmp

# Extract the zip file.

echo "Unzip ${claude} into ./tmp"

(cd tmp; unzip "${claude}")

# Run meld with the file and find result

for f in lib assets test integration_test README.md CLAUDE.md; do
    if [[ -e tmp/$f ]] && ! diff -rqw "$f" "tmp/$f" > /dev/null ; then
	meld tmp/$f $f
    fi
done

# Check if pubspec included and if so compare if the difference is
# other than the version line.

if [[ -f tmp/pubspec.yaml ]] && ! diff -qw "tmp/pubspec.yaml" "pubspec.yaml" > /dev/null; then
    if ! diff -u <(grep -v -E '^version:' pubspec.yaml) <(grep -v -E '^version:' tmp/pubspec.yaml) >/dev/null; then
	meld tmp/pubspec.yaml pubspec.yaml
    fi
fi

# Remove the file after meld closes

rm -rf tmp
rm -i "${claude}"

# Also remove any older file if there.

if [[ "$(basename $claude)" != "${appname}_lib.zip" ]]; then
    if [[ -f "${HOME}/Downloads/${appname}_lib.zip" ]]; then
	read -p "Also remove ${HOME}/Downloads/${appname}_lib.zip? (y/N) " response
	if [[ "$response" == "y" ]]; then
            rm -f ~/Downloads/${appname}_lib.zip
	fi
    fi
fi
