#!/bin/bash

SCRIPT_NAME="403-Bypass"
AUTHOR="Osman Tunahan ARIKAN"
TARGET_URL="$1"
TARGET_PATH="$2"

function color_code() {
    local status=$1
    if [[ $status -eq 200 ]]; then echo -e "\e[32m$status\e[0m";
    elif [[ $status -eq 403 ]]; then echo -e "\e[31m$status\e[0m";
    else echo -e "\e[33m$status\e[0m";
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

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments. Usage: ./403-bypass.sh [URL] [path]"
    exit 1
else
    main
fi