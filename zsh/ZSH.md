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

### APT (Debian/Ubuntu servers)

| Alias | Description |
|---|---|
| `ai` | fzf install |
| `au` | fzf uninstall |

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
| `saf [URL\|FILE]` | Open in Safari (macOS); bare domains get `https://` prepended |
| `ff` | `fastfetch` |
| `l` | `clear` |
| `r` | `reset` |
| `e` | `exit` |
| `sz` | Re-source zshrc |
| `sa` | Add SSH key to the running agent (`ssh-add`) |
| `sskg COMMENT` | Generate an Ed25519 SSH key with the supplied comment |
| `u` | Run the dotfiles setup menu (`setup.sh`); does not reload the shell |
| `c [FILE]` | Copy stdin or FILE to the clipboard — `pbcopy` on macOS, OSC 52 over SSH |
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
helper `_tmux_goto`. On macOS `c` uses `pbcopy`. Anywhere else (a Linux
server over SSH) it emits an OSC 52 escape sequence, which asks your *local*
terminal to set its clipboard — no display, X forwarding or `xclip` needed.
tmux passes it through (`set-clipboard on`). Payloads are capped by the
terminal, typically around 100 KB.

---

## Plugins (via Zinit)

| Plugin | Description |
|---|---|
| `fast-syntax-highlighting` | Syntax highlighting in the shell |
| `zsh-autosuggestions` | Fish-style inline suggestions |
| `zsh-completions` | Extra completions |
| `zsh-vi-mode` | Vi keybindings (with system clipboard). `ZVM_INIT_MODE=sourcing` so it binds at load time instead of the first prompt — otherwise it overwrites the fzf/atuin keys |
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
