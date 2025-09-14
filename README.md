# Dotfiles

Personal dotfiles for macOS/Linux. Managed with GNU Stow into `$HOME` via `.stowrc` (most configs live under `~/.config`).

## Quick Start

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Minimal setup (shell + editor + multiplexer)
stow -v -R zsh starship tmux vim
cp .zshrc "$HOME/"

# Or full setup
stow -v -R alacritty aliases bash bat ccstatusline eza exports fish fzf ghostty i3 kitty lazygit ncspot polybar starship tmux vim vimium yazi zsh
cp .bashrc .zshrc .vimrc "$HOME/"
```

## Prerequisites

### Required
- Git and GNU Stow

### Core Tools
- **Shell & Prompt**: Bash, Zsh, Fish, Starship, Zoxide
- **File Management**: Eza, Bat, FZF, Yazi
- **Development**: Vim, Tmux, Lazygit
- **Terminals**: Alacritty, Ghostty, Kitty

### Platform Specific
- **Linux**: i3, Polybar
- **Development**: Claude Code (ccstatusline)
- **Media**: Ncspot (Spotify TUI)

### Optional
- Figlet, Lolcat, Fastfetch

### Quick Install (macOS)
```sh
# Core tools
brew install git stow starship zoxide eza bat fzf lazygit tmux vim

# Terminal emulators
brew install --cask alacritty ghostty kitty

# Optional tools
brew install figlet lolcat fastfetch ncspot yazi
```

### Quick Install (Linux)
```sh
# Ubuntu/Debian example - adjust package names for your distro
sudo apt install git stow starship zoxide exa bat fzf lazygit tmux vim figlet lolcat

# Additional tools may need manual installation or different repos
```

## Install

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow packages into $HOME (symlinks land under ~/.config/*)
stow -v -R alacritty aliases bash bat ccstatusline eza exports fish fzf ghostty i3 kitty lazygit ncspot polybar starship tmux vim vimium yazi zsh

# Copy wrapper files that source configs from ~/.config
cp .bashrc .zshrc .vimrc "$HOME/"
```

Selective install example:

```sh
# Only Zsh + Vim + Tmux
stow -v -R zsh vim tmux
```

Update configs after making changes:

```sh
# Re-stow to refresh symlinks
stow -v -R <package>

# Unstow to remove a package
stow -D <package>
```

## Linux: bat vs batcat

On some distributions (e.g., Debian/Ubuntu), the `bat` executable is installed as `batcat`. You can symlink it to `bat`:

```sh
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

Make sure `~/.local/bin` is on your `PATH`.

## Theme

Dracula is the preferred theme across these dotfiles. Many configs default to a Dracula theme or variant (e.g., Vim colorscheme, Fish theme, tmux theme, terminal themes). For more details, themes, and supported apps, see https://draculatheme.com.

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

## Plugin Managers

- Vim: uses `vim-plug`. The `vim/.config/vim/vimrc` auto-installs vim-plug and triggers `PlugInstall` on first run.
- Zsh: uses `zinit` (zdharma-continuum) for plugins. `zsh/.config/zsh/zshrc` bootstraps zinit if missing.

## What's Inside

- Alacritty: terminal config and themes
- Bash/Zsh/Fish: shells configured with aliases, Starship, Zoxide, VI keybindings
- Bat/Eza: nicer `cat`/`ls` defaults
- ccstatusline: Claude Code status line configuration
- Exports: environment variable configurations
- FZF: fuzzy finder configuration
- Ghostty, i3, Kitty: terminal/window manager configs
- Lazygit: Git TUI configuration
- Ncspot: Spotify TUI client configuration
- Polybar: status bar configuration
- Starship: prompt configuration
- Tmux: plugins + Dracula theme
- Vim: editor configs
- Vimium: browser extension configuration
- Yazi: file manager configuration
- `aliases`: shared shell aliases

## Notes

- `.stowrc` targets `$HOME` and ignores `fonts`. Run stow from the repo root.
- Wrapper dotfiles (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and simply source configs from `~/.config/*`.
- macOS Homebrew: shell configs detect `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel) and initialize whichever exists.
