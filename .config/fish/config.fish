if status is-interactive
    # Commands to run in interactive sessions can go here
end

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
