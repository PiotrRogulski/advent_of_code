#!/usr/bin/env bash

set -euo pipefail

fvm dart run arb_utils generate-meta ./lib/l10n/arb/app_en.arb

for arb in ./lib/l10n/arb/*.arb; do
  fvm dart run arb_utils sort "$arb"
done

# add final EOLs to arbs if missing
for arb in ./lib/l10n/arb/*.arb; do
  if [[ $(tail -c1 "$arb" | wc -l) -eq 0 ]]; then
    echo >> "$arb"
  fi
done

fvm flutter gen-l10n
