# Start ssh-agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  for key in ~/.ssh/*; do
    case "$key" in
      *.pub|*known_hosts*|*config*|*authorized_keys*) continue ;;
    esac
    [ -f "$key" ] && ssh-add "$key" 2>/dev/null
  done
fi
