# Tmux Reference

> **Prefix:** `C-Space`

---

## Popups

| Binding | Description |
|---|---|
| `prefix + F` | SSH host picker (fzf from `~/.ssh/config`) |
| `prefix + v` | File picker (fzf) → open in `$EDITOR` |
| `prefix + s` | Session switcher (fzf) |
| `prefix + r` | Popup terminal in current path |
| `prefix + S` | New session from `~/Projects` picker |
| `prefix + C-c` | Config file picker (`~/.config`, bat preview) |
| `prefix + ?` | Key bindings reference popup |

---

## New Windows

| Binding | Description |
|---|---|
| `prefix + c` | New window (current path) |
| `prefix + C` | New named window (prompt) |
| `prefix + N` | Neovim (`nvim`) |
| `prefix + O` | OpenCode (continue last session) |
| `prefix + f` | Yazi file manager |
| `prefix + g` | Lazygit |
| `prefix + p` | btop |
| `prefix + a` | cmatrix |

---

## Pane Splits

| Binding | Description |
|---|---|
| `prefix + -` | Horizontal split (current path) |
| `prefix + _` | Vertical split (current path) |
| `prefix + o` | Vertical split 40% → OpenCode |
| `prefix + t` | Horizontal split 25% |

---

## Pane Navigation

| Binding | Description |
|---|---|
| `C-h / C-l / C-k / C-j` | Move between panes (vim-style, works across nvim) |
| `C-\` | Previous pane |
| `prefix + H/J/K/L` | Resize pane (repeatable) |

---

## Windows

| Binding | Description |
|---|---|
| `M-h` | Previous window |
| `M-l` | Next window |
| `S-Left` | Swap window left |
| `S-Right` | Swap window right |
| `prefix + C-w` | Rename window to cwd |

---

## Sessions

| Binding | Description |
|---|---|
| `prefix + C-S` | Rename session to cwd |

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

## Resurrect

| Binding | Description |
|---|---|
| `M-s` | Save session |
| `M-r` | Restore session |

---

## Shell Aliases

| Alias | Description |
|---|---|
| `t` | Create a new numbered tmux session |
| `ta` | Attach to a session by name (`tmux attach-session -t`) |
| `tn` | New window opening `$EDITOR` in current path |
| `tk` | Kill the tmux server (`tmux kill-server`) |
| `tr` | Rename current session |
| `tt` | New/attach session named after cwd |
| `tts` | New/switch session named after cwd (switch-client if inside tmux) |
