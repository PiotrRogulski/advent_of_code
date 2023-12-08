#!/usr/bin/env bash

set -euo pipefail

die() {
  printf "\e[31m\e[1m%s\e[0m\n" "$1" >&2
  exit 1
}

warn() {
  printf "\e[33m\e[1m%s\e[0m\n" "$1" >&2
}

info() {
  printf "\e[32m\e[1m%s\e[0m\n" "$1" >&2
}

REQUIRED_COMMANDS=("curl" "xmllint")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
  if ! command -v "$cmd" >/dev/null; then
    die "Required command $cmd not found"
  fi
done

if [ ! -f pubspec.yaml ]; then
  while [ ! -f pubspec.yaml ]; do
    cd ..
    if [ "$(pwd)" = "/" ]; then
      die "pubspec.yaml not found in parent directories"
    fi
  done
  warn "pubspec.yaml not found in current directory, using $(pwd)"
fi

if [ -z "${AOC_COOKIE:-}" ] && [ -f .env ]; then
  source .env
fi

if [ -z "${AOC_COOKIE:-}" ]; then
  die "AOC_COOKIE not set"
fi

if [ $# -ne 2 ]; then
  YEAR=$(date +%Y)
  DAY=$(date +%-d)
fi

YEAR=${1:-$YEAR}
DAY=${2:-$DAY}

info "Fetching day $DAY of year $YEAR"

INPUT_FILE="assets/inputs/y$YEAR/d$DAY"

get_input() {
  local url="https://adventofcode.com/$YEAR/day/$DAY/input"
  set +e
  DATA=$(curl -f -b session="$AOC_COOKIE" "$url")
  local status=$?
  set -e
  if [ $status -ne 0 ]; then
    die "Failed to fetch input from $url"
  fi
  echo "$DATA"
}

if [ -f "$INPUT_FILE" ]; then
  warn "Input already fetched, overwrite?"
  read -r -p "[y/N] " response
  if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    exit 0
  fi
fi

url="https://adventofcode.com/$YEAR/day/$DAY/input"
set +e
INPUT=$(curl -f -b session="$AOC_COOKIE" "$url")
status=$?
set -e
if [ $status -ne 0 ]; then
  die "Failed to fetch input for day $DAY of year $YEAR"
fi
echo "$INPUT" >"$INPUT_FILE"

url="https://adventofcode.com/$YEAR/day/$DAY"
set +e
DAY_HTML=$(curl -f -b session="$AOC_COOKIE" "$url")
status=$?
set -e
if [ $status -ne 0 ]; then
  die "Failed to fetch day $DAY of year $YEAR"
fi
EXAMPLE_INPUT=$(echo "$DAY_HTML" | xmllint --html --xpath '(//pre/code/text())[1]' - 2>/dev/null)
echo "$EXAMPLE_INPUT" >"assets/inputs/y$YEAR/d$DAY.example"
