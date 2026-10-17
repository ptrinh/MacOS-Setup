# charge-by-location

Automatically switches the MacBook charge limit based on where you are:

- **Moved** (different router) → charge to **100%** (you're on the go and want a full battery).
- **Stayed in one place ≥ 24h** → lower to **80%** (plugged in for a long time, protect the battery).

The location is identified by the MAC address of the router (default gateway). A LaunchAgent runs the script every hour and at login.

## Install

1. In the **Shortcuts** app, create 2 shortcuts named exactly `Charge 80` and `Charge 100`. Each needs a single action that sets the charge limit (search for "charge"), set to 80% and 100% respectively.
2. Run:
   ```sh
   ./install.sh
   ```

## Check

```sh
launchctl kickstart gui/$(id -u)/com.phil.charge-by-location
cat ~/.charge_loc ~/.charge_loc.log
```

- `~/.charge_loc`: current state, formatted as `MAC arrival_time mode`.
- `~/.charge_loc.log`: one line per charge limit change.
- `/tmp/charge-by-location.err`: errors (e.g. missing shortcuts).

> **Note:** running the script directly from some terminals (e.g. Claude Code) may fail to read the ARP table because macOS hides it (Local Network privacy), so the script leaves the state unchanged. Use `launchctl kickstart` as above to test.

## Uninstall

```sh
launchctl bootout gui/$(id -u)/com.phil.charge-by-location
rm ~/Library/LaunchAgents/com.phil.charge-by-location.plist ~/.local/bin/charge-by-location.sh ~/.charge_loc ~/.charge_loc.log
```
