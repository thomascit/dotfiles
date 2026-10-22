# Lazygit wrapper function
function lg
    set -gx LAZYGIT_NEW_DIR_FILE ~/.lazygit/newdir

    lazygit $argv

    if test -f $LAZYGIT_NEW_DIR_FILE
        cd (cat $LAZYGIT_NEW_DIR_FILE)
        rm -f $LAZYGIT_NEW_DIR_FILE >/dev/null
    end
end

# Ranger wrapper: follow the last visited directory on exit.
function f
    set -l tmpdir /tmp
    if set -q TMPDIR
        set tmpdir "$TMPDIR"
    end
    set -l dirfile (mktemp "$tmpdir/ranger-cd.XXXXXXXX"); or return 1
    command ranger --choosedir="$dirfile" $argv
    if test -s "$dirfile"
        read -l dir < "$dirfile"
        if test -d "$dir"
            cd -- "$dir"
        end
    end
    command rm -f -- "$dirfile"
end
