#!/usr/bin/env bash
set -euo pipefail

# Local Plex keep-awake helper.
#
# Reads token from:
#   - PLEX_TOKEN env var, OR
#   - ~/.config/plex-keepawake/token, OR
#   - /etc/plex-keepawake/token
#   - Agin do not bloody share tokens. i cannot stress enough
# Counts active sessions via Plex API. If >0, inhibits idle/sleep briefly.

IP="127.0.0.1"
PORT="32400"
INHIBIT_SECS="${INHIBIT_SECS:-180}"

token_from_file() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  # Strip whitespace/newlines
  tr -d ' \t\r\n' <"$f"
}

TOKEN="${PLEX_TOKEN:-}"
if [[ -z "$TOKEN" ]]; then
  TOKEN="$(token_from_file "$HOME/.config/plex-keepawake/token" || true)"
fi
if [[ -z "$TOKEN" ]]; then
  TOKEN="$(token_from_file "/etc/plex-keepawake/token" || true)"
fi

if [[ -z "$TOKEN" ]]; then
  # No token: do nothing. Silent by design.
  exit 0
fi

URL="http://${IP}:${PORT}/status/sessions?X-Plex-Token=${TOKEN}"

# Keep it snappy. If Plex is down, don't hang.
JSON="$(curl -fsS --max-time 2 -H "Accept: application/json" "$URL" 2>/dev/null || true)"
[[ -z "$JSON" ]] && exit 0

SESSIONS="$(jq -r '.MediaContainer.size // 0' <<<"$JSON" 2>/dev/null || echo 0)"
[[ "$SESSIONS" =~ ^[0-9]+$ ]] || SESSIONS=0

if ((SESSIONS > 0)); then
  # This is the Default behaviour: block idle + sleep (desktop-friendly).
  # Wereas a Headless installs override this by setting WHAT in their unit file.
  WHAT="${WHAT:-idle:sleep}"
  systemd-inhibit --what="$WHAT" --who="Plex" --why="Streaming in progress" sleep "$INHIBIT_SECS"
fi
