# performance

Lighter RAM, CPU and SSD use on an M-series Mac, based on what actually uses resources on the current machine (Chrome, OrbStack, Gradle daemons, simulators).

## `install.sh`

```sh
./install.sh          # user-level
./install.sh --sudo   # also power settings
```

| Area | What |
|---|---|
| Login | Staggered launch of heavy apps (Discord 20 s, Lark (LarkSuite) 30 s, Chrome 50 s, Dropbox 60 s after login) via LaunchAgents, instead of all at once. Edit `DELAYED` in the script. Remove those apps from Login Items |
| Background services | Disable Siri agent, Folder Actions, Script Menu, MDM enrollment agent, beta seed agent; Siri off |
| RAM / GPU | Reduce transparency and motion; Chrome Memory Saver on (recommended policy); OrbStack VM doesn't start at login; idle Gradle daemons stop after 15 min instead of 3 h |
| Power (`--sudo`) | On charger never sleep (long agent runs and builds finish), display off after 5 min (charger) / 2 min (battery) |

Hibernation (`hibernatemode 0`) is deliberately not changed: on a laptop it risks losing open work if the battery runs out during sleep.

## `cleanup.sh`: SSD space

```sh
./cleanup.sh         # dry run: shows sizes and what would be removed
./cleanup.sh --yes   # delete
```

Removes things that are rebuilt or re-downloaded on demand: Xcode DerivedData, devices of removed simulator runtimes, unusable runtimes and runtimes unused for 90 days, simulator caches, old Homebrew versions and downloads, npm cache, Gradle build cache and older wrapper distributions, dangling Docker images and build cache. Booted simulators, containers and tagged images are left alone. Don't run it while a build is in progress.

Reported but not touched: Xcode Archives (needed to symbolicate crash reports), the rest of `~/.gradle/caches`, Downloads.

## Habits that matter more than settings

- Restart every few days: swap accumulates over long uptimes even when RAM is free.
- Close idle Claude Code / agent sessions and browser tabs; each CLI session holds a few hundred MB.
- Stop simulators, emulators and containers when done (see [`../ai-coding`](../ai-coding)).
