# Start ssh-agent if not already running
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c)
    for key in ~/.ssh/*
        switch $key
            case "*.pub" "*known_hosts*" "*config*" "*authorized_keys*"
                continue
        end
        if test -f $key
            ssh-add $key 2>/dev/null
        end
    end
end
