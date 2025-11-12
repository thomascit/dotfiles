# Environment Variables
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export TERMINAL="ghostty"
export EDITOR="nvim"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export GOPATH="/usr/local/share/go"

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

#######
# FXF #
#######
# Default command
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# Default theme/colors (Dracula)
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --layout=reverse'

# ctrl-t: file completion with preview via bat
export FZF_CTRL_T_OPTS="
  --multi
  --reverse
  --walker-skip .git
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# ctrl-r: history search
export FZF_CTRL_R_OPTS="
  --multi
  --reverse"

# alt-c: cd into directories
export FZF_ALT_C_OPTS="
  --multi
  --reverse"
 
# ZSH-VI Settings
export ZVM_VI_ESCAPE_BINDKEY=jk
export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
# (MAC)
export ZVM_CLIPBOARD_COPY_CMD='pbcopy'
export ZVM_CLIPBOARD_PASTE_CMD='pbpaste'
# (LINUX)
# ZVM_CLIPBOARD_COPY_CMD='xclip -selection clipboard'
# ZVM_CLIPBOARD_PASTE_CMD='xclip -selection clipboard -o'

# LAZYGIT Settings
export LAZYGIT_NEW_DIR_FILE=$HOME/.lazygit/newdir
