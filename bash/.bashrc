# ENABLE VI BINDINGS
set -o vi

# DISABLE BASH GREETING
[ -f "$HOME/.hushlogin" ] || touch "$HOME/.hushlogin"

# ALIASES
[ -f "$HOME/.config/aliases" ] && . "$HOME/.config/aliases"

# PATH EXPORTS
export PATH="$PATH:/opt/homebrew/bin:$HOME/.local/bin"

# ENABLE STARSHIP PROMPT
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

# ENABLE ZOXIDE
eval "$(zoxide init bash)"

# VIM CONFIG DIRECTORY
export VIMINIT="source $HOME/.config/vim/.vimrc"

# EXTRAS
fastfetch