# Path/Env (macOS only)
if [ (uname) = Darwin ]
    if [ -x /opt/homebrew/bin/brew ]
        eval (/opt/homebrew/bin/brew shellenv)
    else if [ -x /usr/local/bin/brew ]
        eval (/usr/local/bin/brew shellenv)
    end
end

# Aliases
if test -f $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/aliases.fish
end

# Functions
if test -f $HOME/.config/fish/functions.fish
    source $HOME/.config/fish/functions.fish
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

# Fzf
fzf --fish | source

# Binds
bind -M insert \cp fish_clipboard_paste
bind -M default p fish_clipboard_paste
bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f force-repaint; end"

# Theme
fish_config theme choose Dracula
