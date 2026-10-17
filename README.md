# MacOS-Setup

Script to setup my Macbook with M-series chip, optimized for performance, RAM usage, and AI Coding.

## Quick start

```sh
git clone https://github.com/ptrinh/MacOS-Setup.git && cd MacOS-Setup
./setup.sh --sudo                 # everything; or run each folder's script on its own
./performance/cleanup.sh --yes    # free SSD space any time
```

`setup.sh` runs: install-apps → zsh-setup → ai-coding → macos-defaults → performance → charge-by-location. Every step is safe to re-run; a failed step doesn't stop the others. Options `--hostname NAME` and `--login-message TEXT` go to macos-defaults.

| Folder | Description |
|---|---|
| [`charge-by-location`](charge-by-location/) | Auto-switch the charge limit between 80% / 100% based on location (router) |
| [`macos-defaults`](macos-defaults/) | Curated `defaults write` settings for Finder, Dock, keyboard, trackpad and apps |
| [`install-apps`](install-apps/) | New Mac setup: Rosetta, Homebrew, apps from a Brewfile |
| [`zsh-setup`](zsh-setup/) | zsh config, Starship prompt, autosuggestions/highlighting, font, iTerm2 and Terminal profiles |
| [`performance`](performance/) | Staggered login, fewer background services, lower RAM/GPU use, power settings, SSD cleanup |
| [`ai-coding`](ai-coding/) | Claude Code, `cpu-gate.sh`, resource rules for agents in `~/.claude/CLAUDE.md` |
