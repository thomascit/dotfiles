#!/usr/bin/env bash
# Icons, fuzzy filtering, zoxide and archives; review upstream Python before changing pins.
set -euo pipefail
config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v git >/dev/null 2>&1; then
  echo 'git missing — skipping Ranger plugins' >&2
  exit 0
fi
install_plugin() {
  local repo="$1" revision="$2" dependency="${3:-}"
  local dest="$config_dir/plugins/${repo##*/}"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -d "$dest/.git" ]] && [[ "$(git -C "$dest" rev-parse HEAD 2>/dev/null)" == "$revision" ]]; then
      echo "Ranger: ${repo##*/} already at reviewed revision"
      if [[ -n "$(git -C "$dest" status --porcelain)" ]]; then
        echo "WARNING: local changes in $dest; left untouched" >&2
      fi
    else
      echo "WARNING: $dest exists at another revision or is not a checkout; left untouched" >&2
    fi
    if [[ -n "$dependency" ]] && ! command -v "$dependency" >/dev/null 2>&1; then
      echo "WARNING: $repo requires $dependency on PATH; existing plugin left untouched" >&2
    fi
    return
  fi
  if [[ -n "$dependency" ]] && ! command -v "$dependency" >/dev/null 2>&1; then
    echo "WARNING: $dependency missing — skipping $repo" >&2
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if git clone --no-checkout "https://github.com/$repo.git" "$dest" \
      && git -C "$dest" checkout --detach "$revision"; then
    echo "Ranger: installed $repo at $revision"
  else
    echo "WARNING: $repo install failed; inspect $dest before retrying" >&2
  fi
}
install_plugin cdump/ranger-devicons2 94bdcc19218681debb252475fd9d11cfd274d9b1
install_plugin MuXiu1997/ranger-fzf-filter bf16de2e4ace415b685ff7c58306d0c5146f9f43 fzf
install_plugin jchook/ranger-zoxide c64d4aed906487cc8c648f51814682a2c01c21d9 zoxide
install_plugin maximtrp/ranger-archives 1f5629bc81e6798deec6a767d780e271dc517d27
echo 'Restart Ranger to load plugins. Icons require a Nerd Font; zi also requires fzf.'
