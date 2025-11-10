# ─────────────────────────────────────────────
# Clipboard
# ─────────────────────────────────────────────
alias c="xclip -i -selection clipboard"
alias cc="pbcopy"

# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
alias ac="$EDITOR $HOME/.config/alacritty/alacritty.toml"
alias aec="$EDITOR $HOME/.config/aerospace/aerospace.toml"
alias als="$EDITOR $HOME/.config/zsh/aliases.*"
alias brc="$EDITOR $HOME/.config/bash/bashrc"
alias exs="$EDITOR $HOME/.config/exports.sh"
alias exf="$EDITOR $HOME/.config/exports.fish"
alias fc="$EDITOR $HOME/.config/fish/config.fish"
alias gc="$EDITOR $HOME/.config/ghostty/config"
alias i3c="$EDITOR $HOME/.config/i3/config"
alias kc="$EDITOR $HOME/.config/kitty/kitty.conf"
alias sc="$EDITOR $HOME/.config/starship/starship.toml"
alias sshc="$EDITOR $HOME/.ssh/config"
alias tc="$EDITOR $HOME/.config/tmux/tmux.conf"
alias vrc="$EDITOR $HOME/.config/vim/vimrc"
alias nvrc="yazi $HOME/.config/nvim"
alias zrc="$EDITOR $HOME/.config/zsh/zshrc"
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
alias bc="brew cleanup"
alias be="$EDITOR $HOME/brewfile"
alias bu="brew update && brew upgrade && brew bundle --file $HOME/brewfile"

# ─────────────────────────────────────────────
# Pacman
# ─────────────────────────────────────────────
alias pi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pu="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
alias cat="bat"
alias icat="kitten icat"
alias ls="eza --icons=always --sort=type --header -l --git"
alias lst="eza --icons=always --sort=type --header -l --git --tree"
alias rm="trash"

# ─────────────────────────────────────────────
# Source Shells
# ─────────────────────────────────────────────
alias sb="source $HOME/.config/bash/bashrc"
alias sz="source $HOME/.config/zsh/zshrc"

# ─────────────────────────────────────────────
# Terminal
# ─────────────────────────────────────────────
alias bashc="clear && bash"
alias ff="fastfetch"
alias fishc="clear && fish"
alias l="clear"
alias n="$EDITOR ."
alias r="reset"
alias zshc="clear && zsh"

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
alias t="tmux new-session -A -s MAIN"
alias ta="tmux attach-session -t"
alias tn="tmux new-window -c "#{pane_current_path}" $EDITOR ."
alias tr="tmux rename-session"
alias tt='tmux new-session -A -s "${PWD##*/}" -c "$PWD"'
alias tts='if [ -n "$TMUX" ]; then tmux switch-client -t "${PWD##*/}" 2>/dev/null || tmux new-session -d -s "${PWD##*/}" -c "$PWD" && tmux switch-client -t "${PWD##*/}"; else tmux new-session -A -s "${PWD##*/}" -c "$PWD"; fi'

# ─────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────
alias lzd="lazydocker"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f --tail=100"
alias dcb="docker compose build --no-cache"
