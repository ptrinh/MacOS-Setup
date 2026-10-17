# macos-defaults

Opinionated `defaults write` settings for a new Mac: faster animations, Finder that shows everything, fast key repeat, no smart quotes, Dock and hot corners, plus a few app tweaks.

Curated from the old [`macbook-setup/default-writes.sh`](https://github.com/ptrinh/macbook-setup/blob/main/default-writes.sh) and checked against macOS 27 on Apple Silicon. Where the old script disagreed with how the current Mac is actually set up, the current setup won (natural scrolling and autocorrect stay on, Dock size 42, new Finder windows open Home, Activity Monitor shows CPU history).

## Usage

```sh
./defaults.sh          # user-level settings
./defaults.sh --sudo   # also: mute boot chime, show host info on the login window
```

Safe to re-run. Some changes need a logout/restart.

## Dropped from the old script

| Setting | Why |
|---|---|
| Disable hibernation, sleep image hacks, `systemsetup -setsleep Off` | Risks losing work when a laptop battery dies; `/var/vm` is protected now |
| `tmutil disable` / `disablelocal` | Turns off Time Machine entirely |
| Skip disk image verification | Weakens a security check |
| Spotlight (hide icon, exclusions, `orderedItems`, `.metadata_never_index`, rebuild index) | Blocked by SIP or old format; disabling home indexing breaks search |
| Safari, Mail, Messages tweaks | Apps are sandboxed; `defaults write` no longer reaches their prefs |
| Screen saver password delay | Ignored since High Sierra (use System Settings → Lock Screen) |
| Dashboard, Secure Empty Trash, subpixel font smoothing, HiDPI, Quick Look text selection | Removed from macOS or now default |
| Debug menus (Address Book, iCal, Disk Utility, App Store), SuperDrive, AirDrop over Ethernet | Obsolete |
| `lsregister -kill` | One-off cleanup, not a setting |
| `SystemAudioVolume` nvram | Replaced by `StartupMute` |
