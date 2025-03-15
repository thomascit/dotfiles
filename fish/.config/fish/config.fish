#if status is-interactive
#    and not set -q TMUX
#    exec tmux
#end

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

## ENABLE STARSHIP PROMPT
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

## ALIASES
source ~/.config/aliases/default

## VARIABLES

## PATH EXPORTS
fish_add_path /opt/homebrew/bin

## EXTRAS
neofetch
