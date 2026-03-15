# ─────────────────────────────────────────────
# Clipboard (OS-specific)
# ─────────────────────────────────────────────
if test (uname) = Darwin
    alias c pbcopy
else
    if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null
        alias c clip.exe
    else if test -n "$WAYLAND_DISPLAY"
        alias c wl-copy
    else
        alias c "xclip -i -selection clipboard"
    end
end

# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
alias ac "$EDITOR $HOME/.config/alacritty/alacritty.toml"
alias als "$EDITOR $HOME/.config/fish/aliases.*"
alias brc "$EDITOR $HOME/.config/bash/bashrc"
alias fc "$EDITOR $HOME/.config/fish/config.fish"
alias gc "$EDITOR $HOME/.config/ghostty/config"
alias hyc "$EDITOR $HOME/.config/hypr/hyprland.conf"
alias kc "$EDITOR $HOME/.config/kitty/kitty.conf"
alias sc "$EDITOR $HOME/.config/starship/starship.toml"
alias sshc "$EDITOR $HOME/.ssh/config"
alias tc "$EDITOR $HOME/.config/tmux/tmux.conf"
alias vrc "$EDITOR $HOME/.config/vim/vimrc"
alias nvrc "yazi $HOME/.config/nvim"
alias zrc "$EDITOR $HOME/.config/zsh/zshrc"
alias yc "$EDITOR $HOME/.config/yazi/yazi.toml"
alias df "yazi $HOME/.config"

# ─────────────────────────────────────────────
# Git
# ─────────────────────────────────────────────
alias ga "git add"
alias gb "git branch"
alias gcm "git commit"
alias gco "git checkout"
alias gd "git diff"
alias gl "git log --oneline --graph"
alias gp "git push"
alias gs "git status"

# ─────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────
alias ba "brew autoremove"
alias bc "brew cleanup"
alias bi "brew formulae | fzf --multi --preview 'brew info {1}' | xargs -ro brew install"
alias bic "brew casks | fzf --multi --preview 'brew info --cask {1}' | xargs -ro brew install --cask"
alias bu "brew leaves | fzf --multi --preview 'brew info {1}' | xargs -ro brew uninstall"
alias buc "brew list --cask | fzf --multi --preview 'brew info --cask {1}' | xargs -ro brew uninstall --cask"
alias bup "brew update && brew upgrade -g"

# ─────────────────────────────────────────────
# Pacman (Arch)
# ─────────────────────────────────────────────
alias pi "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias yi "yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S"
alias pri "paru -Slq 2>/dev/null | grep -a '^[a-zA-Z0-9._+-]*\$' | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias pu "pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias yu "yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns"
alias pru "paru -Qq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru -Rns"

# ─────────────────────────────────────────────
# APT (Debian/Ubuntu)
# ─────────────────────────────────────────────
alias ai "apt-cache pkgnames | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt install"
alias au "dpkg --get-selections | grep -v deinstall | cut -f1 | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt remove"

# ─────────────────────────────────────────────
# DNF (Fedora/RHEL)
# ─────────────────────────────────────────────
alias di "dnf repoquery --available -y --qf '%{name}\n' 2>/dev/null | fzf --multi --preview 'dnf info {1}' | xargs -ro sudo dnf install"
alias du "dnf repoquery --installed --qf '%{name}\n' 2>/dev/null | fzf --multi --preview 'dnf info {1}' | xargs -ro sudo dnf remove"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
if command -q fdfind
    alias fd fdfind
end
alias cat bat
alias icat "kitten icat"
alias ls "eza --icons=always --sort=type --header -l --git"
alias lst "eza --icons=always --sort=type --header -l --git --tree"
alias rm trash

# ─────────────────────────────────────────────
# Source Shells
# ─────────────────────────────────────────────
alias sf "source $HOME/.config/fish/config.fish"

# ─────────────────────────────────────────────
# Terminal
# ─────────────────────────────────────────────
alias bashc "clear && bash"
alias e exit
alias ff fastfetch
alias fishc "clear && fish"
alias l clear
alias n "$EDITOR ."
alias r reset
alias zshc "clear && zsh"
alias oc opencode

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
alias t "tmux new-session -A -s default"
alias ta "tmux attach-session -t"
alias tn "tmux new-window -c \"#{pane_current_path}\" $EDITOR ."
alias tr "tmux rename-session"
function tt
    tmux new-session -A -s (basename $PWD) -c $PWD
end

function tts
    if test -n "$TMUX"
        tmux switch-client -t (basename $PWD) 2>/dev/null; or begin
            tmux new-session -d -s (basename $PWD) -c $PWD
            tmux switch-client -t (basename $PWD)
        end
    else
        tmux new-session -A -s (basename $PWD) -c $PWD
    end
end

# ─────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────
alias ld lazydocker
alias dcu "docker compose up -d"
alias dcd "docker compose down"
alias dcl "docker compose logs -f --tail=100"
alias dcb "docker compose build --no-cache"

# ─────────────────────────────────────────────
# Pomodoro
# ─────────────────────────────────────────────
alias p50 "work 50m && rest 10m"
alias p20 "work 20m && rest 10m"
