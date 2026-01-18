#!/usr/bin/env bash
set -euo pipefail

say() { printf '%s\n' "$*"; }

say "Doctor report"
say

need() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    say "OK: $cmd"
  else
    say "MISSING: $cmd"
  fi
}

need curl
need jq
need systemctl

say
say "Token checks"
if [[ -f "$HOME/.config/plex-keepawake/token" ]]; then
  say "Found: ~/.config/plex-keepawake/token"
else
  say "Not found: ~/.config/plex-keepawake/token"
fi

if [[ -f "/etc/plex-keepawake/token" ]]; then
  say "Found: /etc/plex-keepawake/token"
else
  say "Not found: /etc/plex-keepawake/token"
fi

say
say "Desktop timer status (if applicable)"
systemctl --user list-timers 2>/dev/null | grep -i plex || say "No user timer visible (fine on headless)."

say
say "System timer status (if applicable)"
systemctl list-timers 2>/dev/null | grep -i plex || say "No system timer visible (fine on desktop)."

say
say "Plex API quick probe (local)"
if curl -fsS --max-time 2 "http://127.0.0.1:32400/identity" >/dev/null 2>&1; then
  say "OK: Plex responds on 127.0.0.1:32400"
else
  say "No response from Plex on 127.0.0.1:32400 (is Plex running locally?)"
fi
