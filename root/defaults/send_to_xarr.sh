#!/bin/bash

# "http://localhost:7878"
baseUrl=$1
key=$2
title=$3
downloadUrl=$4
indexer=$5

date=$(date -u +"%Y-%m-%d %H:%M:%SZ")
logFile="/config/log/rtorrent/postToSonarr.log"

log_error() {
    echo "[$(date --rfc-3339=seconds)] $1" >> $logFile
}

post_release() {
    status=$(curl --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Api-Key: $apiKey" -X POST -d "$1" $apiUrl)
    if [ "$status" == 200 ]; then
        exit 0
    elif [ "$status" == 303 ]; then
        log_error "[FATAL] Error 303 response from API - perhaps you need to setup base-url?"
        exit 1
    elif [ "$status" == 000 ]; then
        log_error "[FATAL] Unable to connect to \"$apiUrl\""
        exit 1
    else
        log_error "[ERROR] Unknown error occured with status $status"
        log_error "curl --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null -i -H \"Accept: application/json\" -H \"Content-Type: application/json\" -H \"X-Api-Key: $apiKey\" -X POST -d \"$1\" $apiUrl"
        exit 1
    fi
}

post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'"}'


