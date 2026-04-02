#!/bin/bash

# 20260216 gjw Pairwise compare files and run meld to update.

# set -x

SCRIPTS=${HOME}/projects/scripts/flutter
FILES=(
    .gitignore ${SCRIPTS}/gitignore
    .pubignore ${SCRIPTS}/pubignore
    .github/workflows/ci.yaml ${SCRIPTS}/github/workflows/ci.yaml
    .github/workflows/installers.yaml ${SCRIPTS}/github/workflows/installers.yaml
    .github/pull_request_template.md ${SCRIPTS}/github/pull_request_template.md
    Makefile ${SCRIPTS}/Makefile.tmpl
    installers/deb.sh ${SCRIPTS}/installers/deb.sh
    installers/update.sh ${SCRIPTS}/installers/update.sh
    support/modules.mk  ${SCRIPTS}/../support/modules.mk
    support/flutter.mk  ${SCRIPTS}/../support/flutter.mk
    support/git.mk  ${SCRIPTS}/../support/git.mk
    support/loc.sh  ${SCRIPTS}/../support/loc.sh
    support/meld_zip_from_claude.sh  ${SCRIPTS}/../support/meld_zip_from_claude.sh
    support/update.sh  ${SCRIPTS}/../support/update.sh
)

# 20260217 gjw Handle different licenses for applications (GPL) and
# packages (MIT).

if grep --quiet gpl-3-0 license.dart; then
    FILES+=(license.dart ${SCRIPTS}/license.app.dart)
else
    FILES+=(license.dart ${SCRIPTS}/license.pkg.dart)
fi

length=${#FILES[@]}

for ((i=0; i < length; i+=2)); do
    f1=${FILES[i]}
    f2=${FILES[i+1]}

    if [ -f "$f1" ] && [ -f "$f2" ]; then
	# 20260217 gjw For license.dart do not consider the first line
	# in the comparison nor the 5th line which might be Copyright
	# SII or Togaware.

	if [[ "$f1" == "license.dart" ]]; then
	    if diff <(sed '1d;5d' "$f1") <(sed '1d;5d' "$f2") >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260220 gjw For the installers workflow we expect the APP
	# and LINUX_PKGS to differ so ignore those lines.

	elif [[ "$f1" == ".github/workflows/installers.yaml" ]]; then
	    if diff <(grep -v '^  APP:' "$f1" | grep -v '^  LINUX_PKGS:') <(grep -v '^  APP:' "$f2" | grep -v '^  LINUX_PKGS:') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260306 gjw For the Makefile we expect the REPO, RLOC, and
	# DWLD to differ so ignore those lines.

	elif [[ "$f1" == "Makefile" ]]; then
	    if diff <(grep -v '^REPO=' "$f1" | grep -v '^RLOC=' | grep -v '^DWLD=') <(grep -v '^REPO=' "$f2" | grep -v '^RLOC=' | grep -v '^DWLD=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260324 gjw For the deb installers script we expect the
	# Name= and Comment= to differ so ignore those lines.

	elif [[ "$f1" == "installers/deb.sh" ]]; then
	    if diff <(grep -v '^Name=' "$f1" | grep -v '^Comment=') <(grep -v '^Name=' "$f2" | grep -v '^Comment=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260306 gjw For the installers uploader we expect the HOST
	# and FLDR to differ so ignore those lines.

	elif [[ "$f1" == "installers/update.sh" ]]; then
	    if diff <(grep -v '^HOST=' "$f1" | grep -v '^FLDR=') <(grep -v '^HOST=' "$f2" | grep -v '^FLDR=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260306 gjw Otherwise do a straightforward comparison.

        else
	   if cmp -s "$f1" "$f2"; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi
	fi
    else
	if [ ! -f "$f1" ] && [ -f "$f2" ]; then
	    echo "MISSING   $f1 <- $f2"
	    cp "$f2" "$f1"
	else
	    echo "MISSING $f2"
	fi
    fi
done

#         file1=${FILES[i]}
#         file2=${FILES[i+1]}

#         # Check if file1 exists
#         if [ -f "$file1" ] && [ -f "${SCRIPTS}/$file1" ]; then
#             # Check if file2 exists
#             if [ -n "$file2" ] && [ -f "$file2" ] && [ -f "${SCRIPTS}/$file2" ]; then
#                 # Compare files
#                 if ! cmp -s "$file1" "${SCRIPTS}/$file1" || ! cmp -s "$file2" "${SCRIPTS}/$file2"; then
#                     echo "Files $file1 and ${SCRIPTS}/$file1 are different. Opening meld..."
#                     meld "$file1" "${SCRIPTS}/$file1" &
#                     echo "Files $file2 and ${SCRIPTS}/$file2 are different. Opening meld..."
#                     meld "$file2" "${SCRIPTS}/$file2" &
#                 else
#                     echo "Files $file1 and ${SCRIPTS}/$file1, and $file2 and ${SCRIPTS}/$file2 are identical."
#                 fi
#             elif [ -n "$file2" ]; then
#                 echo "File $file2 or ${SCRIPTS}/$file2 does not exist."
#             fi
#         else
#             echo "File $file1 or ${SCRIPTS}/$file1 does not exist."
#         fi
#     done
