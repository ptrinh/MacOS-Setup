# install-apps

Sets up a new Mac: Rosetta, Homebrew (added to `~/.zprofile`), the apps in [`Brewfile`](Brewfile), and ArtCraft Launcher. Safe to re-run: anything already installed is skipped.

```sh
./install.sh
```

Edit `Brewfile` to add or remove apps. Upgrade all casks later with `brew upgrade --cask --greedy`.

## Not installed via Homebrew

| App | Why / how |
|---|---|
| [ArtCraft Launcher](https://github.com/storytold/craft-launcher) | No cask. `install.sh` downloads the latest `macos-universal.dmg` from GitHub, checks it against `SHA256SUMS.txt` and the Developer ID signature (team `DJ6XS33FX8`), then copies it to `/Applications` |
| OpenEmu | Cask disabled in Homebrew (fails Gatekeeper). Download from [openemu.org](https://openemu.org) |
| VipRiser | No cask. Download from the vendor |
| iPartition | No cask, Intel-only and discontinued; use Disk Utility |

## After install

- Little Snitch, BlackHole: approve in System Settings > General > Login Items & Extensions.
