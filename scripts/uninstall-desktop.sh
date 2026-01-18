#!/usr/bin/env bash
set -euo pipefail

echo "Uninstalling desktop (user) version..."

systemctl --user disable --now plex-keepawake.timer 2>/dev/null || true

rm -f "$HOME/.config/systemd/user/plex-keepawake.service"
rm -f "$HOME/.config/systemd/user/plex-keepawake.timer"
rm -f "$HOME/.local/bin/plex-keepawake.sh"

systemctl --user daemon-reload

echo "Done."
echo "Token left in place at ~/.config/plex-keepawake/token (delete it yourself if you want)."
