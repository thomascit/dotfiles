# Path/Env (macOS only)
if [ (uname) = "Darwin" ]
    if [ -x /opt/homebrew/bin/brew ]
        eval (/opt/homebrew/bin/brew shellenv)
    else if [ -x /usr/local/bin/brew ]
        eval (/usr/local/bin/brew shellenv)
    end
end

# Exports
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx EZA_CONFIG_DIR $HOME/.config/eza
set -gx EDITOR vim
#set -gx XDG_CONFIG_HOME $HOME/.config

# Aliases
if [ -f $HOME/.config/aliases.fish ]
    source $HOME/.config/aliases.fish
end

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

# Fzf: load central config then enable
if test -f $HOME/.config/fzfrc.fish
    source $HOME/.config/fzfrc.fish
end
fzf --fish | source

# Yazi Shell wrapper
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


# Extras
# echo $(basename "$STARSHIP_SHELL") | figlet | lolcat --animate --speed 100

# Theme
fish_config theme choose "Dracula Official"
