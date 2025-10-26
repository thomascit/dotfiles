# Environment Variables
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx EZA_CONFIG_DIR $HOME/.config/eza
set -gx EDITOR nvim
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx GOPATH /usr/local/share/go

# Dracula Man Page Colors
set -gx MANPAGER "less -s -M +Gg"
set -gx LESS_TERMCAP_mb \e'[1;31m'      # begin bold
set -gx LESS_TERMCAP_md \e'[1;34m'      # begin blink
set -gx LESS_TERMCAP_so \e'[01;45;37m'  # begin reverse video
set -gx LESS_TERMCAP_us \e'[01;36m'     # begin underline
set -gx LESS_TERMCAP_me \e'[0m'         # reset bold/blink
set -gx LESS_TERMCAP_se \e'[0m'         # reset reverse video
set -gx LESS_TERMCAP_ue \e'[0m'         # reset underline
set -gx GROFF_NO_SGR 1                  # for konsole

# PATH
set -gx PATH $HOME/.local/bin $PATH
