# Remove retired definitions when this file is re-sourced in an existing shell.
unalias c fc yc df cat p40 p50 p20 2>/dev/null || :
unset -f y work rest 2>/dev/null || :

# ─────────────────────────────────────────────
# Clipboard (OS-specific)
# ─────────────────────────────────────────────
# Check at invocation time: display forwarding can change during a session.
c() {
  if [[ "$OSTYPE" == "darwin"* ]] && command -v pbcopy >/dev/null 2>&1; then
    command pbcopy "$@"
  elif [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy >/dev/null 2>&1; then
    command wl-copy "$@"
  elif [[ -n "$DISPLAY" ]] && command -v xclip >/dev/null 2>&1; then
    command xclip -i -selection clipboard "$@"
  elif grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null && command -v clip.exe >/dev/null 2>&1; then
    command clip.exe "$@"
  else
    printf '%s\n' 'c: no clipboard available (requires pbcopy, Wayland + wl-copy, X11 + xclip, or WSL + clip.exe)' >&2
    return 1
  fi
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
alias hyc='_edit "$HOME/.config/hypr/hyprland.conf"'
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
# Pacman (Arch)
# ─────────────────────────────────────────────
alias pi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias yi="yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S"
alias pri="paru -Slq | grep -a '^[a-zA-Z0-9._+-]*\$' | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias pu="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias yu="yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns"
alias pru="paru -Qq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru -Rns"

# ─────────────────────────────────────────────
# APT (Debian/Ubuntu)
# ─────────────────────────────────────────────
alias ai="apt-cache pkgnames | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt install"
alias au="dpkg --get-selections | grep -v deinstall | cut -f1 | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt remove"

# ─────────────────────────────────────────────
# DNF (Fedora/RHEL)
# ─────────────────────────────────────────────
alias dnfi='dnf repoquery --available -y --qf "%{name}\n" 2>/dev/null | fzf --multi --preview "dnf info {1}" | xargs -ro sudo dnf install'
# Note: not 'du' — that shadows the disk-usage command.
alias dnfu='dnf repoquery --installed --qf "%{name}\n" 2>/dev/null | fzf --multi --preview "dnf info {1}" | xargs -ro sudo dnf remove'

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
# Add SSH keys to the already-running agent (systemd ssh-agent.socket on Linux,
# launchd on macOS); SSH_AUTH_SOCK is exported in .zprofile. Not piped to
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
