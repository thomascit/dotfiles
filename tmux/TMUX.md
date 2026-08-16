# Tmux Reference

> **Prefix:** `C-Space`

---

## Popups

| Binding | Description |
|---|---|
| `prefix + s` | Session picker — fzf over running sessions (windows in the preview) |
| `prefix + P` | Project picker — fzf `~/Projects` → session named after the project |
| `prefix + S` | SSH host picker (fzf from `~/.ssh/config`) |
| `prefix + r` | Run command (prompts, runs in new window) |
| `prefix + C-c` | Config file picker (`~/.config`, bat preview) |
| `prefix + R` | Reload `~/.config/tmux/tmux.conf` (confirms in the status line) |
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
| `prefix + s` | Session picker (see below) |
| `prefix + $` | Rename session (tmux built-in) |
| `prefix + C-s` | Rename session to cwd |

---

## Project Picker (`prefix + P`)

`prefix + P` is inline shell in `tmux.conf` (via `run-shell`) that lists the directories
one level under `~/Projects` in an fzf popup (contents previewed on the right) and turns
the selection into a tmux session.

| Situation | What happens |
|---|---|
| No session for that directory yet | Creates a session named after the directory, rooted in it |
| Session already exists | Switches to it, leaving whatever is running untouched |

Session names come from the directory basename with `.` and `:` translated to `_`,
matching the substitution tmux performs on session names itself — which is also what lets
the `has-session` check reliably find an existing session instead of creating a duplicate.

Override the search root with `PROJECTS_DIR` if needed.

This is the in-tmux twin of the [`tm` shell function](#shell-aliases): both list with
`find | sort`, name sessions the same way, and reuse an existing session. Neither starts
OpenCode — use `prefix + O` for a new window or `prefix + o` for a 40% split.

Because it is inline shell rather than a script, the binding is wrapped in **single**
quotes so tmux does not expand `$` before the shell sees it, and each statement ends with
`;` since the trailing `\` line continuations are joined into one line. That also means the
code cannot contain a single quote — hence `tr .: __` is written unquoted.

> **Note:** the picker used to live on `prefix + C-o`, which is now back to tmux's default
> `rotate-window`.

---

## Session Picker (`prefix + s`)

`prefix + s` is inline shell in `tmux.conf` (via `run-shell`): an fzf popup listing the
running sessions, with the selected session's windows shown in the preview pane.

| Binding | Description |
|---|---|
| `Enter` | Switch to the selected session |
| `C-x` | Kill the selected session and refresh the list |
| `Esc` | Cancel |

This overrides tmux's default `s` (`choose-tree -Zs`), which is still available via
`prefix + :` then `choose-tree -Zs`.

The tmux formats are the brace-free aliases (`#S`, `#I`, `#W`) rather than
`#{session_name}`, because those strings are passed through fzf's `--preview` and
`--bind` actions where `{...}` is fzf's own placeholder syntax. They still need quoting,
since an unquoted `#` would start a shell comment — and where quotes must nest (the
`--preview` and `--bind` values) the inner ones are written `\"`. tmux performs no
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
| `tm` | fzf picker over `~/Projects` → session named after the project, rooted in it |
| `s` | fzf picker over running sessions → switch (inside tmux) or attach (outside) |
| `tma` | Attach to a session by name (`tmux attach-session -t`) |
| `tmn` | New window opening `$EDITOR` in current path |
| `tmk` | Kill the tmux server (`tmux kill-server`, zsh only) |
| `tmr` | Rename current session |
| `tmt` | New/attach session named after cwd |
| `tmts` | New/switch session named after cwd (switch-client if inside tmux) |

`tm` reuses an existing session for the project instead of creating a duplicate, and
`.`/`:` in the directory name become `_` (matching tmux's own session-name rules).
Override the search root with `PROJECTS_DIR`. It is the shell twin of `prefix + P`, just
as `s` is the shell twin of `prefix + s`.

`tm` and `s` are shell **functions**, not aliases, so bash and zsh share one definition
from `zsh/.config/zsh/aliases.sh`; fish has its own copies in
`fish/.config/fish/aliases.fish`.
