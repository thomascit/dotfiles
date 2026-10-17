#!/bin/sh
#
# Make auto-named sessions start at 1 instead of 0, to match `base-index 1`
# and `pane-base-index 1`.
#
# tmux has no session equivalent of `base-index`: a `new-session` without `-s`
# is always named with the lowest unused non-negative integer, starting at 0,
# and that is not configurable. So instead of preventing the 0, this renames it
# after the fact, driven by the `session-created` hook in tmux.conf.
#
# $1 is the name of the session that triggered the hook. Sessions with an
# explicit (non-numeric) name are left alone — only tmux's own numeric
# auto-names are rewritten, regardless of how the unnamed session was created.
#
# The hook MUST use `run-shell -b`. Without -b, run-shell blocks the tmux
# server until the script exits, while the script itself is waiting on a
# `tmux` command that the blocked server can never answer — the rename
# silently never happens. -b runs it in the background and breaks the cycle.

name=$1
[ -n "$name" ] || exit 0

# Pure digits only. `case` is used rather than a regex so this stays POSIX sh.
case $name in
*[!0-9]*) exit 0 ;;  # has a non-digit -> explicitly named, leave it
esac

# Already 1 or higher: nothing to fix.
[ "$name" -eq 0 ] 2>/dev/null || exit 0

# Lowest free integer >= 1. The cap keeps this from spinning forever if
# has-session ever misbehaves; 1024 sessions is far past anything realistic.
i=1
while [ "$i" -le 1024 ]; do
  if ! tmux has-session -t "=$i" 2>/dev/null; then
    # "=" forces an exact name match, so "=0" cannot hit "01" or similar.
    tmux rename-session -t "=$name" "$i" 2>/dev/null
    exit 0
  fi
  i=$((i + 1))
done
