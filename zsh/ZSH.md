# Zsh Reference

---

## Config Files

| Alias | Opens |
|---|---|
| `zrc` | `~/.config/zsh/zshrc` |
| `zpc` | `~/.config/zsh/.zprofile` |
| `als` | `~/.config/zsh/aliases.sh` |
| `alsf` | `~/.config/fish/aliases.fish` |
| `brc` | `~/.config/bash/bashrc` |
| `fc` | `~/.config/fish/config.fish` |
| `vc` | `~/.config/fish/variables.fish` |
| `ac` | `~/.config/alacritty/alacritty.toml` |
| `gc` | `~/.config/ghostty/config` |
| `kc` | `~/.config/kitty/kitty.conf` |
| `tc` | `~/.config/tmux/tmux.conf` |
| `sc` | `~/.config/starship/starship.toml` |
| `sshc` | `~/.ssh/config` |
| `vrc` | `~/.config/vim/vimrc` |
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
| `tm` | fzf picker over `~/Projects` → session named after the project, rooted in it |
| `tma` | Attach to session by name |
| `tmn` | New window opening `$EDITOR` in current path |
| `tmk` | Kill the tmux server |
| `tmr` | Rename current session |
| `tmt` | New/attach session named after cwd |
| `tmts` | New/switch session named after cwd (switch-client if inside tmux) |

---

## Session Picker

| Alias | Description |
|---|---|
| `s` | fzf picker over running tmux sessions → switch (inside tmux) or attach (outside) |
| `Alt-s` | Same picker, bound as a ZLE widget so it works mid-prompt |

`s` and `tm` are functions rather than aliases (defined in `aliases.sh`, so bash gets
them too). `tm` reuses an existing session for the project instead of duplicating it;
override the search root with `PROJECTS_DIR`. Both are the shell twins of tmux's
`prefix + s` and `prefix + P`.

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
| `dnfi` | fzf install |
| `dnfu` | fzf uninstall |

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
| `v` | `$EDITOR` |
| `oc` | `opencode` |
| `ff` | `fastfetch` |
| `l` | `clear` |
| `r` | `reset` |
| `e` | `exit` |
| `sz` | Re-source zshrc |
| `sa` | Add SSH key to the running agent (`ssh-add`) |
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
| `starship` | `eval "$(starship init zsh)"` |
| `brew` | `eval "$(brew shellenv)"` *(macOS only)* |
