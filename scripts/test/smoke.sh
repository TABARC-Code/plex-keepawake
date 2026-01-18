#!/usr/bin/env bash
set -euo pipefail

# Smoke tests: basic sanity, no network aassumptions. just me adding adding bells and whistles.

fail() { echo "FAIL: $*" >&2; exit 1; }

[[ -x bin/plex-keepawake.sh ]] || fail "bin/plex-keepawake.sh not executable"

# Shell should parse it
bash -n bin/plex-keepawake.sh

# Should exit cleanly with no token
PLEX_TOKEN="" INHIBIT_SECS=1 bash -c 'bin/plex-keepawake.sh' || fail "script failed without token"

echo "OK: smoke tests"
