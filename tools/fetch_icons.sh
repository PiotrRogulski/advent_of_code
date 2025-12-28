#!/usr/bin/env bash

set -euo pipefail

FONT_NAME="MaterialSymbolsRounded"
BASE_NAME=$(echo -n "${FONT_NAME}[FILL,GRAD,opsz,wght]" | jq -s -R -r @uri)
BASE_URL="https://raw.githubusercontent.com/google/material-design-icons/master/variablefont"
CODEPOINTS_FILE_URL="${BASE_URL}/${BASE_NAME}.codepoints"
FONT_FILE_URL="${BASE_URL}/${BASE_NAME}.ttf"

curl -s "${CODEPOINTS_FILE_URL}" > "${FONT_NAME}.codepoints"
curl -s "${FONT_FILE_URL}" > "assets/fonts/${FONT_NAME}.ttf"
