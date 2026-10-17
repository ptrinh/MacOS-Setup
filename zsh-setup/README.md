# zsh-setup

Shell and terminal setup:

- **zsh**: history sharing, Cmd/Option + arrow key bindings, aliases, fast `compinit` (rebuilt once a day), menu completion with case-insensitive matching, Homebrew completions, extra completions from `~/.zsh/completions`
- **fzf**: Ctrl+R fuzzy history search, Ctrl+T insert a file path, Alt+C cd into a folder
- **zoxide**: `z part-of-name` jumps to a frequently used folder, `zi` picks one interactively
- **zsh-autosuggestions** (grey suggestion from history, → to accept) and **zsh-syntax-highlighting**
- **[Starship](https://starship.rs) prompt** ([`starship.toml`](starship.toml)): short path, git branch/status, user/host only over SSH, slow modules disabled
- **Font**: [SourceCodePro+Powerline+Awesome](https://github.com/gabrielelana/awesome-terminal-fonts) (checksum-verified)
- **iTerm2**: the profile from the current Mac ([`iterm2-profile.json`](iterm2-profile.json), separate light/dark colors, font 16 pt, key mappings) installed as a Dynamic Profile and made the default
- **[Ghostty](https://ghostty.org)** ([`ghostty/`](ghostty/)): same colors (light/dark themes converted from the iTerm2 profile), font and Cmd/Option line-editing keys
- **Terminal**: the customized *Clear Dark* profile ([`Clear Dark.terminal`](Clear%20Dark.terminal)) set as the default

## Performance

Measured on an M-series Mac with macOS 27: interactive shell startup ~50 ms (40 ms without fzf and zoxide), Starship prompt 10-20 ms inside a git repo. No plugin manager: plugins come from Homebrew and are sourced directly.

iTerm2 vs Ghostty RAM is roughly a wash (Ghostty 1 window ~120 MB, iTerm2 1 window/10 tabs ~135 MB). Ghostty's gain is native UI and GPU rendering latency; iTerm2 keeps features like tmux integration, triggers and its Claude Code status utility.

## Usage

Needs Homebrew (run [`../install-apps`](../install-apps) first).

```sh
./install.sh
```

Existing `~/.zshrc` and `~/.config/starship.toml` are backed up (`*.bak-<timestamp>`) if they differ. Put machine-specific settings and secrets (API keys, tool PATHs added by installers such as bun or OrbStack) in `~/.zshrc.local`, which `~/.zshrc` sources last.

## Update from the current Mac

After changing the iTerm2 or Terminal profile, re-export:

```sh
# iTerm2: Settings > Profiles > Other Actions > Save Profile as JSON, then keep Name/Guid as in iterm2-profile.json
# Terminal: Settings > Profiles > Clear Dark > ⋯ > Export, save over "Clear Dark.terminal"
```
