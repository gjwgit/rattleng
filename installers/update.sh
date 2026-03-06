#!/bin/bash

# set -x

# 20241024 gjw After a github action has built the bundles and stored
# them as artefacts on github, we can upload them to the ${HOST} for
# distribution.

APP=$(basename "$(dirname "$(pwd)")")
REP=$(git remote get-url origin | sed -E 's#.*[/:]([^/]+)/[^/]+(\.git)?$#\1#')

HOST=togaware.com
FLDR=apps/access/
DEST=${HOST}:${FLDR}

ssh ${HOST} 'if [ ! -d ${FLDR} ]; then mkdir ${FLDR}; chown gjw:gjw ${FLDR}; fi'

# From the recent 'Build Installers' workflows, identify the 'Bump
# version' pushes to the repository and get the latest one as the one
# we want to download the artefacts.

bumpId=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
	     | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version") or startswith("Build installers")) | .databaseId' \
	     | head -n 1)

echo "Github action id: $bumpId"

if [[ -z "${bumpId}" ]]; then
    echo "No workflow found."
    exit 1
fi

commitMsg=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
	     | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version") or startswith("Build installers")) | .displayTitle' \
	     | head -n 1)

echo "Commit: \"$commitMsg\""

status=$(gh run view ${bumpId} --json status --jq '.status')
conclusion=$(gh run view ${bumpId} --json conclusion --jq '.conclusion')

# Determine the latest version from pubspec.yaml. Assumes the
# latest Bump Version push is the same version.

version=$(grep version ../pubspec.yaml | head -1 | cut -d ':' -f 2 | sed 's/ //g' | sed 's/+.*//')

# Only proceed if the latest action hase been completed
# successfully. Each artifact which is downloaded as a zip file
# conatins a single file/installer.
#
# 20250611 gjw I used `gh` to download the artifact but that started
# failing:
#
#     gh run download ${bumpId} --name ${APP}-linux-zip
#     error downloading ${APP}-linux-zip: would result in path traversal
#
# I could manually download through the browser, unzip, and then move
# it here to then run this script. But this is now working as an
# alternative:
#
#     gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/3300608315/zip >| artifact.zip
#
# We need to get the correct artifact ID for each artefact.
#
# 20251230 gjw The timestamp from the artifact is UTC which I cahnge
# to current date/time in my timezone for consistency as the release
# time, using `touch`.

if [[ "${status}" == "completed" ]]; then

    # 20260122 gjw Even if we failed there may be some installer
    # builds that succeeded, so let's continue once the builds have
    # completed. This requires handling missing artefacts below.
    #
    # && "${conclusion}" == "success" ]]; then

    echo "App name: ${APP}"
    echo "App version: ${version}"
    echo "Repository: ${DEST}."
    echo

    echo '******************** UPLOAD LINUX DEB'

    TARGET="${APP}_amd64.deb"

    # 20260123 gjw Note that this obtains the latest available
    # linxu-deb artifact, which is not necessarily the one from the
    # latest bumpId if it failed to be build for the latest bumpId.

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-linux-deb")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time as the release time.
	rm -f artifact.zip
	echo  "Installing as ${DEST}${TARGET}"
	rsync -avzh ${fname} ${DEST}${TARGET}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${TARGET}"
	echo  "Archive as installers/ARCHIVE/${fname}"
	mv -f ${fname} ARCHIVE/
    fi

    echo ""

    echo '******************** UPLOAD LINUX SNAP'

    TARGET="${APP}_amd64.snap"

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-linux-snap")) | .id' | head -n 1)
    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${TARGET}"
	rsync -avzh ${fname} ${DEST}${TARGET}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${TARGET}"
	echo  "Archive as installers/ARCHIVE/${fname}"
	mv -f ${fname} ARCHIVE/
    fi

    echo ""

    echo '******************** UPLOAD LINUX ZIP'

    TARGET="${APP}-linux.zip"

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-linux-zip")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${TARGET}"
	rsync -avzh ${fname} ${DEST}${TARGET}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${TARGET}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_linux.zip"
	mv -f ${fname} ARCHIVE/${APP}_${version}_linux.zip
    fi

    echo ""

    echo '******************** UPLOAD MACOS ZIP ORIGINAL'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-zip")) | .id' | head -n 1)
    echo "artifact id: $artifactId"
    gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
    unzip artifact.zip
    rm -f artifact.zip

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${APP}-macos.zip"
	rsync -avzh ${APP}-macos.zip ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${APP}-macos.zip"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos.zip"
	mv ${APP}-macos.zip ARCHIVE/${APP}_${version}_macos.zip
    fi

    echo ""

    echo '******************** UPLOAD MACOS DMG ORIGINAL'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-dmg")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
        echo "artifact id: $artifactId"
        gh api -H "Accept: application/vnd.github+json" \
	   repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip \
	   > artifact.zip
        unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos.dmg"
	mv ${fname} ARCHIVE/${APP}_${version}_macos.dmg
    fi

    echo ""

    # 20251222 gjw
    #
    #    The macOS and iOS signed/certified builds are under
    #    development with the notepod app. Once it is working there we
    #    can migrate all other apps.

    echo '******************** UPLOAD MACOS ZIP UNSIGNED'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-unsigned-zip")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos_unsigned.dmg"
	mv ${fname} ARCHIVE/${APP}_${version}_macos_unsigned.zip
    fi

    echo ""

    echo '******************** UPLOAD MACOS DMG UNSIGNED'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-unsigned-dmg")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos_unsigned.dmg"
	mv ${fname} ARCHIVE/${APP}_${version}_macos_unsigned.dmg
    fi

    echo ""

    echo '******************** UPLOAD MACOS DMG STAGING'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-staging-dmg")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos_staging.dmg"
	mv ${fname} ARCHIVE/${APP}_${version}_macos_staging.dmg
    fi

    echo ""

    echo '******************** UPLOAD MACOS DMG DEV'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-macos-dev-dmg")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_macos_dev.dmg"
	mv ${fname} ARCHIVE/${APP}_${version}_macos_dev.dmg
    fi

    echo ""

    echo '******************** UPLOAD WINDOWS INNO'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-windows-inno")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_windows_inno.exe"
	mv ${fname} ARCHIVE/${APP}_${version}_windows_inno.exe
    fi

    echo ""

    echo '******************** UPLOAD WINDOWS ZIP'

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/${REP}/${APP}/actions/artifacts \
		    --jq '.artifacts[] | select(.name | endswith("-windows-zip")) | .id' | head -n 1)

    if [[ -z "${artifactId}" ]]; then
	echo "No artifact found."
    else
	echo "artifact id: $artifactId"
	gh api -H "Accept: application/vnd.github+json" repos/${REP}/${APP}/actions/artifacts/${artifactId}/zip > artifact.zip
	unzip artifact.zip
	fname=$(unzip -l artifact.zip | awk 'NR==4 {print $4}')
	touch ${fname} # Timestamp with current date/time
	rm -f artifact.zip
	echo  "Installing as ${DEST}${fname}"
	rsync -avzh ${fname} ${DEST}
	ssh ${HOST} "cd ${FLDR}; chmod 0644 ${fname}"
	echo  "Archive as installers/ARCHIVE/${APP}_${version}_windows.zip"
	mv -f ${APP}-windows.zip ARCHIVE/${APP}_${version}_windows.zip
    fi

    echo ""

else

    gh run view ${bumpId} | cat
    gh run view ${bumpId} --json status,conclusion
    echo ''
    echo "******************** Latest github actions has not successfully completed. Exiting."
    echo ''
    exit 1
fi
