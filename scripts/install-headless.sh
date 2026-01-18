#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing headless (system) version..."

# deps (best effort)
if command -v apt >/dev/null 2>&1; then
  apt update
  apt install -y curl jq
fi

install -m 0755 "$ROOT_DIR/bin/plex-keepawake.sh" /usr/local/bin/plex-keepawake.sh

mkdir -p /etc/plex-keepawake
if [[ ! -f /etc/plex-keepawake/token ]]; then
  cat >/etc/plex-keepawake/token <<'EOF'
PASTE_YOUR_TOKEN_HERE
EOF
  chmod 0600 /etc/plex-keepawake/token
  echo "Token file created at /etc/plex-keepawake/token (edit it)."
fi

install -m 0644 "$ROOT_DIR/systemd/system/plex-keepawake.service" /etc/systemd/system/plex-keepawake.service
install -m 0644 "$ROOT_DIR/systemd/system/plex-keepawake.timer" /etc/systemd/system/plex-keepawake.timer

systemctl daemon-reload
systemctl enable --now plex-keepawake.timer

echo "Done."
echo "Check: systemctl list-timers | grep plex"
echo "Logs:  journalctl -u plex-keepawake.service -n 50 --no-pager"
