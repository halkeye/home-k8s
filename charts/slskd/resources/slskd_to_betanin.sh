#!/bin/bash

name=$(echo "$1" | sed 's/.*"localDirectoryName":"\/downloads\/slskd\/\([^"]*\)".*/\1/')

wget -q -O/dev/null \
     --post-data "name=$name&path=/downloads" \
     --header="X-API-KEY: ${BETANIN_API_KEY}" \
     --header="User-Agent: slskd_to_betanin.sh" \
     "${BETANIN_URL}/api/torrents"
