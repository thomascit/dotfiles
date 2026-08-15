#!/bin/sh
#
# Uptime / load average for the fallback status bar — used when the
# dracula/tmux plugin is not installed (e.g. a server set up with
# `setup.sh --minimal`, which skips TPM because it needs network).
#
# Both values come from a single `uptime` call, which is the one source
# available on Linux and macOS alike. The uptime parsing deliberately mirrors
# dracula/tmux scripts/uptime.sh so the fallback reads the same as the real
# status bar.
#
# LC_ALL is pinned because `uptime` output is locale-dependent. The dracula
# plugin pins en_US.UTF-8, but that locale is frequently not generated on a
# minimal Debian install; C is always available and is equally deterministic.
export LC_ALL=C

out=$(uptime 2>/dev/null) || exit 0
[ -n "$out" ] || exit 0

case "${1:-uptime}" in
uptime)
  # Text after " up ", first comma-separated field: "3 days" or "4:05".
  printf '%s' "$out" \
    | awk -F' up ' '{ split($2, a, ","); printf "%s", a[1] }' \
    | sed 's/^[[:space:]]*//'
  ;;
load)
  # "load average:" on Linux, "load averages:" on macOS.
  printf '%s' "$out" \
    | sed -n 's/.*load average[s]*:[[:space:]]*//p' \
    | tr -d ','
  ;;
*)
  exit 0
  ;;
esac
