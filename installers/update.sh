#!/bin/bash

# 20241024 gjw After a github action has built the bundles and stored
# them as artefacts on github, we can upload them to togaware.com for
# distribution.

APP=rattle

HOST=togaware.com
FLDR=apps/access/
DEST=${HOST}:${FLDR}

# From the recent 'Build Installers' workflows, identify the 'Bump
# version' pushes to the repositroy and get the latest one as the one
# we want to download the artefacts.

bumpId=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
	     | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version")) | .databaseId' \
	     | head -n 1)

if [[ -z "${bumpId}" ]]; then
    echo "No workflow found."
    exit 1
fi

status=$(gh run view ${bumpId} --json status --jq '.status')
conclusion=$(gh run view ${bumpId} --json conclusion --jq '.conclusion')

# Only proceed if the latest action hase been completed successfully

if [[ "${status}" == "completed" && "${conclusion}" == "success" ]]; then

    echo "Uploads are going to ${DEST}."
    echo

    # Determine the latest version from pubspec.yaml. Assumes the
    # latest Bump Version push is the same version.

    version=$(grep version ../pubspec.yaml | head -1 | cut -d ':' -f 2 | sed 's/ //g')

    echo '***** UPLOAD LINUX ZIP. LOCAL INSTALL'

    gh run download ${bumpId} --name ${APP}-linux-zip
    rsync -avzh ${APP}-dev-linux.zip ${DEST}
    unzip -oq ${APP}-dev-linux.zip -d ${HOME}/.local/share/${APP}/
    mv -f ${APP}-dev-linux.zip ARCHIVE/${APP}-${version}-linux.zip

    echo ""

    echo '***** UPLOAD WINDOWS INNO'

    gh run download ${bumpId} --name ${APP}-windows-inno
    rsync -avzh ${APP}-dev-windows-inno.exe ${DEST}
    mv ${APP}-dev-windows-inno.exe ARCHIVE/${APP}-${version}-windows-inno.exe

    echo ""

    echo '***** UPLOAD WINDOWS ZIP'

    gh run download ${bumpId} --name ${APP}-windows-zip
    rsync -avzh ${APP}-dev-windows.zip ${DEST}
    mv -f ${APP}-dev-windows.zip ARCHIVE/${APP}-${version}-windows.zip
    ssh ${HOST} "cd ${FLDR}; chmod a+r ${APP}-dev-*.zip ${APP}-dev-*.exe"


    echo ""

    echo '***** UPLOAD MACOS'

    gh run download ${bumpId} --name ${APP}-macos-zip
    rsync -avzh ${APP}-dev-macos.zip ${DEST}
    mv ${APP}-dev-macos.zip ARCHIVE/${APP}-${version}-macos.zip
    ssh ${HOST} "cd ${FLDR}; chmod a+r ${APP}-dev-*.zip ${APP}-dev-*.exe"

else
    gh run view ${bumpId}
    gh run view ${bumpId} --json status,conclusion
    echo ''
    echo "***** Latest github actions has not successfully completed. Exiting."
    echo ''
    exit 1
fi
