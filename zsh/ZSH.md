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
| `fsh` | `~/.config/fish/config.fish` |
| `vc` | `~/.config/fish/variables.fish` |
| `ac` | `~/.config/alacritty/alacritty.toml` |
| `gc` | `~/.config/ghostty/config` |
| `kc` | `~/.config/kitty/kitty.conf` |
| `tc` | `~/.config/tmux/tmux.conf` |
| `sc` | `~/.config/starship/starship.toml` |
| `sshc` | `~/.ssh/config` |
| `vrc` | `~/.config/vim/vimrc` |
| `hyc` | `~/.config/hypr/hyprland.conf` |

Editor shortcuts resolve `$EDITOR` when invoked (default: `vim`), accept extra
arguments, and quote config paths. `EDITOR` may contain an executable and flags;
Zsh also supports quoted words within it. Bash and Fish split it on whitespace.
`fc` and `df` retain their standard meanings.

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
| `tm` | Bare `tmux` |
| `tma` | Attach to session by name |
| `tmk` | Kill the tmux server and all its sessions |
| `tc` | Open `tmux.conf` in `$EDITOR` |

---

## Session Picker

| Alias | Description |
|---|---|
| `s` | fzf picker over running tmux sessions → switch (inside tmux) or attach (outside) |

`s` is a function rather than an alias (defined in `aliases.sh`, so bash gets it
too). It is the shell twin of tmux's `prefix + s`.

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
| `bc` | Cleanup, pruning all cached downloads (`--prune=all`) |

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
| `icat` | Kitty inline image viewer |
| `fd` | `fdfind` (Debian/Ubuntu alias) |
| `rm` | `trash` (safe delete) |

`cat` is unchanged; invoke `bat` (or Debian/Ubuntu's `batcat`) explicitly for
syntax highlighting. Optional replacements are only enabled when installed.

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
| `sskg COMMENT` | Generate an Ed25519 SSH key with the supplied comment |
| `u` | Run the dotfiles setup menu (`setup.sh`); does not reload the shell |
| `c` | Copy to clipboard; checks tools and display availability when invoked, or reports an error |
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

## Functions

| Function | Description |
|---|---|
| `lg` | Lazygit wrapper — cd into the directory lazygit navigated to |

`c` and `_edit` are functions in the shared alias file, alongside `s` and its
helper `_tmux_goto`. Clipboard priority is macOS `pbcopy`, Wayland `wl-copy`,
X11 `xclip`, then WSL `clip.exe`, provided the corresponding tool is installed.

---

## Plugins (via Zinit)

| Plugin | Description |
|---|---|
| `fast-syntax-highlighting` | Syntax highlighting in the shell |
| `zsh-autosuggestions` | Fish-style inline suggestions |
| `zsh-completions` | Extra completions |
| `zsh-vi-mode` | Vi keybindings (with system clipboard) |
| `zsh-autopair` | Auto-close brackets and quotes |

---

## Tools Initialized

| Tool | Init |
|---|---|
| `zoxide` | `eval "$(zoxide init zsh)"` |
| `fzf` | Shell key bindings/completion via `fzf --zsh`, when supported |
| `atuin` | `eval "$(atuin init zsh)"` (retains Ctrl+R for history) |
| `starship` | `eval "$(starship init zsh)"` |
| `brew` | `eval "$(brew shellenv)"` *(macOS only)* |
