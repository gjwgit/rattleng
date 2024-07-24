#!/bin/bash

# Assume the latest is a Bump version - we only run the actions on a bump version.

if [ "$(gh run list --limit 1 --json databaseId,status --jq '.[0].status')" = "completed" ]; then
    rm -f rattle-dev-linux.zip

    # Determine the latest version. Assumes the latest action is a
    # Bump veriosn push.
    
    version=$(gh run list --limit 100 --json databaseId,displayTitle \
		  | jq -r '.[] | select(.displayTitle | startswith("Bump version")) | .displayTitle' \
		  | head -n 1 \
	          | cut -d' ' -f3)

    # Linux
    
    gh run download $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId') --name rattle-linux
    mv rattle-dev-linux.zip rattleng-dev-linux.zip
    cp rattleng-dev-linux.zip rattleng-${version}-linux.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-dev-linux.zip rattleng-${version}-linux.zip togaware.com:apps/access/

    # MacOS
    
    gh run download $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId') --name rattle-macos
    mv rattle-dev-macos.zip rattleng-dev-macos.zip
    cp rattleng-dev-macos.zip rattleng-${version}-macos.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-dev-macos.zip rattleng-${version}-macos.zip togaware.com:apps/access/

    # Windows
    
    gh run download $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId') --name rattle-windows
    mv rattle-dev-windows.zip rattleng-dev-windows.zip
    cp rattleng-dev-windows.zip rattleng-${version}-windows.zip
    chmod a+r rattleng*.zip
    rsync -avzh rattleng-dev-windows.zip rattleng-${version}-windows.zip togaware.com:apps/access/
    
else
    echo "Latest github actions has not completed. Exiting."
    exit 1
fi
