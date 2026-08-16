# Environment Variables
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export TERMINAL="ghostty"
export EDITOR="vim"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
# /usr/local/share/go is writable under Homebrew but root-owned on Linux,
# where `go install` would fail without sudo.
if [[ "$OSTYPE" == "darwin"* ]]; then
  export GOPATH="/usr/local/share/go"
else
  export GOPATH="$HOME/go"
fi

# Dracula Man Page Colors
export MANPAGER="less -s -M +Gg"
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;34m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;45;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;36m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# Fzf
# Read by the fzf binary itself, so these apply to every fzf invocation
# (tmux popups, the session picker, the package-manager aliases in aliases.sh).
# Exclude container storage — subdirs are owned by uid 100000 (Podman rootless
# user namespace mapping) and are not accessible as the normal user, causing
# rg to emit permission errors when traversing them.
# Falls back to fd/find so fzf still lists files without ripgrep installed.
if command -v rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.local/share/containers"'
elif command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'
elif command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.git/*"'
fi
# Default theme/colors (Dracula)
export FZF_DEFAULT_OPTS='--color=border:#44475a --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --layout=reverse'
# ZSH-VI Settings
export ZVM_VI_ESCAPE_BINDKEY=jk
export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# Clipboard commands for zsh-vi-mode (OS-conditional, mirrors aliases.sh).
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZVM_CLIPBOARD_COPY_CMD='pbcopy'
  export ZVM_CLIPBOARD_PASTE_CMD='pbpaste'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
    export ZVM_CLIPBOARD_COPY_CMD='clip.exe'
    export ZVM_CLIPBOARD_PASTE_CMD='powershell.exe -Command Get-Clipboard'
  elif [[ -n "$WAYLAND_DISPLAY" ]]; then
    export ZVM_CLIPBOARD_COPY_CMD='wl-copy'
    export ZVM_CLIPBOARD_PASTE_CMD='wl-paste'
  else
    export ZVM_CLIPBOARD_COPY_CMD='xclip -selection clipboard'
    export ZVM_CLIPBOARD_PASTE_CMD='xclip -selection clipboard -o'
  fi
fi

# LAZYGIT Settings
export LAZYGIT_NEW_DIR_FILE=$HOME/.lazygit/newdir

# ssh-agent (systemd user socket, Linux)
# Debian/systemd ships a socket-activated agent (ssh-agent.socket, enabled by
# default) listening on $XDG_RUNTIME_DIR/openssh_agent, but only exports
# SSH_AUTH_SOCK into the systemd user manager — not into tty/ssh login shells.
# One agent shared by every shell; keys added once with `sa` persist. The guard
# leaves a forwarded/pre-existing agent (ssh -A, macOS) untouched.
if [[ -z "$SSH_AUTH_SOCK" && -S "${XDG_RUNTIME_DIR}/openssh_agent" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/openssh_agent"
fi

[ -f "$HOME/.zenv" ] && source "$HOME/.zenv"
