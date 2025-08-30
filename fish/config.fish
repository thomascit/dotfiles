# THEME
fish_config theme choose "Dracula Official"

# FISH CURSOR SETTING
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

# ENABLE VI BINDINGS
fish_vi_key_bindings

# DISABLE FISH GREETING
set fish_greeting

# ALIASES
source $HOME/.config/aliases

# PATH EXPORTS
eval "$(/opt/homebrew/bin/brew shellenv)"

# ENABLE STARSHIP PROMPT
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source

# ENABLE ZOXIDE
zoxide init fish | source

# EZA CONFIG DIR
set -gx EZA_CONFIG_DIR $HOME/.config/eza

# EXTRAS
$HOME/.config/prompt.sh

