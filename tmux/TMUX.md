# Tmux Reference

> **Prefix:** `C-Space`

---

## Popups

| Binding | Description |
|---|---|
| `prefix + s` | Session picker — fzf over running sessions |
| `prefix + S` | SSH host picker (fzf from `~/.ssh/config`) |
| `prefix + r` | Run command (prompts, runs in new window) |
| `prefix + C` | Config file picker (`~/.config`) |
| `prefix + R` | Reload `~/.config/tmux/tmux.conf` (confirms in the status line) |
| `prefix + ?` | Key bindings reference popup |

---

## New Windows

| Binding | Description |
|---|---|
| `prefix + c` | New window (current path) |
| `prefix + N` | Editor (`$EDITOR`, defaults to `vim`) |
| `prefix + O` | OpenCode (fresh session — `prefix + o` is the one that continues) |
| `prefix + f` | Ranger file manager |
| `prefix + g` | Lazygit |
| `prefix + p` | btop |
| `prefix + a` | cmatrix |

---

## Pane Splits

| Binding | Description |
|---|---|
| `prefix + -` | Horizontal split (current path) |
| `prefix + _` | Vertical split (current path) |
| `prefix + v` | Vertical split left, 60% → `$EDITOR` |
| `prefix + o` | Vertical split 40% → `opencode --continue` |
| `prefix + t` | Horizontal split 25% |
| `prefix + m` | Horizontal split 10% |

"Horizontal" and "Vertical" here describe the orientation of the divider, matching the
wording in the `prefix + ?` popup: `-` is `split-window -v` (panes stacked), `_` is
`split-window -h` (panes side by side).

---

## Pane Navigation

| Binding | Description |
|---|---|
| `C-h / C-l / C-k / C-j` | Move between panes (vim-style, works across vim) |
| `C-\` | Previous pane |
| `prefix + H/J/K/L` | Resize pane (repeatable) |

---

## Windows

| Binding | Description |
|---|---|
| `prefix + w` | Window switcher — fzf popup over the current session's windows |
| `M-h` | Previous window |
| `M-l` | Next window |
| `S-Left` | Swap window left |
| `S-Right` | Swap window right |

Windows keep tmux's automatic names based on the running command.

---

## Sessions

Use `prefix + s` to pick a session (see below).

Sessions created without a name (a bare `tmux` or `tm`) are numbered from **1**, not 0,
so they line up with `base-index 1` and `pane-base-index 1`. tmux has no session-level
`base-index` — an unnamed session is always created as `0` — so a `session-created` hook
runs `scripts/session-renumber.sh`, which renames it to the lowest free number ≥ 1.
Only purely numeric auto-names are touched; `tm` creates an unnamed session.

---

## Session Picker (`prefix + s`)

`prefix + s` is inline shell in `tmux.conf` (via `run-shell`): an fzf popup listing the
running sessions, without a preview pane.

| Binding | Description |
|---|---|
| `Enter` | Switch to the selected session |
| `C-x` | Kill the selected session and refresh the list |
| `Esc` | Cancel |

This overrides tmux's default `s` (`choose-tree -Zs`), which is still available via
`prefix + :` then `choose-tree -Zs`.

The tmux format is the brace-free alias `#S` rather than
`#{session_name}`, because it is passed through fzf's
`--bind` actions where `{...}` is fzf's own placeholder syntax. It still needs quoting,
since an unquoted `#` would start a shell comment — and where quotes must nest (the
`--bind` value) the inner ones are written `\"`. tmux performs no
replacements inside single quotes, so those backslashes reach the shell untouched.

From the shell, `s` is the same picker — see [Shell Aliases](#shell-aliases).

---

## Toggles

| Binding | Description |
|---|---|
| `prefix + b` | Toggle status bar |
| `prefix + B` | Toggle pane border status |
| `prefix + T` | Toggle status position (top/bottom) |

---

## Kill

| Binding | Description |
|---|---|
| `prefix + x` | Kill pane (no confirmation) |
| `prefix + &` | Kill window (no confirmation) |

---

## Copy Mode (vi)

| Binding | Description |
|---|---|
| `prefix + Space` | Enter copy mode |
| `v` | Begin selection |
| `y` | Yank selection |
| `r` | Rectangle toggle |

---

## Plugins / TPM

The config is designed to work **standalone**, without TPM. A server installed with
`setup.sh --minimal` has no TPM at all, since fetching plugins needs network, and the
`if-shell` guard at the bottom of `tmux.conf` skips the plugin loader silently.

Everything TPM adds is therefore additive:

| Plugin | What is lost without TPM |
|---|---|
| `dracula/tmux` | Nothing functional — the fallback section of `tmux.conf` reproduces the status bar in pure tmux |
| `vim-tmux-navigator` | Nothing — `C-h/j/k/l/\` are reproduced in the fallback section, including the "is vim running?" check |
| `tmux-resurrect` | **`prefix + M-s` / `prefix + M-r` do not exist.** No pure-tmux equivalent |
| `tmux-yank` | `prefix + y` / `prefix + Y`. Copy-mode `y` still works via this config plus `set-clipboard on` |
| `tmux-continuum` | Nothing — its options are commented out anyway |

`tmux-sensible` is deliberately **not** used. Its options are set directly in the options
block at the top of `tmux.conf` instead, so scrollback, `escape-time`, `display-time`,
`focus-events`, `status-keys` and `aggressive-resize` are identical with and without TPM.
Its only other bindings, `C-p`/`C-n`, duplicate `M-h`/`M-l`.

Install the plugins on a networked host with `./setup.sh --plugins`, then `prefix + I`.

---

## Resurrect (requires TPM)

Provided by `tmux-plugins/tmux-resurrect`, so these only work on a machine where TPM is
installed. They are bound in the **prefix** table, not as bare `M-s`/`M-r`.

| Binding | Description |
|---|---|
| `prefix + M-s` | Save session |
| `prefix + M-r` | Restore session |

---

## Shell Aliases

| Alias | Description |
|---|---|
| `s` | fzf picker over running sessions → switch (inside tmux) or attach (outside) |
| `tm` | Bare `tmux` |
| `tma` | Attach to a session by name (`tmux attach-session -t`) |
| `tmk` | Kill the tmux server (`tmux kill-server`, zsh/bash only) |
| `tc` | Open `tmux.conf` in `$EDITOR` |

`s` is a shell **function**, not an alias, so bash and zsh share one definition
from `zsh/.config/zsh/aliases.sh`; fish has its own copy in
`fish/.config/fish/aliases.fish`.
