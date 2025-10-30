# Path/Env (macOS only)
if [ (uname) = Darwin ]
    if [ -x /opt/homebrew/bin/brew ]
        eval (/opt/homebrew/bin/brew shellenv)
    else if [ -x /usr/local/bin/brew ]
        eval (/usr/local/bin/brew shellenv)
    end
end

# Exports
if test -f $HOME/.config/exports.fish
    source $HOME/.config/exports.fish
end

# Aliases
if test -f $HOME/.config/aliases.fish
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
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Lazygit wrapper function
function lg
    set -gx LAZYGIT_NEW_DIR_FILE ~/.lazygit/newdir

    lazygit $argv

    if test -f $LAZYGIT_NEW_DIR_FILE
        cd (cat $LAZYGIT_NEW_DIR_FILE)
        rm -f $LAZYGIT_NEW_DIR_FILE >/dev/null
    end
end

# Binds
bind -M insert \cp fish_clipboard_paste
bind -M default p fish_clipboard_paste
bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f force-repaint; end"

# Theme
fish_config theme choose "Dracula Official"

# testing
# opencode
fish_add_path /home/t0mms1n/.opencode/bin
