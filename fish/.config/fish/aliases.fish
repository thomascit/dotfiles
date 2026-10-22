# ─────────────────────────────────────────────
# Clipboard
# ─────────────────────────────────────────────
for retired in fc yc df cat p40 p50 p20 y work rest hyc pi yi pri pu yu pru dnfi dnfu
    functions -e $retired
end
# macOS: pbcopy. Anywhere else (a Linux server over SSH): OSC 52, an escape
# sequence asking the *client* terminal to set its clipboard, so no display or
# xclip is needed. tmux forwards it (set-clipboard on). Terminals cap the
# payload, typically around 100 KB. Usage: `cmd | c` or `c FILE`.
function c
    if test (uname) = Darwin; and command -q pbcopy
        cat $argv | command pbcopy
        return
    end
    # Piped into `read`, not captured with (…): a command substitution inside a
    # function does not receive the pipeline's stdin, so `cmd | c` would be empty.
    cat $argv | base64 | tr -d '\r\n' | read -l data
    printf '\e]52;c;%s\a' "$data" >/dev/tty
end

# Run the dotfiles setup menu (does not reload the shell).
alias u "$HOME/Projects/dotfiles/setup.sh"
# ─────────────────────────────────────────────
# Edit Config Files
# ─────────────────────────────────────────────
function _edit
    set -l editor vim
    if test -n "$EDITOR"
        set editor (string split --no-empty ' ' -- "$EDITOR")
    end
    command $editor $argv
end
alias ac '_edit "$HOME/.config/alacritty/alacritty.toml"'
alias als '_edit "$HOME/.config/zsh/aliases.sh"'
alias alsf '_edit "$HOME/.config/fish/aliases.fish"'
alias brc '_edit "$HOME/.config/bash/bashrc"'
alias fsh '_edit "$HOME/.config/fish/config.fish"'
alias gc '_edit "$HOME/.config/ghostty/config"'
alias kc '_edit "$HOME/.config/kitty/kitty.conf"'
alias sc '_edit "$HOME/.config/starship/starship.toml"'
alias sshc '_edit "$HOME/.ssh/config"'
alias tc '_edit "$HOME/.config/tmux/tmux.conf"'
alias vrc '_edit "$HOME/.config/vim/vimrc"'
alias zrc '_edit "$HOME/.config/zsh/zshrc"'
alias zpc '_edit "$HOME/.config/zsh/.zprofile"'
alias vc '_edit "$HOME/.config/fish/variables.fish"'

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
# APT (Debian/Ubuntu servers)
# ─────────────────────────────────────────────
alias ai "apt-cache pkgnames | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt install"
alias au "dpkg --get-selections | grep -v deinstall | cut -f1 | fzf --multi --preview 'apt-cache show {1}' | xargs -ro sudo apt remove"

# ─────────────────────────────────────────────
# LS/FS
# ─────────────────────────────────────────────
if command -q fdfind
    alias fd fdfind
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
# Add SSH keys to the already-running agent (launchd on macOS, systemd
# ssh-agent.socket on a Linux server); SSH_AUTH_SOCK is exported in variables.fish. Not piped to
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
alias v '_edit'
alias r reset
alias zshc "clear && zsh"
alias oc opencode
alias o "opencode --continue"
# saf [url|file] — open in Safari; bare domains get https:// prepended.
function saf
    if test -z "$argv[1]"; or test -e "$argv[1]"; or string match -q '*://*' -- "$argv[1]"
        open -a Safari $argv
    else
        open -a Safari "https://$argv[1]"
    end
end

# ─────────────────────────────────────────────
# Tmux
# ─────────────────────────────────────────────
# Sourcing a changed file does not remove functions from this shell.
# Fish aliases are functions too; clear only our retired tmux shortcuts.
for retired in tmr tmt tmp
    functions -q $retired; and functions -e $retired
end
alias tm tmux
alias t tmux
alias tma "tmux attach-session -t"

# ─────────────────────────────────────────────
# Session and project pickers
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

# s — fzf over the running sessions.
# Shell twin of tmux's `prefix + s`.
function s
    set -l picked (
        tmux list-sessions -F '#S' 2>/dev/null \
            | fzf --no-sort --height 40% --reverse --border \
                --border-label " sessions " --prompt "session > "
    )
    test -z "$picked"; and return

    _tmux_goto "$picked"
end

# p — fzf over directories directly under ~/Projects; cd only.
function p
    if not command -q fzf
        echo "p: fzf not found" >&2
        return 1
    end
    if not test -d "$HOME/Projects"
        echo "p: ~/Projects not found" >&2
        return 1
    end

    set -l picked (
        for dir in "$HOME"/Projects/*
            test -d "$dir"; and string replace -r '^.*/' '' -- "$dir"
        end | fzf --no-sort --height 40% --reverse --border \
            --border-label " projects " --prompt "project > "
    )
    test -z "$picked"; and return

    cd -- "$HOME/Projects/$picked"
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
