#!/bin/bash

# 20260515 gjw Use hard links. Should be github friendly. A littler
# trickier to see that they are a hard link.
#
# 20260512 gjw Why not symlink when the files are identical? Synlinks
# are not github friendly though, being a text file containg the path
# to the linked file. But these IDENTICAL files are stored in another
# repo so let's go with that one copy principle.
#
# 20260216 gjw Pairwise compare files and run meld to update.

# set -x

APP=$(basename "$(pwd)")

# 20260429 gjw Identify if we are working with an application rather
# than a package. Packages do not have installers.

IS_APP=false
test -f lib/main.dart && IS_APP=true

# 20260517 gjw Deal with files that will be exactly the same across
# all instances. They are a hard link to the one file in
# projects/scripts.

SCRIPTS=${HOME}/projects/scripts/
FILES=(
    ${SCRIPTS}support/loc.sh support/loc.sh
    ${SCRIPTS}support/meld_zip_from_claude.sh support/meld_zip_from_claude.sh
    ${SCRIPTS}support/flutter.mk support/flutter.mk
    ${SCRIPTS}support/update.sh support/update.sh
    ${SCRIPTS}flutter/.gitignore .gitignore
    ${SCRIPTS}flutter/.lycheeignore .lycheeignore
    ${SCRIPTS}flutter/CLAUDE.md CLAUDE.md
    ${SCRIPTS}Makefile Makefile
)

