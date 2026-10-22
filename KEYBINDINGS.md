# Keybindings Reference

> All custom keybindings across the dotfiles configuration, grouped by tool.
> Source files are noted for each section.

---

## Table of Contents

- [Tmux](#tmux)
- [Vim](#vim)
- [fzf (Shell Aliases)](#fzf-shell-aliases)
- [Zsh VI Mode](#zsh-vi-mode)
- [Fish Shell](#fish-shell)
- [Ranger](#ranger)
- [Ghostty](#ghostty)
- [Vimium (Browser)](#vimium-browser)

---

## Tmux

> Source: `tmux/.config/tmux/tmux.conf`

**Prefix key:** `Ctrl+Space` (replaces default `Ctrl+b`)

### Popups

| Keybinding | Description |
|---|---|
| `<prefix> s` | Session picker — fzf over running sessions (`C-x` kills) |
| `<prefix> S` | SSH host picker (fzf popup from `~/.ssh/config`) |
| `<prefix> r` | Run command (prompts, runs in new window) |
| `<prefix> e` | Replace the **active pane's** program with a command (e.g. lazygit → `opencode`). Other panes and the layout are untouched; the pane drops to a shell when the command exits. Empty Enter or `Ctrl+C` cancels |
| `<prefix> C` | Config file picker (`~/.config`) |
| `<prefix> R` | Reload `~/.config/tmux/tmux.conf` (confirms in the status line) |
| `<prefix> ?` | Key bindings reference popup |

### New Windows

| Keybinding | Description |
|---|---|
| `<prefix> c` | New window in current path |
| `<prefix> v` | New window with `$EDITOR` (defaults to `vim`) |
| `<prefix> o` | New window with OpenCode — fresh session |
| `<prefix> f` | New window with Ranger file manager |
| `<prefix> g` | New window with Lazygit |
| `<prefix> p` | New window with btop |
| `<prefix> a` | New window with cmatrix screensaver |

### Pane Splits

"Horizontal" and "Vertical" describe the orientation of the divider, matching the
wording in the `<prefix> ?` popup.

| Keybinding | Description |
|---|---|
| `<prefix> -` | Split pane horizontally (current path) |
| `<prefix> _` | Split pane vertically (current path) |
| `<prefix> t` | Split pane horizontally — 25% height (current path) |
| `<prefix> m` | Split pane horizontally — 10% height (current path) |
| `<prefix> Ctrl+l` | Clear screen (sends `Ctrl+l` to the pane; bare `Ctrl+l` navigates) |

### Navigation

| Keybinding | Description |
|---|---|
| `Ctrl+h` | Move to pane / Vim split left (vim-tmux-navigator) |
| `Ctrl+j` | Move to pane / Vim split down (vim-tmux-navigator) |
| `Ctrl+k` | Move to pane / Vim split up (vim-tmux-navigator) |
| `Ctrl+l` | Move to pane / Vim split right (vim-tmux-navigator) |
| `Ctrl+\` | Move to previous pane (vim-tmux-navigator) |
| `<prefix> w` | Window switcher — fzf popup over the current session's windows |
| `Alt+h` | Previous window (no prefix; on macOS, Option acts as Alt in Ghostty, kitty and Alacritty) |
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

### Rename

| Keybinding | Description |
|---|---|
| `<prefix> ,` / `<prefix> W` | Rename current window (prompt prefilled with the current name; an explicit name pins it, other windows keep automatic naming) |
| `<prefix> P` | Rename current pane — sets the pane **title** (`select-pane -T`). Not shown by default: the pane border displays the running command and is hidden until `<prefix> B` |

### Sessions

Use `<prefix> s` to pick a session (see [Popups](#popups)). Sessions use numeric
names starting at 1; window names follow the running command.

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

## Vim

> Source: `vim/.config/vim/vimrc`

**Leader key:** `Space`

Pause after pressing Space to show vim-which-key's guide to the available
leader mappings; quick key sequences still run normally. The delay is 500 ms
(`timeoutlen`, which also affects other mappings such as `jk`). `set showcmd`
also shows keys as you type them.

### General

| Keybinding | Mode | Description |
|---|---|---|
| `jk` | Insert | Exit insert mode |
| `Ctrl+s` | Insert / Normal | Save file (Insert keeps the cursor in place) |
| `<leader>qq` | Normal | Quit all |
| `<leader>fn` | Normal | New file |
| `<leader><Esc>` | Normal | Clear search highlight. Bare `<Esc>` is not mapped in terminal Vim: escape sequences start with Esc, so mapping it garbles input |
| `H` / `L` | Normal | Previous / next buffer |
| `Ctrl+q` | Normal | Delete buffer |
| `Ctrl+d` / `Ctrl+u` | Normal | Half-page scroll, cursor centred |
| `n` / `N` | Normal | Next / previous search result, centred |
| `y` | Visual | Yank, keeping the selection highlighted |

### Pane / Split Navigation (vim-tmux-navigator)

Shared between Vim and Tmux — navigate seamlessly across both.

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

---

## fzf (Shell Aliases)

> Source: `zsh/.config/zsh/aliases.sh`, `fish/.config/fish/aliases.fish`

fzf's shell integration is enabled in bash, zsh and fish when the installed fzf
supports `--bash`, `--zsh` or `--fish`. `Ctrl+T` selects files and `Alt+C`
selects a directory. `Ctrl+R` searches fzf history in bash; in zsh and fish,
atuin loads after fzf and takes over `Ctrl+R` when installed (otherwise fzf
handles it). Bash and zsh also get fzf fuzzy completion.

In zsh this ordering depends on `ZVM_INIT_MODE=sourcing` in `zshrc`. By default
zsh-vi-mode initialises at the first prompt and rebinds every key, which would
silently overwrite the fzf and atuin bindings.

fzf itself is still used heavily for the aliases below, the tmux popups, and the
`s` session and `p` project pickers. Theming for all of those comes from
`FZF_DEFAULT_OPTS`.

### fzf-powered Shell Aliases

These aliases use fzf for interactive selection:

**Sessions and projects**

| Alias | Description |
|---|---|
| `s` | Pick a running session → `switch-client` inside tmux, `attach-session` outside |
| `p` | Pick a folder name directly under `~/Projects` → `cd` there (no tmux action) |

`s` and `p` are shell **functions**, not aliases, so bash gets them too via
`aliases.sh`. `FZF_DEFAULT_OPTS` / `FZF_DEFAULT_COMMAND` are set in
`zsh/.config/zsh/.zprofile`, `bash/.config/bash/bashrc` and
`fish/.config/fish/variables.fish`.

At the shell prompt, `f` opens Ranger and follows its last directory on exit
(zsh and fish); `t` starts tmux, `o` opens OpenCode continuing the last session,
and `oc` opens OpenCode without resuming (bash, zsh, and fish). `v` runs `$EDITOR`,
while `e` still exits and `r` still resets the terminal.

**Homebrew (macOS)**

| Alias | Description |
|---|---|
| `bi` | Interactively install a Homebrew formula |
| `bic` | Interactively install a Homebrew cask |
| `bu` | Interactively uninstall a Homebrew formula |
| `buc` | Interactively uninstall a Homebrew cask |

**APT (Debian/Ubuntu servers)**

| Alias | Description |
|---|---|
| `ai` | Interactive `apt` install |
| `au` | Interactive `apt` remove |

---

## Zsh VI Mode

> Source: `zsh/.config/zsh/.zprofile` — via `jeffreytse/zsh-vi-mode`

| Setting | Value | Description |
|---|---|---|
| `ZVM_VI_ESCAPE_BINDKEY` | `jk` | Exit insert mode with `jk` chord |
| `ZVM_SYSTEM_CLIPBOARD_ENABLED` | `true` | System clipboard integration |
| `ZVM_INIT_MODE` | `sourcing` | Initialise at load time so later fzf/atuin bindings are kept (set in `zshrc`) |

Standard vi-mode bindings apply in both normal and insert modes.

Plugins loaded via Zinit (`zsh/.config/zsh/zshrc`): `fast-syntax-highlighting`,
`zsh-autosuggestions`, `zsh-completions`, `zsh-vi-mode`, `zsh-autopair`.

Vi-mode yank/paste uses the system clipboard (`pbcopy`/`pbpaste`) on macOS only,
set in `.zprofile`. On a Linux server over SSH it is disabled — yanks stay in
zsh's registers; pipe to `c` to copy to your local machine via OSC 52.

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

## Ranger

> Source: `ranger/.config/ranger/rc.conf` (Dracula theme in `colorschemes/dracula.py`)

Ranger loads its default `rc.conf` before these overrides. The built-in Vim
bindings include `hjkl` to move/open/ascend, `gg`/`G` for first/last entry,
`Ctrl+d`/`Ctrl+u` for half-page moves, `/` with `n`/`N` for searching,
`v`/`V` for selection, `yy`/`dd`/`pp` for copy/cut/paste, and `H`/`L`
for backward/forward directory history.

| Keybinding | Description |
|---|---|
| `Ctrl+o` | Back in directory history (Vim jumplist-style) |
| `-` | Ascend to parent directory (netrw-style) |
| `zf` | Live fuzzy filter in the current directory (`fzf_filter`); Escape cancels. Replaces ranger's built-in `zf` (`filter`), still available as `:filter` |
| `cz` | Prefill zoxide directory query (`:z `) |
| `cZ` | Interactive zoxide picker (`:zi`, requires `fzf`) |
| `ex` | Prefill `:extract ` for selected archive(s); optional argument is output directory |
| `ec` | Prefill `:compress ` for selected files; supply an archive name, e.g. `files.zip` |

These plugin shortcuts require the [Ranger plugins](README.md#plugin-managers).
Clear an accepted fuzzy filter with `:fzf_filter` (empty query). Default `f`
and `/` remain unchanged.

`Ctrl+i` is not remapped to history forward: terminals commonly send it as Tab,
which ranger already uses for switching tabs. Use `L` to go forward instead.

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

*Last updated: 2026-10-20*
