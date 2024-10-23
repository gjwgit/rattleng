#!/bin/bash

APP=rattle

HOST=togaware.com
FLDR=apps/access/
DEST=${HOST}:${FLDR}

# Assume the latest is a Bump version - we only run the actions on a bump version.

if [ "$(gh run list --limit 1 --json databaseId,status --jq '.[0].status')" = "completed" ]; then

    # Identify the latest Bump Version but one. The latest is now the
    # integration test, and the one before it is the installer build.

    bumpId=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
		 | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version")) | .databaseId' | head -n 1)

    # Determine the latest version. Assumes the latest action is a
    # Bump version push.
    
    version=$(grep version ../pubspec.yaml | head -1 | cut -d ':' -f 2 | sed 's/ //g')

    # Linux Ubuntu 20.04 build and local install

    gh run download ${bumpId} --name ${APP}-linux-zip
    rsync -avzh ${APP}-dev-linux.zip ${DEST}
    unzip -oq ${APP}-dev-linux.zip -d ${HOME}/.local/share/${APP}/
    mv -f ${APP}-dev-linux.zip ARCHIVE/${APP}-${version}-linux.zip

    echo ""

    # Windows Inno

    gh run download ${bumpId} --name ${APP}-windows-inno
    rsync -avzh ${APP}-dev-windows-inno.exe ${DEST}
    mv ${APP}-dev-windows-inno.exe ARCHIVE/${APP}-${version}-windows-inno.exe

    echo ""

    # Windows Zip

    gh run download ${bumpId} --name ${APP}-windows-zip
    rsync -avzh ${APP}-dev-windows.zip ${DEST}
    mv -f ${APP}-dev-windows.zip ARCHIVE/${APP}-${version}-windows.zip
    
    echo ""

    # MacOS

    gh run download ${bumpId} --name ${APP}-macos-zip
    rsync -avzh ${APP}-dev-macos.zip ${DEST}
    mv ${APP}-dev-macos.zip ARCHIVE/${APP}-${version}-macos.zip

    ssh ${HOST} "cd ${FLDR}; chmod a+r ${APP}-dev-*.zip ${APP}-dev-*.exe"
    
else
    echo "Latest github actions has not completed. Exiting."
    exit 1
fi
