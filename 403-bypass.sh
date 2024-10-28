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