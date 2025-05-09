#!/bin/bash

name=$(echo "$1" | sed 's/.*"localDirectoryName":"\/downloads\/slskd\/\([^"]*\)".*/\1/')

wget -q -O/dev/null \
     --data-urlencode "path=/downloads" \
     --data-urlencode "name=$name" \
     --header="X-API-KEY: ${BETANIN_API_KEY}" \
     --header="User-Agent: slskd_to_betanin.sh" \
     "${BETANIN_URL}/api/torrents"
