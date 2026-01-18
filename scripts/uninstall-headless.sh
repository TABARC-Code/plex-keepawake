#!/usr/bin/env bash
set -euo pipefail

echo "Uninstalling headless (system) version..."

systemctl disable --now plex-keepawake.timer 2>/dev/null || true

rm -f /etc/systemd/system/plex-keepawake.service
rm -f /etc/systemd/system/plex-keepawake.timer
rm -f /usr/local/bin/plex-keepawake.sh

systemctl daemon-reload

echo "Done."
echo "Token left in place at /etc/plex-keepawake/token (delete it yourself if you want)."
