# Environment Variables
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx TERMINAL "ghostty"
set -gx EDITOR "nvim"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx GOPATH "/usr/local/share/go"

# Dracula Man Page Colors
set -gx MANPAGER "less -s -M +Gg"
set -gx LESS_TERMCAP_mb "\e[1;31m"     # begin bold
set -gx LESS_TERMCAP_md "\e[1;34m"     # begin blink
set -gx LESS_TERMCAP_so "\e[01;45;37m" # begin reverse video
set -gx LESS_TERMCAP_us "\e[01;36m"    # begin underline
set -gx LESS_TERMCAP_me "\e[0m"        # reset bold/blink
set -gx LESS_TERMCAP_se "\e[0m"        # reset reverse video
set -gx LESS_TERMCAP_ue "\e[0m"        # reset underline
set -gx GROFF_NO_SGR 1                 # for konsole

# PATH
fish_add_path "$HOME/.local/bin"

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden'
set -gx FZF_DEFAULT_OPTS '--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --layout=reverse'

# FZF ctrl-t: file completion with preview
set -gx FZF_CTRL_T_OPTS "\
  --multi \
  --reverse \
  --walker-skip .git \
  --preview 'bat -n --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# FZF ctrl-r: history search
set -gx FZF_CTRL_R_OPTS "\
  --multi \
  --reverse"

# FZF alt-c: cd into directories
set -gx FZF_ALT_C_OPTS "\
  --multi \
  --reverse"

# ZSH-VI Settings (for compatibility if needed)
set -gx ZVM_VI_ESCAPE_BINDKEY jk
set -gx ZVM_SYSTEM_CLIPBOARD_ENABLED true
set -gx ZVM_CLIPBOARD_COPY_CMD pbcopy
set -gx ZVM_CLIPBOARD_PASTE_CMD pbpaste

# LAZYGIT Settings
set -gx LAZYGIT_NEW_DIR_FILE "$HOME/.lazygit/newdir"
