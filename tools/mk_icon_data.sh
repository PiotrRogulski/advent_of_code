#!/usr/bin/env bash

set -euo pipefail

die() {
  printf "\e[31m%s\e[0m\n" "$1"
  exit 1
}

if [ ! -f pubspec.yaml ]; then
  die "pubspec.yaml not found in current directory"
fi

CODEPOINT_FILE="MaterialIconsRound-Regular.codepoints"

function replace() {
  case $1 in
  1) echo "one" ;;
  2) echo "two" ;;
  3) echo "three" ;;
  4) echo "four" ;;
  5) echo "five" ;;
  6) echo "six" ;;
  7) echo "seven" ;;
  8) echo "eight" ;;
  9) echo "nine" ;;
  10) echo "ten" ;;
  11) echo "eleven" ;;
  12) echo "twelve" ;;
  13) echo "thirteen" ;;
  14) echo "fourteen" ;;
  15) echo "fifteen" ;;
  16) echo "sixteen" ;;
  17) echo "seventeen" ;;
  18) echo "eighteen" ;;
  19) echo "nineteen" ;;
  20) echo "twenty" ;;
  21) echo "twentyOne" ;;
  22) echo "twentyTwo" ;;
  23) echo "twentyThree" ;;
  24) echo "twentyFour" ;;
  30) echo "thirty" ;;
  50) echo "fifty" ;;
  60) echo "sixty" ;;
  123) echo "oneTwoThree" ;;
  360) echo "threeSixty" ;;
  *) die "Unknown number: $1" ;;
  esac
}

if [ ! -f "$CODEPOINT_FILE" ]; then
  die "$CODEPOINT_FILE not found in current directory"
fi

OUTPUT_FILE="lib/design_system/icons.dart"

if [ -f "$OUTPUT_FILE" ]; then
  rm "$OUTPUT_FILE"
fi

cat <<EOF >>"$OUTPUT_FILE"
// ignore_for_file: constant_identifier_names

import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/widgets.dart';

class AocIconData extends IconData {
  const AocIconData(super.codePoint)
      : super(fontFamily: FontFamily.materialSymbolsRounded);
}

final class AocIcons {
  AocIcons._();

EOF

mapfile -t lines <"$CODEPOINT_FILE"
for line in "${lines[@]}"; do
  if [[ $line =~ ^# ]]; then
    continue
  fi

  name=$(echo "$line" | cut -d' ' -f1)
  codepoint=$(echo "$line" | cut -d' ' -f2 | tr '[:lower:]' '[:upper:]')

  if [[ $name =~ ^([0-9]+)(.*) ]]; then
    number="${BASH_REMATCH[1]}"
    rest="${BASH_REMATCH[2]}"
    if [ -n "$rest" ]; then
      if [[ "$rest" =~ ^_ ]]; then
        name="$(replace "$number")$rest"
      else
        name="$(replace "$number")_$rest"
      fi
    else
      name="$(replace "$number")"
    fi
  fi

  echo "  static const IconData $name = AocIconData(0x$codepoint);" >>"$OUTPUT_FILE"
done

cat <<EOF >>"$OUTPUT_FILE"
}
EOF
