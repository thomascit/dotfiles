# Dotfiles

Personal dotfiles for macOS/Linux. Managed with GNU Stow into `~/.config` via the repo’s `.stowrc`.

## Prerequisites

- Git and GNU Stow
- Optional tools used by configs: Starship, Zoxide, Eza, Bat, Neovim/Vim, Tmux, Figlet, Lolcat, Fastfetch
- Optional: tmux plugin manager (TPM)

Tip: On macOS you can install many of these with Homebrew. On Linux use your distro’s package manager and `xclip` for clipboard support.

## Install

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow selected packages into ~/.config (recommended)
stow -v -R alacritty bat eza fish ghostty i3 kitty nvim polybar starship tmux vim zsh

# Copy wrapper files that source configs from ~/.config
cp .bashrc .zshrc .vimrc "$HOME/"
```

Selective install example:

```sh
# Only Zsh + Neovim + Tmux
stow -v -R zsh nvim tmux
```

Update configs after making changes:

```sh
# Re-stow to refresh symlinks
stow -v -R <package>

# Unstow to remove a package
stow -D <package>
```

## Fonts

Includes JetBrainsMono Nerd Font at `fonts/`. Install it so terminals and prompts render glyphs:

- macOS: open the `.ttf` file to install.
- Linux: copy to `~/.local/share/fonts` then run `fc-cache -f -v`.

## Tmux + TPM

If TPM is not installed:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then inside tmux:

1. Press `<prefix> + I` (usually `Ctrl+b` then `I`) to install/update plugins.
2. Press `<prefix> + r` (usually `Ctrl+b` then `r`) to reload the config.

## What’s Inside

- Alacritty: terminal config and themes
- Bash/Zsh/Fish: shells configured with aliases, Starship, Zoxide, VI keybindings
- Bat/Eza: nicer `cat`/`ls` defaults
- Ghostty, i3, Kitty: terminal/window manager configs
- Neovim (LazyVim) + Vim: editor configs
- Polybar: status bar
- Starship: prompt configuration
- Tmux: plugins + Dracula theme
- `aliases`: shared shell aliases
- `prompt.sh`: optional animated banner (figlet + lolcat)

## Notes

- `.stowrc` targets `~/.config` and ignores `fonts` and the wrapper files. Run stow from the repo root.
- The configs assume Homebrew on macOS (`/opt/homebrew`). Adjust paths if using another setup.
