# Plex KeepAwake (local)

Stops Linux going to sleep when Plex has active sessions.

a quick and dirty solution,. Just does the job.

## What it does

Every 2 minutes:
- Ask local Plex (`127.0.0.1:32400`) if there are active sessions
- If yes, apply a short `systemd-inhibit` block for 180 seconds
- The timer repeats, so the inhibit overlaps until streaming ends

When nobody’s watching, it does nothing and your normal power settings apply.

## Requirements

- `curl`
- `jq`
- `systemd` (Ubuntu and most modern distros already have it)

Install deps:

```bash
sudo apt update
sudo apt install -y curl jq
Quick install
Desktop (Ubuntu Desktop, GNOME, etc.)
bash
Copy code
./scripts/install-desktop.sh
Headless (server, no desktop session)
bash
Copy code
sudo ./scripts/install-headless.sh
Token
You need a Plex token with permission to read sessions.

Typical way:

Open Plex Web

Press F12

Network tab

Start playback

Find a request containing X-Plex-Token=...

Put it in one place only:

Desktop: ~/.config/plex-keepawake/token

Headless: /etc/plex-keepawake/token

Yes, it’s a bit annoying. That’s Plex.

Check status
Desktop:

bash
Copy code
systemctl --user list-timers | grep plex
journalctl --user -u plex-keepawake.service -n 50 --no-pager
Headless:

bash
Copy code
systemctl list-timers | grep plex
journalctl -u plex-keepawake.service -n 50 --no-pager
Optional inhibitor check while streaming:

bash
Copy code
systemd-inhibit --list | grep Plex -n
Uninstall
Desktop:

bash
Copy code
./scripts/uninstall-desktop.sh
Headless:

bash
Copy code
sudo ./scripts/uninstall-headless.sh
Development checks (bug-hunter mode)
Run everything:

bash
Copy code
make check
What it runs:

ShellCheck (real bug finding)

shfmt (formatting)

smoke tests (basic sanity)

CI runs the same checks on push
