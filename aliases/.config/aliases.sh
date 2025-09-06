# ─────────────────────────────────────────────
# Clipboard
# ─────────────────────────────────────────────
alias c="xclip -i -selection clipboard"
alias cc="pbcopy"

# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
alias ac="vim $HOME/.config/alacritty/alacritty.toml"
alias als="vim $HOME/.config/aliases.sh"
alias alsf="vim $HOME/.config/aliases.fish"
alias brc="vim $HOME/.config/bash/bashrc"
alias fc="vim $HOME/.config/fish/config.fish"
alias gc="vim $HOME/.config/ghostty/config"
alias i3c="vim $HOME/.config/i3/config"
alias kc="vim $HOME/.config/kitty/kitty.conf"
alias sc="vim $HOME/.config/starship/starship.toml"
alias tc="vim $HOME/.config/tmux/tmux.conf"
alias vrc="vim $HOME/.config/vim/vimrc"
alias zrc="vim $HOME/.config/zsh/zshrc"

# ─────────────────────────────────────────────
# Git
# ─────────────────────────────────────────────
alias gs="git status"

# ─────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────
alias ba="brew autoremove"
alias bc="brew cleanup"
alias be="vim $HOME/Documents/brewfile"
alias bu="brew update && brew upgrade && brew bundle --file $HOME/Documents/brewfile"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
alias cat="bat"
alias icat="kitten icat"
alias ls="eza --icons=always --sort=type --header -l"
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
alias n="vim ."
alias r="reset"
alias zshc="clear && zsh"

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
alias ta="tmux attach-session -t"
alias tn="tmux new-window -c "#{pane_current_path}" vim ."
alias tr="tmux rename-session"
alias tt='tmux new-session -A -s "${PWD##*/}" -c "$PWD"'

# ─────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcl="docker-compose logs -f --tail=100"
alias dcb="docker-compose build --no-cache"
