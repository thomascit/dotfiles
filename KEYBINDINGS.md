# Keybindings Reference

> All custom keybindings across the dotfiles configuration, grouped by tool.
> Source files are noted for each section.

---

## Table of Contents

- [Tmux](#tmux)
- [Neovim / Vim](#neovim--vim)
- [fzf (Shell)](#fzf-shell)
- [Zsh VI Mode](#zsh-vi-mode)
- [Fish Shell](#fish-shell)
- [Yazi](#yazi)
- [Hyprland](#hyprland)
- [Ghostty](#ghostty)
- [Vimium (Browser)](#vimium-browser)

---

## Tmux

> Source: `tmux/.config/tmux/tmux.conf`

**Prefix key:** `Ctrl+Space` (replaces default `Ctrl+b`)

### Popups

| Keybinding | Description |
|---|---|
| `<prefix> Ctrl+f` | SSH picker (fzf popup) |
| `<prefix> Ctrl+t` | Terminal popup in current path |
| `<prefix> Ctrl+v` | Open file in editor (fzf file picker) |
| `<prefix> Ctrl+s` | Session switcher (fzf popup) |
| `<prefix> Ctrl+g` | Lazygit popup |
| `<prefix> Ctrl+o` | OpenCode AI popup (`--continue`) |
| `<prefix> Ctrl+d` | New session from directory picker (fd + fzf) |

### Windows & Panes

| Keybinding | Description |
|---|---|
| `<prefix> c` | New window in current path |
| `<prefix> C` | New named window (prompts for name) |
| `<prefix> -` | Split pane vertically (current path) |
| `<prefix> _` | Split pane horizontally (current path) |
| `<prefix> t` | Split pane vertically — 25% height (current path) |
| `<prefix> o` | Split pane horizontally — 40% width, opens OpenCode |
| `<prefix> f` | New window with Yazi file manager |
| `<prefix> g` | New window with Lazygit |
| `<prefix> a` | New window with cmatrix screensaver |

### Navigation

| Keybinding | Description |
|---|---|
| `Ctrl+h` | Move to pane / Vim split left (vim-tmux-navigator) |
| `Ctrl+j` | Move to pane / Vim split down (vim-tmux-navigator) |
| `Ctrl+k` | Move to pane / Vim split up (vim-tmux-navigator) |
| `Ctrl+l` | Move to pane / Vim split right (vim-tmux-navigator) |
| `Ctrl+\` | Move to previous pane (vim-tmux-navigator) |
| `Alt+h` | Previous window (no prefix) |
| `Alt+l` | Next window (no prefix) |
| `Shift+Left` | Swap window left |
| `Shift+Right` | Swap window right |

### Resize

| Keybinding | Description |
|---|---|
| `<prefix> H` (repeatable) | Resize pane left 5 cols |
| `<prefix> J` (repeatable) | Resize pane down 5 rows |
| `<prefix> K` (repeatable) | Resize pane up 5 rows |
| `<prefix> L` (repeatable) | Resize pane right 5 cols |

### Sessions

| Keybinding | Description |
|---|---|
| `<prefix> N` | New session named after current directory |
| `<prefix> W` | Rename window to current directory |
| `<prefix> S` | Rename session to current directory |
| `<prefix> Alt+s` | Save tmux session (tmux-resurrect) |
| `<prefix> Alt+r` | Restore tmux session (tmux-resurrect) |

### Kill / Close

| Keybinding | Description |
|---|---|
| `<prefix> x` | Kill current pane (no confirmation) |
| `<prefix> &` | Kill current window (no confirmation) |

### Copy Mode (vi)

| Keybinding | Description |
|---|---|
| `<prefix> Space` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy selection |
| `r` | Toggle rectangle selection |

### Status Bar & UI

| Keybinding | Description |
|---|---|
| `<prefix> b` | Toggle status bar visibility |
| `<prefix> B` | Toggle pane border status |
| `<prefix> T` | Toggle status bar position (top ↔ bottom) |

---

## Neovim / Vim

> Sources:
> - `nvim/.config/nvim/lua/config/keymaps.lua`
> - `nvim/.config/nvim/lua/plugins/vim-tmux-navigator.lua`
> - `vim/.config/vim/vimrc`

### Insert Mode

| Keybinding | Mode | Description |
|---|---|---|
| `jk` | Insert | Exit insert mode (maps to `<Esc>`) |

### Pane / Split Navigation (vim-tmux-navigator)

Shared between Neovim and Tmux — navigate seamlessly across both.

| Keybinding | Mode | Description |
|---|---|---|
| `Ctrl+h` | Normal | Navigate left (Vim split or Tmux pane) |
| `Ctrl+j` | Normal | Navigate down |
| `Ctrl+k` | Normal | Navigate up |
| `Ctrl+l` | Normal | Navigate right |
| `Ctrl+\` | Normal | Navigate to previous pane |

### Plugin: cutlass.nvim

Separates the "cut" and "delete" operations so that `d`, `D`, `c`, `C`, `x`, `X` no longer yank to the default register. Use `m` (move) to cut explicitly. Refer to the [cutlass.nvim docs](https://github.com/gbprod/cutlass.nvim) for full details.

### LazyVim Defaults

This config is based on [LazyVim](https://www.lazyvim.org/). All default LazyVim keymaps apply unless overridden above.  
Reference: https://www.lazyvim.org/keymaps

**Key leader key:** `Space`

---

## fzf (Shell)

> Source: `zsh/.config/zsh/.zprofile`

These are the built-in fzf shell keybindings enabled via `source <(fzf --zsh)` (zsh) and `fzf --fish | source` (fish).

### Shell Triggers

| Keybinding | Description |
|---|---|
| `Ctrl+T` | Paste selected file path(s) into the command line |
| `Ctrl+R` | Search command history and paste selected entry |
| `Alt+C` | `cd` into a selected directory |

### Ctrl+T Options

| In-widget binding | Description |
|---|---|
| `Ctrl+/` | Cycle preview window position (right → down → hidden) |
| `Ctrl+E` | Open selected file in `$EDITOR` |

### fzf-powered Shell Aliases

These aliases use fzf for interactive selection:

**Homebrew (macOS)**

| Alias | Description |
|---|---|
| `bi` | Interactively install a Homebrew formula |
| `bic` | Interactively install a Homebrew cask |
| `bu` | Interactively uninstall a Homebrew formula |
| `buc` | Interactively uninstall a Homebrew cask |

**Pacman / Yay / Paru (Arch Linux)**

| Alias | Description |
|---|---|
| `pi` | Interactive `pacman` install |
| `yi` | Interactive `yay` install |
| `pri` | Interactive `paru` install |
| `pu` | Interactive `pacman` uninstall |
| `yu` | Interactive `yay` uninstall |
| `pru` | Interactive `paru` uninstall |

**APT (Debian/Ubuntu)**

| Alias | Description |
|---|---|
| `ai` | Interactive `apt` install |
| `au` | Interactive `apt` remove |

**DNF (Fedora/RHEL)**

| Alias | Description |
|---|---|
| `di` | Interactive `dnf` install |
| `du` | Interactive `dnf` remove |

---

## Zsh VI Mode

> Source: `zsh/.config/zsh/.zprofile` — via `jeffreytse/zsh-vi-mode`

| Setting | Value | Description |
|---|---|---|
| `ZVM_VI_ESCAPE_BINDKEY` | `jk` | Exit insert mode with `jk` chord |

Standard vi-mode bindings apply in both normal and insert modes. The `zsh-history-substring-search` plugin is also active.

---

## Fish Shell

> Source: `fish/.config/fish/config.fish`

Fish uses `fish_vi_key_bindings` (VI mode enabled).

| Keybinding | Mode | Description |
|---|---|---|
| `jk` | Insert | Exit insert mode (cancel or switch to normal mode) |
| `Ctrl+P` | Insert | Paste from system clipboard |
| `p` | Normal | Paste from system clipboard |

**fzf bindings** (via `fzf --fish`): same as [fzf Shell](#fzf-shell) above (`Ctrl+T`, `Ctrl+R`, `Alt+C`).

---

## Yazi

> Source: `yazi/.config/yazi/keymap.toml`

These prepend (override with higher priority) the default Yazi keymaps.

| Keybinding | Description |
|---|---|
| `m` | Trigger relative motion (plugin: `relative-motions`) |
| `l` | Smart enter — open file or enter directory |
| `p` | Smart paste — paste into hovered directory or CWD |
| `!` | Open `$SHELL` (or PowerShell on Windows) in current directory |
| `T P` | Toggle preview pane (minimize/restore) |
| `T p` | Maximize or restore preview pane |
| `t t` | Create a new tab and enter hovered directory |
| `2` | Switch to or create tab 2 |

---

## Hyprland

> Source: `hypr/.config/hypr/hyprland.conf`

**Modifier key:** `Super` (Windows/Meta key)

### Applications

| Keybinding | Description |
|---|---|
| `Super+Shift+T` | Launch terminal (kitty) |
| `Super+Shift+B` | Launch browser (chromium) |
| `Super+Shift+F` | Launch file manager (nemo) |
| `Super+Space` | Toggle app launcher (Noctalia) |
| `Super+S` | Toggle control center (Noctalia) |
| `Super+,` | Toggle settings (Noctalia) |

### Window Management

| Keybinding | Description |
|---|---|
| `Super+Shift+Q` | Close active window |
| `Super+Shift+E` | Exit Hyprland |
| `Super+Shift+Space` | Toggle floating mode |
| `Super+F` | Toggle fullscreen |
| `Super+P` | Toggle pseudotile (dwindle) |
| `Super+V` | Toggle split direction (dwindle) |

### Focus

| Keybinding | Description |
|---|---|
| `Super+H` | Move focus left |
| `Super+L` | Move focus right |
| `Super+K` | Move focus up |
| `Super+J` | Move focus down |

### Move Windows

| Keybinding | Description |
|---|---|
| `Super+Shift+H` | Move window left |
| `Super+Shift+L` | Move window right |
| `Super+Shift+J` | Move window down |
| `Super+Shift+K` | Move window up |
| `Super+LMB drag` | Move window with mouse |
| `Super+RMB drag` | Resize window with mouse |

### Workspaces

| Keybinding | Description |
|---|---|
| `Super+1` … `Super+0` | Switch to workspace 1–10 |
| `Super+Shift+1` … `Super+Shift+0` | Move active window to workspace 1–10 |
| `Super+S` | Toggle special workspace (scratchpad) |
| `Super+Shift+S` | Move window to special workspace |
| `Super+ScrollDown` | Next workspace |
| `Super+ScrollUp` | Previous workspace |

### Touchpad Gestures

| Gesture | Description |
|---|---|
| 3-finger swipe left/right | Switch workspace |
| 3-finger swipe up | Fullscreen |
| 3-finger swipe down | Fullscreen (toggle off) |

### Media & System Keys

| Keybinding | Description |
|---|---|
| `XF86AudioRaiseVolume` | Increase volume |
| `XF86AudioLowerVolume` | Decrease volume |
| `XF86AudioMute` | Mute audio output |
| `XF86AudioNext` | Next track (playerctl) |
| `XF86AudioPrev` | Previous track (playerctl) |
| `XF86AudioPlay/Pause` | Play/pause (playerctl) |
| `XF86MonBrightnessUp` | Increase screen brightness |
| `XF86MonBrightnessDown` | Decrease screen brightness |
| `Super+XF86MonBrightnessUp` | Increase keyboard backlight +20% |
| `Super+XF86MonBrightnessDown` | Decrease keyboard backlight -20% |

---

## Ghostty

> Source: `ghostty/.config/ghostty/config`

No custom keybindings configured. All bindings are Ghostty defaults. See [Ghostty docs](https://ghostty.org/docs/config/keybind) for reference.

---

## Vimium (Browser)

> Source: `reference/vimium/vimium-options.json`

Custom mappings on top of Vimium defaults:

| Keybinding | Description |
|---|---|
| `K` | Go to previous tab |
| `J` | Go to next tab |

### Custom Search Engines

| Shortcut | Engine |
|---|---|
| `w` | Wikipedia |
| `g` | Google |
| `gm` | Google Maps |
| `y` | YouTube |
| `az` | Amazon |
| `i` | IMDb |
| `p` | PyPI |
| `r` | Reddit |
| `aw` | ArchWiki |
| `gh` | GitHub |

All standard Vimium keybindings apply. See [Vimium docs](https://vimium.github.io/) for the full default keymap.

---

*Last updated: 2026-03-15*
