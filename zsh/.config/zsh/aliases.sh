# ─────────────────────────────────────────────
# Clipboard (OS-specific)
# ─────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias c="pbcopy"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
    alias c="clip.exe"
  elif [[ -n "$WAYLAND_DISPLAY" ]]; then
    alias c="wl-copy"
  else
    alias c="xclip -i -selection clipboard"
  fi
fi

# Reload config
alias u="$HOME/Projects/dotfiles/setup.sh"

# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
alias ac="$EDITOR $HOME/.config/alacritty/alacritty.toml"
alias als="$EDITOR $HOME/.config/zsh/aliases.sh"
alias alsf="$EDITOR $HOME/.config/fish/aliases.fish"
alias brc="$EDITOR $HOME/.config/bash/bashrc"
alias fc="$EDITOR $HOME/.config/fish/config.fish"
alias gc="$EDITOR $HOME/.config/ghostty/config"
alias hyc="$EDITOR $HOME/.config/hypr/hyprland.conf"
alias kc="$EDITOR $HOME/.config/kitty/kitty.conf"
alias sc="$EDITOR $HOME/.config/starship/starship.toml"
alias sshc="$EDITOR $HOME/.ssh/config"
alias tc="$EDITOR $HOME/.config/tmux/tmux.conf"
alias vrc="$EDITOR $HOME/.config/vim/vimrc"
alias zrc="$EDITOR $HOME/.config/zsh/zshrc"
alias zpc="$EDITOR $HOME/.config/zsh/.zprofile"
alias vc="$EDITOR $HOME/.config/fish/variables.fish"
alias yc="$EDITOR $HOME/.config/yazi/yazi.toml"
alias df="yazi $HOME/.config"

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
# Note: not 'du' — that shadows the disk-usage builtin.
alias dnfu='dnf repoquery --installed --qf "%{name}\n" 2>/dev/null | fzf --multi --preview "dnf info {1}" | xargs -ro sudo dnf remove'

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
command -v fdfind &>/dev/null && alias fd="fdfind"
# Debian/Ubuntu ship bat as `batcat` (the `bat` name clashes with
# bacula-console-qt). Guard both, and leave `cat` alone if neither exists —
# an unguarded alias here breaks `cat` shell-wide.
if command -v bat &>/dev/null; then
  alias cat="bat"
elif command -v batcat &>/dev/null; then
  alias cat="batcat"
fi
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
alias v="$EDITOR"
alias r="reset"
alias zshc="clear && zsh"
alias oc="opencode"

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
alias tm='tmux new-session -A -s MAIN'
alias tma="tmux attach-session -t"
alias tmn='tmux new-window -c "#{pane_current_path}" $EDITOR .'
alias tmk='tmux kill-server'
alias tmr="tmux rename-session"
alias tmt='tmux new-session -A -s "${PWD##*/}" -c "$PWD"'
alias tmts='if [ -n "$TMUX" ]; then tmux switch-client -t "${PWD##*/}" 2>/dev/null || tmux new-session -d -s "${PWD##*/}" -c "$PWD" && tmux switch-client -t "${PWD##*/}"; else tmux new-session -A -s "${PWD##*/}" -c "$PWD"; fi'

# ─────────────────────────────────────────────
# Sesh
# ─────────────────────────────────────────────
alias s='_sesh=$(sesh list --icons | fzf --ansi --no-sort --height 40% --reverse --border --border-label " sesh " --prompt "⚡  ") && [ -n "$_sesh" ] && sesh connect "$_sesh"'

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

# ─────────────────────────────────────────────
# Pomodoro
# ─────────────────────────────────────────────
alias p40="work 40m && rest 20m"
alias p20="work 20m && rest 10m"
