if status is-interactive
    # Commands to run in interactive sessions can go here
end

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
starship init fish | source

## ALIASES
source $HOME/.aliases

## VARIABLES

## PATH EXPORTS
