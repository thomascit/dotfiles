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

# Reload Config
alias u "$HOME/Projects/dotfiles/setup.sh"
# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
alias ac "$EDITOR $HOME/.config/alacritty/alacritty.toml"
alias als "$EDITOR $HOME/.config/zsh/aliases.sh"
alias alsf "$EDITOR $HOME/.config/fish/aliases.fish"
alias brc "$EDITOR $HOME/.config/bash/bashrc"
alias fc "$EDITOR $HOME/.config/fish/config.fish"
alias gc "$EDITOR $HOME/.config/ghostty/config"
alias hyc "$EDITOR $HOME/.config/hypr/hyprland.conf"
alias kc "$EDITOR $HOME/.config/kitty/kitty.conf"
alias sc "$EDITOR $HOME/.config/starship/starship.toml"
alias sshc "$EDITOR $HOME/.ssh/config"
alias tc "$EDITOR $HOME/.config/tmux/tmux.conf"
alias vrc "$EDITOR $HOME/.config/vim/vimrc"
alias zrc "$EDITOR $HOME/.config/zsh/zshrc"
alias zpc "$EDITOR $HOME/.config/zsh/.zprofile"
alias vc "$EDITOR $HOME/.config/fish/variables.fish"
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
alias dnfi "dnf repoquery --available -y --qf '%{name}\n' 2>/dev/null | fzf --multi --preview 'dnf info {1}' | xargs -ro sudo dnf install"
# Note: not 'du' — that shadows the disk-usage builtin.
alias dnfu "dnf repoquery --installed --qf '%{name}\n' 2>/dev/null | fzf --multi --preview 'dnf info {1}' | xargs -ro sudo dnf remove"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
if command -q fdfind
    alias fd fdfind
end
# Debian/Ubuntu ship bat as `batcat` (the `bat` name clashes with
# bacula-console-qt). Guard both, and leave `cat` alone if neither exists —
# an unguarded alias here breaks `cat` shell-wide.
if command -q bat
    alias cat bat
else if command -q batcat
    alias cat batcat
end
if command -q kitten
    alias icat "kitten icat"
end
# eza is absent from Debian 12's repos; without a guard this breaks `ls`.
if command -q eza
    alias ls "eza --icons=always --sort=type --header -l --git"
    alias lst "eza --icons=always --sort=type --header -l --git --tree"
end
if command -q trash
    alias rm trash
end

# ─────────────────────────────────────────────
# Source Shells
# ─────────────────────────────────────────────
alias sf "source $HOME/.config/fish/config.fish"
# Add SSH keys to the already-running agent (systemd ssh-agent.socket on Linux,
# launchd on macOS); SSH_AUTH_SOCK is exported in variables.fish. Not piped to
# /dev/null: ssh-add prompts for the key passphrase on stderr.
alias sa "ssh-add ~/.ssh/id_ed25519"

# ─────────────────────────────────────────────
# Terminal
# ─────────────────────────────────────────────
alias bashc "clear && bash"
alias e exit
alias ff fastfetch
alias fishc "clear && fish"
alias l clear
alias v "$EDITOR ."
alias r reset
alias zshc "clear && zsh"
alias oc opencode

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
alias tma "tmux attach-session -t"
alias tmn "tmux new-window -c \"#{pane_current_path}\" $EDITOR ."
alias tmr "tmux rename-session"

# tm — fzf over the directories in $PROJECTS_DIR (default ~/Projects). The
# chosen directory becomes the session's working directory and its basename the
# session name; an existing session for that project is reused.
# `find` rather than `fd` so this works on hosts that only have fd-find's
# `fdfind` binary.
function tm
    set -l root $PROJECTS_DIR
    test -z "$root"; and set root "$HOME/Projects"
    if not test -d "$root"
        echo "tm: $root not found" >&2
        return 1
    end

    # --with-nth=-1 shows just the basename while fzf still returns the path.
    set -l dir (
        find "$root" -mindepth 1 -maxdepth 1 -type d | sort \
            | fzf --no-sort --height 40% --reverse --border \
                --delimiter=/ --with-nth=-1 \
                --border-label " projects " --prompt "project > " \
                --preview 'ls -A {}' --preview-window 'right,50%'
    )
    test -z "$dir"; and return

    # tmux rewrites "." and ":" to "_" in session names; do it up front so the
    # has-session check compares against the name tmux would actually create.
    set -l name (basename "$dir" | tr '.:' '__')

    tmux has-session -t "=$name" 2>/dev/null
    or tmux new-session -d -s "$name" -c "$dir"

    _tmux_goto "$name"
end

function tmt
    tmux new-session -A -s (basename $PWD) -c $PWD
end

function tmts
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
# Session pickers
# ─────────────────────────────────────────────
# Enter a session: switch when already inside tmux, attach when outside.
# "=" forces an exact name match, so "dot" cannot match "dotfiles".
function _tmux_goto
    if test -n "$TMUX"
        tmux switch-client -t "=$argv[1]"
    else
        tmux attach-session -t "=$argv[1]"
    end
end

# s — fzf over the running sessions, windows listed in the preview.
# Shell twin of tmux's `prefix + s`. Brace-free tmux formats (#S, #I, #W) are
# used because "{...}" is fzf's own placeholder syntax inside --preview.
function s
    set -l picked (
        tmux list-sessions -F '#S' 2>/dev/null \
            | fzf --no-sort --height 40% --reverse --border \
                --border-label " sessions " --prompt "session > " \
                --preview 'tmux list-windows -t ={} -F "#I: #W"' \
                --preview-window 'right,50%'
    )
    test -z "$picked"; and return

    _tmux_goto "$picked"
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
# SSH
# ─────────────────────────────────────────────
alias sskg "ssh-keygen -o -a 100 -t ed25519 -C"

# ─────────────────────────────────────────────
# Pomodoro
# ─────────────────────────────────────────────
alias p50 "work 50m && rest 10m"
alias p20 "work 20m && rest 10m"
