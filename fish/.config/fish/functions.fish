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

# Pomodoro work timer (default 20m)
function work
    set -l duration (test -n "$argv[1]"; and echo $argv[1]; or echo "20m")
    timer $duration; and terminal-notifier -message 'Pomodoro' \
        -title 'Work Timer is up! Take a Break 😊' \
        -sound Crystal
end

# Pomodoro rest timer (default 5m)
function rest
    set -l duration (test -n "$argv[1]"; and echo $argv[1]; or echo "5m")
    timer $duration; and terminal-notifier -message 'Pomodoro' \
        -title 'Break is over! Get back to work 😬' \
        -sound Crystal
end
