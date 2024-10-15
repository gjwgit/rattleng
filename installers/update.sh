#!/bin/bash

# Assume the latest is a Bump version - we only run the actions on a bump version.

if [ "$(gh run list --limit 1 --json databaseId,status --jq '.[0].status')" = "completed" ]; then
    rm -f rattle-dev-linux.zip

    # Identify the latest Bump Version but one. The latest is now the
    # integration test, and the one before it is the installer build.

    bumpId=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
		 | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version")) | .databaseId' | head -n 1)

    # Determine the latest version. Assumes the latest action is a
    # Bump veriosn push.
    
    version=$(gh run list --limit 100 --json databaseId,displayTitle \
		  | jq -r '.[] | select(.displayTitle | startswith("Bump version")) | .displayTitle' \
		  | head -n 1 \
	          | cut -d' ' -f3)

    # Ubuntu 20.04 20240801
    
    # gh run download ${bumpId} --name rattle-ubuntu
    # mv rattle-dev-ubuntu.zip rattleng-dev-ubuntu.zip
    # cp rattleng-dev-ubuntu.zip rattleng-${version}-ubuntu.zip
    # chmod a+r rattleng*.zip
    # rsync -avzh rattleng-dev-ubuntu.zip rattleng-${version}-ubuntu.zip togaware.com:apps/access/

    # Linux Ubuntu 20.04 20240801 moved from 22.04

    gh run download ${bumpId} --name rattle-linux-zip
    mv rattle-dev-linux.zip rattleng-dev-linux.zip
    cp rattleng-dev-linux.zip rattleng-${version}-linux.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-${version}-linux.zip togaware.com:apps/access/
    ssh togaware.com "cd apps/access; cp -f rattleng-${version}-linux.zip rattleng-dev-linux.zip"

    echo ""

    # Windows Inno

    gh run download ${bumpId} --name rattle-windows-inno
    mv rattle-0.0.0.exe rattleng-${version}-windows-inno.exe
    cp rattleng-${version}-windows-inno.exe rattleng-dev-windows-inno.exe
    chmod a+r rattleng*-inno.exe
    rsync -avzh rattleng-${version}-windows-inno.exe togaware.com:apps/access/
    ssh togaware.com "cd apps/access; cp -f rattleng-${version}-windows-inno.exe rattleng-dev-windows-inno.exe"

    echo ""

    # Windows Zip

    gh run download ${bumpId} --name rattle-windows-zip
    mv rattle-dev-windows.zip rattleng-dev-windows.zip
    cp rattleng-dev-windows.zip rattleng-${version}-windows.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-${version}-windows.zip togaware.com:apps/access/
    ssh togaware.com "cd apps/access; cp -f rattleng-${version}-windows.zip rattleng-dev-windows.zip"
    
    echo ""

    # MacOS

    gh run download ${bumpId} --name rattle-macos-zip
    mv rattle-dev-macos.zip rattleng-dev-macos.zip
    cp rattleng-dev-macos.zip rattleng-${version}-macos.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-${version}-macos.zip togaware.com:apps/access/
    ssh togaware.com "cd apps/access; cp -f rattleng-${version}-macos.zip rattleng-dev-macos.zip"

else
    echo "Latest github actions has not completed. Exiting."
    exit 1
fi
