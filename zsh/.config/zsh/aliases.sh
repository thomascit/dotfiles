# Remove retired definitions when this file is re-sourced in an existing shell.
unalias c fc yc df cat p40 p50 p20 hyc pi yi pri pu yu pru dnfi dnfu 2>/dev/null || :
unset -f y work rest 2>/dev/null || :

# ─────────────────────────────────────────────
# Clipboard
# ─────────────────────────────────────────────
# macOS: pbcopy. Anywhere else (a Linux server over SSH): OSC 52, an escape
# sequence asking the *client* terminal to set its clipboard, so no display or
# xclip is needed. tmux forwards it (set-clipboard on). Terminals cap the
# payload, typically around 100 KB. Usage: `cmd | c` or `c FILE`.
c() {
  if [[ "$OSTYPE" == "darwin"* ]] && command -v pbcopy >/dev/null 2>&1; then
    cat "$@" | command pbcopy
    return
  fi
  local data
  data=$(cat "$@" | base64 | tr -d '\r\n') || return 1
  printf '\033]52;c;%s\a' "$data" > /dev/tty
}

# Run the dotfiles setup menu (does not reload the shell).
alias u="$HOME/Projects/dotfiles/setup.sh"

# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
# Resolve EDITOR when called; support an executable plus flags without eval.
_edit() {
  local -a editor
  if [[ -n "$ZSH_VERSION" ]]; then
    editor=("${(@Q)${(z)${EDITOR:-vim}}}")
  else
    read -r -a editor <<< "${EDITOR:-vim}"
  fi
  "${editor[@]}" "$@"
}
alias ac='_edit "$HOME/.config/alacritty/alacritty.toml"'
alias als='_edit "$HOME/.config/zsh/aliases.sh"'
alias alsf='_edit "$HOME/.config/fish/aliases.fish"'
alias brc='_edit "$HOME/.config/bash/bashrc"'
alias fsh='_edit "$HOME/.config/fish/config.fish"'
alias gc='_edit "$HOME/.config/ghostty/config"'
alias kc='_edit "$HOME/.config/kitty/kitty.conf"'
alias sc='_edit "$HOME/.config/starship/starship.toml"'
alias sshc='_edit "$HOME/.ssh/config"'
alias tc='_edit "$HOME/.config/tmux/tmux.conf"'
alias vrc='_edit "$HOME/.config/vim/vimrc"'
alias zrc='_edit "$HOME/.config/zsh/zshrc"'
alias zpc='_edit "$HOME/.config/zsh/.zprofile"'
alias vc='_edit "$HOME/.config/fish/variables.fish"'

# ─────────────────────────────────────────────
# Git
# ─────────────────────────────────────────────
alias ga="git add"
alias gb="git branch"
alias gcm="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log --oneline --graph"
alias gp="git push"
alias gs="git status"

# ─────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────
alias ba="brew autoremove"
alias bc="brew cleanup --prune=all"
alias bi="brew formulae | fzf --multi --preview 'brew info {1}' | xargs -ro brew install"
alias bic="brew casks | fzf --multi --preview 'brew info --cask {1}' | xargs -ro brew install --cask"
alias bu="brew leaves | fzf --multi --preview 'brew info {1}' | xargs -ro brew uninstall"
alias buc="brew list --cask | fzf --multi --preview 'brew info --cask {1}' | xargs -ro brew uninstall --cask"
alias bup="brew update && brew upgrade -g"

# ─────────────────────────────────────────────
# APT (Debian/Ubuntu servers)
# ─────────────────────────────────────────────
alias ai="apt-cache pkgnames | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt install"
alias au="dpkg --get-selections | grep -v deinstall | cut -f1 | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt remove"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
command -v fdfind &>/dev/null && alias fd="fdfind"
command -v kitten &>/dev/null && alias icat="kitten icat"
# eza is absent from Debian 12's repos; without a guard this breaks `ls`.
if command -v eza &>/dev/null; then
  alias ls="eza --icons=always --sort=type --header -l --git"
  alias lst="eza --icons=always --sort=type --header -l --git --tree"
fi
command -v trash &>/dev/null && alias rm="trash"

# ─────────────────────────────────────────────
# Source Shells
# ─────────────────────────────────────────────
alias sz="source $HOME/.config/zsh/zshrc"
# Add SSH keys to the already-running agent (launchd on macOS, systemd
# ssh-agent.socket on a Linux server); SSH_AUTH_SOCK is exported in .zprofile. Not piped to
# /dev/null: ssh-add prompts for the key passphrase on stderr.
alias sa="ssh-add ~/.ssh/id_ed25519"

# ─────────────────────────────────────────────
# Terminal
# ─────────────────────────────────────────────
alias bashc="clear && bash"
alias e="exit"
alias ff="fastfetch"
alias fishc="clear && fish"
alias l="clear"
alias v='_edit'
alias r="reset"
alias zshc="clear && zsh"
alias oc="opencode"
# saf [url|file] — open in Safari; bare domains get https:// prepended.
saf() {
  if [ -z "$1" ] || [ -e "$1" ] || [[ "$1" == *://* ]]; then
    open -a Safari "$@"
  else
    open -a Safari "https://$1"
  fi
}

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
# Sourcing a changed file does not remove aliases/functions from this shell.
# Clear retired tmux shortcuts from sessions that loaded an older version.
unalias tmr tmt 2>/dev/null || :
unset -f tmp 2>/dev/null || :
alias tm="tmux"
alias tma="tmux attach-session -t"
alias tmk='tmux kill-server'

# ─────────────────────────────────────────────
# Session picker (function, shared by bash and zsh)
# ─────────────────────────────────────────────
# Enter a session: switch when already inside tmux, attach when outside.
# "=" forces an exact name match, so "dot" cannot match "dotfiles".
_tmux_goto() {
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "=$1"
    else
        tmux attach-session -t "=$1"
    fi
}

# s — fzf over the running sessions.
# Shell twin of tmux's `prefix + s`.
s() {
    command -v fzf >/dev/null 2>&1 || { echo "s: fzf not found" >&2; return 1; }

    local picked
    picked=$(
        tmux list-sessions -F '#S' 2>/dev/null \
            | fzf --no-sort --height 40% --reverse --border \
                --border-label ' sessions ' --prompt 'session > '
    ) || return 0
    [ -n "$picked" ] || return 0

    _tmux_goto "$picked"
}

# ─────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────
alias ld="lazydocker"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f --tail=100"
alias dcb="docker compose build --no-cache"

# ─────────────────────────────────────────────
# SSH
# ─────────────────────────────────────────────
alias sskg="ssh-keygen -o -a 100 -t ed25519 -C"
