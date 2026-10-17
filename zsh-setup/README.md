# zsh-setup

Shell and terminal setup:

- **zsh**: history sharing, Cmd/Option + arrow key bindings, aliases, fast `compinit` (rebuilt once a day), menu completion with case-insensitive matching, Homebrew completions, extra completions from `~/.zsh/completions`
- **zsh-autosuggestions** (grey suggestion from history, → to accept) and **zsh-syntax-highlighting**
- **[Starship](https://starship.rs) prompt** ([`starship.toml`](starship.toml)): short path, git branch/status, user/host only over SSH, slow modules disabled
- **Font**: [SourceCodePro+Powerline+Awesome](https://github.com/gabrielelana/awesome-terminal-fonts) (checksum-verified)
- **iTerm2**: the profile from the current Mac ([`iterm2-profile.json`](iterm2-profile.json), separate light/dark colors, font 16 pt, key mappings) installed as a Dynamic Profile and made the default
- **Terminal**: the customized *Clear Dark* profile ([`Clear Dark.terminal`](Clear%20Dark.terminal)) set as the default

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
