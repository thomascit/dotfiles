# Zsh Reference

---

## Config Files

| Alias | Opens |
|---|---|
| `zrc` | `~/.config/zsh/zshrc` |
| `als` | `~/.config/zsh/aliases.*` |
| `brc` | `~/.config/bash/bashrc` |
| `fc` | `~/.config/fish/config.fish` |
| `ac` | `~/.config/alacritty/alacritty.toml` |
| `gc` | `~/.config/ghostty/config` |
| `kc` | `~/.config/kitty/kitty.conf` |
| `tc` | `~/.config/tmux/tmux.conf` |
| `sc` | `~/.config/starship/starship.toml` |
| `sshc` | `~/.ssh/config` |
| `vrc` | `~/.config/vim/vimrc` |
| `nvrc` | `~/.config/nvim` (yazi) |
| `yc` | `~/.config/yazi/yazi.toml` |
| `hyc` | `~/.config/hypr/hyprland.conf` |
| `df` | `~/.config` (yazi) |

---

## Git

| Alias | Command |
|---|---|
| `ga` | `git add` |
| `gb` | `git branch` |
| `gcm` | `git commit` |
| `gco` | `git checkout` |
| `gd` | `git diff` |
| `gl` | `git log --oneline --graph` |
| `gp` | `git push` |
| `gs` | `git status` |

---

## Tmux

| Alias | Description |
|---|---|
| `t` | fzf through existing sessions → attach or switch |
| `ta` | Attach to session by name |
| `tn` | New window opening `$EDITOR` in current path |
| `tr` | Rename current session |
| `tt` | New/attach session named after cwd |
| `tts` | New/switch session named after cwd (switch-client if inside tmux) |

---

## Package Managers

### Homebrew (macOS)

| Alias | Description |
|---|---|
| `bi` | fzf install formula |
| `bic` | fzf install cask |
| `bu` | fzf uninstall formula |
| `buc` | fzf uninstall cask |
| `bup` | Update + upgrade all |
| `ba` | Autoremove |
| `bc` | Cleanup |

### Pacman / Yay / Paru (Arch)

| Alias | Description |
|---|---|
| `pi` | fzf install (pacman) |
| `yi` | fzf install (yay) |
| `pri` | fzf install (paru) |
| `pu` | fzf uninstall (pacman) |
| `yu` | fzf uninstall (yay) |
| `pru` | fzf uninstall (paru) |

### APT (Debian/Ubuntu)

| Alias | Description |
|---|---|
| `ai` | fzf install |
| `au` | fzf uninstall |

### DNF (Fedora/RHEL)

| Alias | Description |
|---|---|
| `di` | fzf install |
| `du` | fzf uninstall |

---

## Files & Navigation

| Alias | Description |
|---|---|
| `ls` | `eza` with icons, git info, long format |
| `lst` | `eza` tree view |
| `cat` | `bat` (syntax-highlighted cat) |
| `icat` | Kitty inline image viewer |
| `fd` | `fdfind` (Debian/Ubuntu alias) |
| `rm` | `trash` (safe delete) |
| `y` | Yazi file manager (cd on exit) |

---

## Terminal

| Alias | Description |
|---|---|
| `n` | `$EDITOR .` — open editor in cwd |
| `oc` | `opencode` |
| `ff` | `fastfetch` |
| `l` | `clear` |
| `r` | `reset` |
| `e` | `exit` |
| `sz` | Re-source zshrc |
| `u` | Run `setup.sh` (reload/install dotfiles) |
| `c` | Copy to clipboard (OS-aware: `wl-copy` / `pbcopy` / `clip.exe` / `xclip`) |
| `bashc` | Clear + launch bash |
| `fishc` | Clear + launch fish |
| `zshc` | Clear + launch zsh |

---

## Docker

| Alias | Description |
|---|---|
| `ld` | `lazydocker` |
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcl` | `docker compose logs -f --tail=100` |
| `dcb` | `docker compose build --no-cache` |

---

## Pomodoro

| Alias | Description |
|---|---|
| `p50` | 50m work → 10m rest |
| `p20` | 20m work → 10m rest |

---

## Functions

| Function | Description |
|---|---|
| `y` | Yazi wrapper — cd into the directory you quit from |
| `lg` | Lazygit wrapper — cd into the directory lazygit navigated to |
| `work [duration]` | Start a work timer (default `20m`), notify on completion |
| `rest [duration]` | Start a break timer (default `5m`), notify on completion |

---

## Plugins (via Zinit)

| Plugin | Description |
|---|---|
| `fast-syntax-highlighting` | Syntax highlighting in the shell |
| `zsh-autosuggestions` | Fish-style inline suggestions |
| `zsh-history-substring-search` | History search by substring |
| `zsh-completions` | Extra completions |
| `zsh-vi-mode` | Vi keybindings (with system clipboard) |
| `zsh-autopair` | Auto-close brackets and quotes |

---

## Tools Initialized

| Tool | Init |
|---|---|
| `zoxide` | `eval "$(zoxide init zsh)"` |
| `fzf` | `source <(fzf --zsh)` |
| `starship` | `eval "$(starship init zsh)"` |
| `brew` | `eval "$(brew shellenv)"` *(macOS only)* |
