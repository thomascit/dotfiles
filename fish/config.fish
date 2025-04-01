## THEME
fish_config theme choose "Dracula Official"

## FISH CURSOR SETTING
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

## ENABLE VI BINDINGS
fish_vi_key_bindings

## DISABLE FISH GREETING
set fish_greeting

## ALIASES
source ~/.config/aliases/default

## PATH EXPORTS
fish_add_path /opt/homebrew/bin .local/bin

## ENABLE STARSHIP PROMPT
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

## ENABLE ZOXIDE
zoxide init fish | source

## EXTRAS
fastfetch
