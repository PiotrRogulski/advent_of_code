#!/usr/bin/env bash

set -euo pipefail

arb_utils generate-meta ./lib/l10n/arb/app_en.arb
for arb in ./lib/l10n/arb/*.arb; do
  arb_utils sort "$arb"
done
fvm flutter gen-l10n
