#!/usr/bin/env sh
# Project picker -> tmux session (+ OpenCode)
#
# Lists directories one level under $PROJECTS_DIR (default ~/Projects) in an
# fzf popup, then hands the chosen path to `sesh connect`, which creates a
# tmux session named after the directory or attaches to it if it already exists.
#
# `sesh connect --command` only runs on session CREATION and is ignored when
# attaching to an existing session, so OpenCode is launched exactly once per
# project and never stacked on top of a session that is already running it.
#
# Bound to C-o (no prefix) in tmux.conf.

set -eu

PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"

[ -d "$PROJECTS_DIR" ] || exit 0

# fd appends a trailing slash to directories; strip it so that fzf's
# --with-nth=-1 shows the basename and sesh receives a clean path.
selected=$(
    fd . "$PROJECTS_DIR" --type d --max-depth 1 \
        | sed 's:/*$::' \
        | fzf-tmux -p 60%,50% \
            --delimiter=/ --with-nth=-1 \
            --no-sort \
            --border-label ' Projects ' \
            --prompt 'project > ' \
            --header 'enter: open  esc: cancel'
) || exit 0

[ -n "$selected" ] || exit 0

exec sesh connect "$selected" --command opencode