length=${#FILES[@]}

for ((i=0; i < length; i+=2)); do
    f1=${FILES[i]}
    f2=${FILES[i+1]}

    # 20260517 gjw Check that both files exist first.

    if [ -f "$f1" ] && [ -f "$f2" ]; then

	# Obtain the device:inode pair

	inode1=$(stat -c "%d:%i" -- "$f1" 2>/dev/null)
	inode2=$(stat -c "%d:%i" -- "$f2" 2>/dev/null)

	if [[ -z $inode1 || -z $inode2 ]]; then
	    echo "stat failed for one of the files" >&2
	    exit 3
	fi

	if [[ $inode1 == $inode2 ]]; then
	    echo "HARD LINK $f1 $f2"
	else
	    if cmp -s "$f1" "$f2"; then
		echo "IDENTICIAL $f1 $f2"
	    else
		echo "DIFF LINK? ln $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi
	    ln --interactive $f1 $f2
	fi

	continue

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

	# 20260512 gjw For the common version of this for Makefile
	# import a local.mk from the new make folder to define REPO,
	# RLOC, and DWLD
	#
	# 20260306 gjw For the Makefile we expect the REPO, RLOC, and
	# DWLD to differ so ignore those lines.

	elif [[ "$f1" == "Makefile" ]]; then
	    if diff <(grep -v '^REPO=' "$f1" | grep -v '^RLOC=' | grep -v '^DWLD=') <(grep -v '^REPO=' "$f2" | grep -v '^RLOC=' | grep -v '^DWLD=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260415 gjw Now deal with the APPs that require installers
	# rather than the PKGS which don't.

	# 20260324 gjw For the deb installers script we expect the
	# Name= and Comment= to differ so ignore those lines.

	elif [[ "$f1" == "installers/deb.sh" ]] && $IS_APP; then
	    if diff <(grep -v '^Name=' "$f1" | grep -v '^Comment=' | sed '/^Description: /,/^EOL$/d') <(grep -v '^Name=' "$f2" | grep -v '^Comment=' | sed '/^Description: /,/^EOL$/d') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

        # 20260306 gjw For the installers uploader we expect the HOST
	# and FLDR to differ so ignore those lines.

	elif [[ "$f1" == "installers/update.sh" ]] && $IS_APP; then
	    if diff <(grep -v '^HOST=' "$f1" | grep -v '^FLDR=') <(grep -v '^HOST=' "$f2" | grep -v '^FLDR=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260220 gjw For the installers workflow we expect the APP
	# and LINUX_PKGS to differ so ignore those lines.

	elif [[ "$f1" == ".github/workflows/installers.yaml" ]] && $IS_APP; then
	    if diff <(grep -v '^  APP:' "$f1" | grep -v '^  LINUX_PKGS:') <(grep -v '^  APP:' "$f2" | grep -v '^  LINUX_PKGS:') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f1 $f2"
		meld "$f1" "$f2" 2> /dev/null
	    fi

	# 20260306 gjw Otherwise do a straightforward comparison.

        else
	    if [[ "$f1" == *install* ]] && [ "$IS_APP" = false ]; then
		echo "SKIP      $f1 $f2"
	    else
		if cmp -s "$f1" "$f2"; then
		    echo "IDENTICAL $f1 $f2"
		else
		    echo "MELD      $f1 $f2"
		    meld "$f1" "$f2" 2> /dev/null
		fi
	    fi
	fi
    else
	if [[ "$f1" == *install* ]] && [ "$IS_APP" = false ]; then
	    echo "SKIP      $f1 $f2"
	else
	    if [ ! -f "$f2" ] && [ -f "$f1" ]; then
		echo "MISSING   $f1 -> $f2"
		cp "$f1" "$f2"
	    else
		echo "MISSING $f2"
	    fi
	fi
    fi
done

# 20260517 gjw Old scritps moveing to the processing above.

SCRIPTSBB=${HOME}/projects/scriptsbb/flutter
FILESBB=(
    .pubignore ${SCRIPTSBB}/pubignore
    .github/workflows/ci.yaml ${SCRIPTSBB}/github/workflows/ci.yaml
    .github/workflows/installers.yaml ${SCRIPTSBB}/github/workflows/installers.yaml
    .github/pull_request_template.md ${SCRIPTSBB}/github/pull_request_template.md
    installers/deb.sh ${SCRIPTSBB}/installers/deb.sh
    installers/update.sh ${SCRIPTSBB}/installers/update.sh
    support/modules.mk  ${SCRIPTSBB}/../support/modules.mk
    support/git.mk  ${SCRIPTSBB}/../support/git.mk
)

# 20260217 gjw Handle different licenses for applications (GPL) and
# packages (MIT).

if grep --quiet gpl-3-0 license.dart; then
    FILESBB+=(license.dart ${SCRIPTSBB}/license.app.dart)
else
    FILESBB+=(license.dart ${SCRIPTSBB}/license.pkg.dart)
fi

length=${#FILESBB[@]}

for ((i=0; i < length; i+=2)); do
    f1=${FILESBB[i]}
    f2=${FILESBB[i+1]}

    if [ -f "$f1" ] && [ -f "$f2" ]; then
	# 20260217 gjw For license.dart do not consider the first line
	# in the comparison nor the 5th line which might be Copyright
	# SII or Togaware.

	if [[ "$f1" == "license.dart" ]]; then
	    if diff <(sed '1d;5d' "$f1") <(sed '1d;5d' "$f2") >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f2 $f1"
		meld "$f2" "$f1" 2> /dev/null
	    fi

	# 20260512 gjw For the common version of this for Makefile
	# import a local.mk from the new make folder to define REPO,
	# RLOC, and DWLD
	#
	# 20260306 gjw For the Makefile we expect the REPO, RLOC, and
	# DWLD to differ so ignore those lines.

	elif [[ "$f1" == "Makefile" ]]; then
	    if diff <(grep -v '^REPO=' "$f1" | grep -v '^RLOC=' | grep -v '^DWLD=') <(grep -v '^REPO=' "$f2" | grep -v '^RLOC=' | grep -v '^DWLD=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f2 $f1"
		meld "$f2" "$f1" 2> /dev/null
	    fi

	# 20260415 gjw Now deal with the APPs that require installers
	# rather than the PKGS which don't.

	# 20260324 gjw For the deb installers script we expect the
	# Name= and Comment= to differ so ignore those lines.

	elif [[ "$f1" == "installers/deb.sh" ]] && $IS_APP; then
	    if diff <(grep -v '^Name=' "$f1" | grep -v '^Comment=' | sed '/^Description: /,/^EOL$/d') <(grep -v '^Name=' "$f2" | grep -v '^Comment=' | sed '/^Description: /,/^EOL$/d') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f2 $f1"
		meld "$f2" "$f1" 2> /dev/null
	    fi

        # 20260306 gjw For the installers uploader we expect the HOST
	# and FLDR to differ so ignore those lines.

	elif [[ "$f1" == "installers/update.sh" ]] && $IS_APP; then
	    if diff <(grep -v '^HOST=' "$f1" | grep -v '^FLDR=') <(grep -v '^HOST=' "$f2" | grep -v '^FLDR=') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f2 $f1"
		meld "$f2" "$f1" 2> /dev/null
	    fi

	# 20260220 gjw For the installers workflow we expect the APP
	# and LINUX_PKGS to differ so ignore those lines.

	elif [[ "$f1" == ".github/workflows/installers.yaml" ]] && $IS_APP; then
	    if diff <(grep -v '^  APP:' "$f1" | grep -v '^  LINUX_PKGS:') <(grep -v '^  APP:' "$f2" | grep -v '^  LINUX_PKGS:') >/dev/null; then
		echo "IDENTICAL $f1 $f2"
	    else
		echo "MELD      $f2 $f1"
		meld "$f2" "$f1" 2> /dev/null
	    fi

	# 20260306 gjw Otherwise do a straightforward comparison.

        else
	    if [[ "$f1" == *install* ]] && [ "$IS_APP" = false ]; then
		echo "SKIP      $f1 $f2"
	    else
		if cmp -s "$f1" "$f2"; then
		    echo "IDENTICAL $f1 $f2"
		else
		    echo "MELD      $f2 $f1"
		    meld "$f2" "$f1" 2> /dev/null
		fi
	    fi
	fi
    else
	if [[ "$f1" == *install* ]] && [ "$IS_APP" = false ]; then
	    echo "SKIP      $f1 $f2"
	else
	    if [ ! -f "$f1" ] && [ -f "$f2" ]; then
		echo "MISSING   $f1 <- $f2"
		cp "$f2" "$f1"
	    else
		echo "MISSING $f2"
	    fi
	fi
    fi
done

#         file1=${FILESBB[i]}
#         file2=${FILESBB[i+1]}

#         # Check if file1 exists
#         if [ -f "$file1" ] && [ -f "${SCRIPTSBB}/$file1" ]; then
#             # Check if file2 exists
#             if [ -n "$file2" ] && [ -f "$file2" ] && [ -f "${SCRIPTSBB}/$file2" ]; then
#                 # Compare files
#                 if ! cmp -s "$file1" "${SCRIPTSBB}/$file1" || ! cmp -s "$file2" "${SCRIPTSBB}/$file2"; then
#                     echo "Files $file1 and ${SCRIPTSBB}/$file1 are different. Opening meld..."
#                     meld "$file1" "${SCRIPTSBB}/$file1" &
#                     echo "Files $file2 and ${SCRIPTSBB}/$file2 are different. Opening meld..."
#                     meld "$file2" "${SCRIPTSBB}/$file2" &
#                 else
#                     echo "Files $file1 and ${SCRIPTSBB}/$file1, and $file2 and ${SCRIPTSBB}/$file2 are identical."
#                 fi
#             elif [ -n "$file2" ]; then
#                 echo "File $file2 or ${SCRIPTSBB}/$file2 does not exist."
#             fi
#         else
#             echo "File $file1 or ${SCRIPTSBB}/$file1 does not exist."
#         fi
#     done
