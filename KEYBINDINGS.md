# Keybindings Reference

> All custom keybindings across the dotfiles configuration, grouped by tool.
> Source files are noted for each section.

---

## Table of Contents

- [Tmux](#tmux)
- [Neovim / Vim](#neovim--vim)
- [fzf (Shell Aliases)](#fzf-shell-aliases)
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
| `<prefix> s` | Session picker — fzf over running sessions (`C-x` kills, windows in preview) |
| `<prefix> P` | Project picker — fzf `~/Projects` → session named after the project |
| `<prefix> S` | SSH host picker (fzf popup from `~/.ssh/config`) |
| `<prefix> r` | Run command (prompts, runs in new window) |
| `<prefix> C-c` | Config file picker (`~/.config`, bat preview) |
| `<prefix> R` | Reload `~/.config/tmux/tmux.conf` (confirms in the status line) |
| `<prefix> ?` | Key bindings reference popup |

### New Windows

| Keybinding | Description |
|---|---|
| `<prefix> c` | New window in current path |
| `<prefix> C` | New named window (prompts for name) |
| `<prefix> N` | New window with `$EDITOR` (defaults to `vim`) |
| `<prefix> V` | New window with `$EDITOR` (same as `N`, alternate key) |
| `<prefix> O` | New window with OpenCode — fresh session (`<prefix> o` is the one that continues) |
| `<prefix> f` | New window with Yazi file manager |
| `<prefix> g` | New window with Lazygit |
| `<prefix> p` | New window with btop (`sudo btop`) |
| `<prefix> a` | New window with cmatrix screensaver |

### Pane Splits

"Horizontal" and "Vertical" describe the orientation of the divider, matching the
wording in the `<prefix> ?` popup.

| Keybinding | Description |
|---|---|
| `<prefix> -` | Split pane horizontally (current path) |
| `<prefix> _` | Split pane vertically (current path) |
| `<prefix> v` | Split pane vertically — left, 60% width, opens `$EDITOR` |
| `<prefix> o` | Split pane vertically — 40% width, opens `opencode --continue` |
| `<prefix> t` | Split pane horizontally — 25% height (current path) |
| `<prefix> m` | Split pane horizontally — 10% height (current path) |

### Navigation

| Keybinding | Description |
|---|---|
| `Ctrl+h` | Move to pane / Vim split left (vim-tmux-navigator) |
| `Ctrl+j` | Move to pane / Vim split down (vim-tmux-navigator) |
| `Ctrl+k` | Move to pane / Vim split up (vim-tmux-navigator) |
| `Ctrl+l` | Move to pane / Vim split right (vim-tmux-navigator) |
| `Ctrl+\` | Move to previous pane (vim-tmux-navigator) |
| `<prefix> w` | Window switcher — fzf popup over the current session's windows |
| `Alt+h` | Previous window (no prefix) |
| `Alt+l` | Next window (no prefix) |
| `Shift+Left` | Swap window left |
| `Shift+Right` | Swap window right |
| `<prefix> C-o` | Rotate window (tmux default, restated explicitly — the project picker used to live here) |

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
| `<prefix> s` | Session picker (fzf popup — see [Popups](#popups)) |
| `<prefix> $` | Rename session (tmux built-in) |

### Rename

| Keybinding | Description |
|---|---|
| `<prefix> C-w` | Rename window to current directory |
| `<prefix> C-s` | Rename session to current directory |

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
| `y` | Copy selection (yank) |
| `r` | Toggle rectangle selection |

### Status Bar & UI

| Keybinding | Description |
|---|---|
| `<prefix> b` | Toggle status bar visibility |
| `<prefix> B` | Toggle pane border status |
| `<prefix> T` | Toggle status bar position (top ↔ bottom) |

### Session Persistence (tmux-resurrect — requires TPM)

Only available where TPM is installed, and bound in the **prefix** table.

| Keybinding | Description |
|---|---|
| `<prefix> Alt+s` | Save tmux session |
| `<prefix> Alt+r` | Restore tmux session |

---

## Neovim / Vim

> **Neovim is discontinued.** The Neovim keymaps below describe the retired
> config still kept under `nvim/` for reference — it is no longer stowed or
> maintained, and `vim` is now the default editor. The live source for the
> editor in use is `vim/.config/vim/vimrc`.

> Sources:
> - `nvim/.config/nvim/lua/config/keymaps.lua`
> - `nvim/.config/nvim/lua/plugins/vim-tmux-navigator.lua`
> - `nvim/.config/nvim/lua/plugins/telescope.lua`
> - `nvim/.config/nvim/lua/plugins/flash.lua`
> - `nvim/.config/nvim/lua/plugins/yazi.lua`
> - `nvim/.config/nvim/lua/plugins/trouble.lua`
> - `nvim/.config/nvim/lua/plugins/todo-comments.lua`
> - `nvim/.config/nvim/lua/plugins/grug-far.lua`
> - `nvim/.config/nvim/lua/plugins/neo-tree.lua`
> - `nvim/.config/nvim/lua/plugins/which-key.lua`
> - `nvim/.config/nvim/lua/plugins/cutlass.lua`
> - `vim/.config/vim/vimrc`

**Leader key:** `Space`

### General

The rows below exist in **both** `vim` and `nvim` except where noted.

| Keybinding | Mode | Description |
|---|---|---|
| `jk` | Insert | Exit insert mode |
| `Ctrl+s` | Insert / Normal / Visual | Save file (vim: Insert / Normal only) |
| `<leader>qq` | Normal | Quit all |
| `<leader>l` | Normal | Open Lazy plugin manager (**nvim only** — vim uses vim-plug) |
| `<leader>fn` | Normal | New file |
| `<Esc>` | Normal | Clear search highlight |
| `H` / `L` | Normal | Previous / next buffer |
| `Ctrl+q` | Normal | Delete buffer |
| `Ctrl+d` / `Ctrl+u` | Normal | Half-page scroll, cursor centred |
| `n` / `N` | Normal | Next / previous search result, centred |
| `y` | Visual | Yank, keeping the selection highlighted |

### Pane / Split Navigation (vim-tmux-navigator)

Shared between Neovim and Tmux — navigate seamlessly across both.

| Keybinding | Mode | Description |
|---|---|---|
| `Ctrl+h` | Normal | Navigate left (Vim split or Tmux pane) |
| `Ctrl+j` | Normal | Navigate down |
| `Ctrl+k` | Normal | Navigate up |
| `Ctrl+l` | Normal | Navigate right |
| `Ctrl+\` | Normal | Navigate to previous pane |

### Toggle

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>tw` | Normal | Toggle line wrap |
| `<leader>tc` | Normal | Toggle 80-column colorcolumn |

### Git (Snacks)

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>gg` | Normal | Lazygit (root dir) |
| `<leader>gG` | Normal | Lazygit (cwd) |
| `<leader>gl` | Normal | Git log |
| `<leader>gL` | Normal | Git log (cwd) |
| `<leader>gb` | Normal | Git blame line |
| `<leader>gf` | Normal | Current file git history |
| `<leader>gB` | Normal / Visual | Git browse (open in browser) |
| `<leader>gY` | Normal / Visual | Git browse (copy URL) |

### Telescope (File/Find)

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fr` | Normal | Recent files |
| `<leader>f:` | Normal | Commands |
| `<leader>fd` | Normal | Diagnostics |
| `<leader>fs` | Normal | Document symbols (LSP) |
| `<leader>f/` | Normal | Fuzzy find in current buffer |
| `<leader>fp` | Normal | Find files in `~/Projects` |
| `<leader>fP` | Normal | Live grep in `~/Projects` |
| `<leader>fc` | Normal | Find files in `~/.config` |
| `<leader>fC` | Normal | Live grep in `~/.config` |

### Flash (Motion)

| Keybinding | Mode | Description |
|---|---|---|
| `s` | Normal / Visual / Operator | Flash jump |
| `S` | Normal / Visual / Operator | Flash treesitter |
| `r` | Operator | Remote flash |
| `R` | Operator / Visual | Treesitter search |
| `Ctrl+s` | Command | Toggle flash search |

### Neo-tree (File Explorer)

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>ee` | Normal | Toggle Neo-tree explorer |
| `<leader>ec` | Normal | Open ~/.config in Neo-tree |
| `<leader>en` | Normal | Open Neovim config in Neo-tree |
| `<leader>fe` | Normal | Reveal current file in explorer |

### Yazi (File Manager)

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>yy` | Normal / Visual | Open Yazi at current file |
| `<leader>yw` | Normal | Open Yazi in Neovim's cwd |
| `<leader>yc` | Normal | Open Yazi in `~/.config` (dotfiles) |
| `<leader>yr` | Normal | Resume last Yazi session |
| `F1` | in Yazi | Show Yazi help |

### Trouble (Diagnostics)

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>xx` | Normal | Toggle diagnostics (Trouble) |
| `<leader>xX` | Normal | Toggle buffer diagnostics (Trouble) |
| `<leader>cs` | Normal | Symbols (Trouble) |
| `<leader>cS` | Normal | LSP references/definitions (Trouble) |
| `<leader>xL` | Normal | Location list (Trouble) |
| `<leader>xQ` | Normal | Quickfix list (Trouble) |
| `[q` | Normal | Previous trouble/quickfix item |
| `]q` | Normal | Next trouble/quickfix item |

### Todo Comments

| Keybinding | Mode | Description |
|---|---|---|
| `]t` | Normal | Next TODO comment |
| `[t` | Normal | Previous TODO comment |
| `<leader>xt` | Normal | Todo list (Trouble) |
| `<leader>xT` | Normal | Todo/Fix/Fixme (Trouble) |
| `<leader>st` | Normal | Todo (Telescope) |
| `<leader>sT` | Normal | Todo/Fix/Fixme (Telescope) |

### Search & Replace

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>sr` | Normal / Visual | Search and replace (grug-far) |

### Which-Key

| Keybinding | Mode | Description |
|---|---|---|
| `<leader>?` | Normal | Show buffer keymaps (which-key) |
| `Ctrl+w Space` | Normal | Window hydra mode (which-key) |

### Plugin: cutlass.nvim

Separates "cut" and "delete": `d`, `D`, `c`, `C`, `x`, `X`, `s`, `S` no longer yank to
the default register. Overrides are skipped for any key already mapped, which is why
flash.nvim keeps `s`/`S`.

The plugin is configured with `opts = {}`, so `cut_key` is unset and **there is no
explicit cut key** — use `"+y` style registers instead. See
[cutlass.nvim docs](https://github.com/gbprod/cutlass.nvim).

### Not LazyVim

Despite the leftover `README.md` and `lazyvim.json` in `nvim/.config/nvim/`, this config
is **plain lazy.nvim** — `lua/config/lazy.lua` imports only `lua/plugins/`, and there is
no `LazyVim` entry in `lazy-lock.json`. No LazyVim default keymaps apply.

Two keymaps are stale fallout from this: `<leader>gg` and `<leader>gl` call
`LazyVim.root.git()` in `keymaps.lua`, which is a nil global here, so both error.

### Undocumented keymaps

The tables above cover `config/keymaps.lua` and the plugins listed under Sources. Several
plugin files define keymaps that are **not** listed here — `gitsigns.lua` (`]h`, `[h`,
`<leader>gh*`), `lsp.lua` (`gd`, `gr`, `K`, `<leader>ca`, …), `opencode.lua`
(`<leader>o*`), `persistence.lua` (`<leader>q[sSld]`), `conform.lua`, `mason.lua`,
`snacks.lua`. Read the file directly for those.

---

## fzf (Shell Aliases)

> Source: `zsh/.config/zsh/aliases.sh`, `fish/.config/fish/aliases.fish`

fzf's built-in shell integration (`Ctrl+T` / `Ctrl+R` / `Alt+C`) is deliberately
not enabled — those are covered by `atuin` (history), `zoxide` (`z`) and `yazi`
(`y`) instead. `Ctrl+R` falls through to atuin, or to the shell's builtin
reverse-search where atuin is unavailable.

fzf itself is still used heavily for the aliases below, the tmux popups, and the
`s` session picker. Theming for all of those comes from `FZF_DEFAULT_OPTS`.

### fzf-powered Shell Aliases

These aliases use fzf for interactive selection:

**Tmux sessions**

| Alias | Description |
|---|---|
| `tmp` | Pick a project under `~/Projects` (`$PROJECTS_DIR`) → session named after it, rooted in it |
| `s` | Pick a running session → `switch-client` inside tmux, `attach-session` outside |

`tmp` and `s` are shell **functions**, not aliases, so bash gets them too via
`aliases.sh`. `FZF_DEFAULT_OPTS` / `FZF_DEFAULT_COMMAND` are set in
`zsh/.config/zsh/.zprofile`, `bash/.config/bash/bashrc` and
`fish/.config/fish/variables.fish`.

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
| `dnfi` | Interactive `dnf` install |
| `dnfu` | Interactive `dnf` remove |

---

## Zsh VI Mode

> Source: `zsh/.config/zsh/.zprofile` — via `jeffreytse/zsh-vi-mode`

| Setting | Value | Description |
|---|---|---|
| `ZVM_VI_ESCAPE_BINDKEY` | `jk` | Exit insert mode with `jk` chord |
| `ZVM_SYSTEM_CLIPBOARD_ENABLED` | `true` | System clipboard integration |

Standard vi-mode bindings apply in both normal and insert modes.

Plugins loaded via Zinit (`zsh/.config/zsh/zshrc`): `fast-syntax-highlighting`,
`zsh-autosuggestions`, `zsh-completions`, `zsh-vi-mode`, `zsh-autopair`.

Clipboard commands for vi-mode yank/paste are set per-OS in `.zprofile`
(`pbcopy` on macOS, `clip.exe` on WSL, `wl-copy` on Wayland, `xclip` otherwise).

---

## Fish Shell

> Sources: `fish/.config/fish/config.fish`,
> `fish/.config/fish/conf.d/fish_frozen_key_bindings.fish`

Fish uses `fish_vi_key_bindings` (VI mode enabled).

| Keybinding | Mode | Description |
|---|---|---|
| `jk` | Insert | Exit insert mode (cancel the pager, or switch to normal mode) |
| `Ctrl+P` | Insert | Paste from system clipboard |
| `p` | Normal | Paste from system clipboard (overrides vi-mode's killring paste) |
| `Ctrl+R` | Insert / Normal | Atuin history search |
| `Up` | Insert / Normal | Atuin up-binding (history, then line navigation) |

Cursor shape follows the vi mode: block in normal/visual, line in insert,
underscore in replace.

---

## Yazi

> Source: `yazi/.config/yazi/keymap.toml`

These prepend (override with higher priority) the default Yazi keymaps.

| Keybinding | Description |
|---|---|
| `m` | Trigger relative motion (plugin: `relative-motions`) |
| `p` | Smart paste — paste into hovered directory or CWD |
| `!` | Open `$SHELL` (or PowerShell on Windows) in current directory |
| `L` | Maximize or restore preview pane (plugin: `toggle-pane max-preview`) |
| `g i` | Open lazygit in the current directory (plugin: `lazygit`) |
| `1` … `9` | Switch to tab *n*, creating it (and revealing the hovered dir) if absent |

Tab switching uses the local `smart-switch` plugin
(`yazi/.config/yazi/plugins/smart-switch.yazi/`), which takes a 0-based index —
so `1` runs `smart-switch 0`. There is no `0` binding, meaning a tenth tab is
not reachable this way.

The `smart-enter` plugin is still installed and loaded in `init.lua`, but nothing
is bound to it — `l` uses Yazi's built-in enter.

---

## Hyprland

> Source: `hypr/.config/hypr/hyprland.conf`

**Modifier key:** `Super` (Windows/Meta key)

### Applications

| Keybinding | Description |
|---|---|
| `Super+Shift+T` | Launch terminal (kitty) |
| `Super+Shift+B` | Launch browser (firefox) |
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
| `Super+Tab` | Toggle special workspace (scratchpad) |
| `Super+Shift+S` | Move window to special workspace |
| `Super+ScrollDown` | Next workspace |
| `Super+ScrollUp` | Previous workspace |

> The scratchpad toggle is on `Super+Tab`, not the stock `Super+S`, because
> `Super+S` is taken by the Noctalia control center. Hyprland does not
> deduplicate binds, so leaving both would fire both dispatchers on one press.

### Touchpad Gestures

| Gesture | Description |
|---|---|
| 3-finger swipe left/right | Switch workspace |
| 3-finger swipe up | Fullscreen |
| 3-finger swipe down | Fullscreen (toggle off) |

### Media & System Keys

| Keybinding | Description |
|---|---|
| `XF86AudioRaiseVolume` | Increase volume (Noctalia IPC) |
| `XF86AudioLowerVolume` | Decrease volume (Noctalia IPC) |
| `XF86AudioMute` | Mute audio output (Noctalia IPC) |
| `XF86AudioNext` | Next track (playerctl) |
| `XF86AudioPrev` | Previous track (playerctl) |
| `XF86AudioPlay/Pause` | Play/pause (playerctl) |
| `XF86MonBrightnessUp` | Increase screen brightness (Noctalia IPC) |
| `XF86MonBrightnessDown` | Decrease screen brightness (Noctalia IPC) |
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
| `K` | Previous tab |
| `J` | Next tab |

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

*Last updated: 2026-08-31*
