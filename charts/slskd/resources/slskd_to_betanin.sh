#!/bin/bash

# trying out native lidarr plugin for now
exit 1

#name=$(echo "$1" | sed 's/.*"localDirectoryName":"\/downloads\/slskd\/\([^"]*\)".*/\1/')
name=$(echo "$1" | jq .localDirectoryName -r | sed 's/\/downloads\/slskd\///')

wget -q -O/dev/null \
  --post-data "name=$name&path=/downloads/slskd" \
  --header="X-API-KEY: ${BETANIN_API_KEY}" \
  --header="User-Agent: slskd_to_betanin.sh" \
  "${BETANIN_URL}/api/torrents"
