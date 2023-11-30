#!/usr/bin/env bash

set -euo pipefail

arb_utils generate-meta ./lib/l10n/arb/app_en.arb
arb_utils sort ./lib/l10n/arb/app_en.arb
fvm flutter gen-l10n
