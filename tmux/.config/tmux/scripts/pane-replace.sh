#!/usr/bin/env bash
#
# Replace whatever is running in ONE pane with a typed command, leaving every
# other pane and the layout untouched. Bound to `prefix + e` in tmux.conf,
# which runs this inside a small popup:
#
#   pane-replace.sh [pane_id]
#
# pane_id is the pane to replace (e.g. %3). Without a usable one, the active
# pane of the current client is used — the pane behind the popup.
#
# How: `respawn-pane -k` kills the pane's process and starts a new one in the
# same pane. The command runs in an interactive shell so aliases work, then
# `exec`s a fresh shell when it exits, so the pane drops to a prompt in the
# same directory instead of closing and collapsing the layout.

set -euo pipefail

pane="${1:-}"
if [[ ! "$pane" =~ ^%[0-9]+$ ]]; then
  pane="$(tmux display-message -p '#{pane_id}')"
fi

current="$(tmux display-message -p -t "$pane" '#{pane_current_command}')"
dir="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"
shell="${SHELL:-/bin/sh}"

printf 'Replace \033[36m%s\033[0m in this pane with (empty Enter or Ctrl+C cancels):\n' "$current"
# -e: readline editing (arrows, Ctrl+A/E, …). Esc does NOT cancel here — in
# readline it is a Meta prefix — so Ctrl+C / Ctrl+D / empty line are the exits.
read -e -r -p '> ' cmd || exit 0
[[ -n "${cmd//[[:space:]]/}" ]] || exit 0

# Multi-argument form: tmux runs $shell directly, without wrapping it in
# `sh -c`, so the typed command never needs escaping. It travels in PANE_CMD
# and is only evaluated by the interactive shell in the target pane. The inner
# string is valid zsh, bash and fish.
tmux respawn-pane -k -t "$pane" -c "$dir" -e "PANE_CMD=$cmd" \
  "$shell" -ic 'eval "$PANE_CMD"; exec $SHELL'
