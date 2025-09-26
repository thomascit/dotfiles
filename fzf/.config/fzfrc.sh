#!/usr/bin/env bash
# fzf configuration shared across shells

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
  --reverse
  --walker-skip .*"
