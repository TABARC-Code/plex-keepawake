#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing desktop (user) version..."

# deps (best effort)
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl jq
fi

mkdir -p "$HOME/.local/bin"
install -m 0755 "$ROOT_DIR/bin/plex-keepawake.sh" "$HOME/.local/bin/plex-keepawake.sh"

mkdir -p "$HOME/.config/systemd/user"
install -m 0644 "$ROOT_DIR/systemd/user/plex-keepawake.service" "$HOME/.config/systemd/user/plex-keepawake.service"
install -m 0644 "$ROOT_DIR/systemd/user/plex-keepawake.timer" "$HOME/.config/systemd/user/plex-keepawake.timer"

mkdir -p "$HOME/.config/plex-keepawake"

if [[ ! -f "$HOME/.config/plex-keepawake/token" ]]; then
  cat >"$HOME/.config/plex-keepawake/token" <<'EOF'
PASTE_YOUR_TOKEN_HERE
EOF
  chmod 0600 "$HOME/.config/plex-keepawake/token"
  echo "Token file created at ~/.config/plex-keepawake/token (edit it)."
fi

systemctl --user daemon-reload
systemctl --user enable --now plex-keepawake.timer

echo "Done."
echo "Check: systemctl --user list-timers | grep plex"
echo "Logs:  journalctl --user -u plex-keepawake.service -n 50 --no-pager"
