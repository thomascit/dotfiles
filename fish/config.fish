# Path/Env
eval "$(/opt/homebrew/bin/brew shellenv)"

# Exports
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx EZA_CONFIG_DIR $HOME/.config/eza

# Aliases
source $HOME/.config/fish/aliases.fish

# Cursor: Settings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_visual block

# Disable: Greeting
set fish_greeting

# Enable: Starship
starship init fish | source

# Enable: VI Keybindings
fish_vi_key_bindings

# Enable: Zoxide
zoxide init fish | source

# Extras
$HOME/.config/prompt.sh

# Theme
fish_config theme choose "Dracula Official"
