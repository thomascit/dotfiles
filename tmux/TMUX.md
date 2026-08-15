# Tmux Reference

> **Prefix:** `C-Space`

---

## Popups

| Binding | Description |
|---|---|
| `prefix + C-o` | Project picker — fzf `~/Projects` → sesh session (launches OpenCode on create) |
| `prefix + s` | Session switcher (sesh) |
| `prefix + S` | SSH host picker (fzf from `~/.ssh/config`) |
| `prefix + r` | Run command (prompts, runs in new window) |
| `prefix + C-c` | Config file picker (`~/.config`, bat preview) |
| `prefix + ?` | Key bindings reference popup |

---

## New Windows

| Binding | Description |
|---|---|
| `prefix + c` | New window (current path) |
| `prefix + C` | New named window (prompt) |
| `prefix + N` | Editor (`$EDITOR`, defaults to `vim`) |
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
| `C-h / C-l / C-k / C-j` | Move between panes (vim-style, works across vim) |
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
| `prefix + C-s` | Rename session to cwd |

---

## Project Picker (`prefix + C-o`)

`prefix + C-o` runs `~/.config/tmux/scripts/opencode-project.sh`, which lists the
directories one level under `~/Projects` in an fzf popup and hands the selection to
`sesh connect`.

| Situation | What happens |
|---|---|
| No session for that directory yet | Creates a session named after the directory and starts OpenCode in it |
| Session already exists | Attaches/switches to it, leaving whatever is running untouched |

The create-or-attach behaviour comes from `sesh connect`, and the "only start OpenCode
once" behaviour comes from its `--command` flag, which sesh **ignores when the session
already exists**. So pressing `C-o` on the same project repeatedly never stacks a second
OpenCode on top of the first.

Override the search root with `PROJECTS_DIR` if needed.

> **Note:** this overrides tmux's default `prefix + C-o` (`rotate-window`, which cycles
> pane contents around the current layout). Use `prefix + {` / `prefix + }` to rearrange
> panes instead. Because it sits behind the prefix, `C-o` still works normally inside
> Vim and the shell.

---

## Sesh

`prefix + s` opens the [sesh](https://github.com/joshmedeski/sesh) session picker in an
fzf popup (tmux sessions listed first). These bindings work inside the picker:

| Binding | Description |
|---|---|
| `Tab` / `S-Tab` | Move down / up |
| `C-a` | List all sources |
| `C-t` | List tmux sessions |
| `C-g` | List sesh configs |
| `C-x` | List zoxide directories |
| `C-f` | Find directories under `~` (`fd`) |
| `C-d` | Kill the selected tmux session |

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
| `t` | Create or join the MAIN tmux session |
| `ta` | Attach to a session by name (`tmux attach-session -t`) |
| `tn` | New window opening `$EDITOR` in current path |
| `tk` | Kill the tmux server (`tmux kill-server`) |
| `tr` | Rename current session |
| `tt` | New/attach session named after cwd |
| `tts` | New/switch session named after cwd (switch-client if inside tmux) |
| `s` | fzf picker over `sesh list` → connect to the selected session |
