# Dotfiles

Personal dotfiles for macOS/Linux. Managed with GNU Stow into `$HOME` via `.stowrc` (most configs live under `~/.config`).

[![Theme: Dracula](https://img.shields.io/badge/Theme-Dracula-bd93f9?style=flat-square)](https://draculatheme.com)

## Quick Start

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Minimal setup (shell + editor + multiplexer)
stow -v -R zsh starship tmux vim aliases exports
cp .zshrc "$HOME/"

# Or full setup
stow -v -R alacritty aliases bash bat eza exports fish fzf ghostty i3 kitty lazygit polybar starship tmux vim vimium yazi zsh
cp .bashrc .zshrc .vimrc "$HOME/"
```

## Prerequisites

### Required
- Git and GNU Stow

### Core Tools
| Category | Tools |
|----------|-------|
| **Shell & Prompt** | Bash, Zsh, Fish, Starship, Zoxide |
| **File Management** | Eza, Bat, FZF, Yazi |
| **Development** | Vim, Tmux, Lazygit |
| **Terminals** | Alacritty, Ghostty, Kitty |

### Platform Specific
- **Linux**: i3 (window manager), Polybar (status bar)

### Optional
- Figlet, Lolcat, Fastfetch

### Quick Install (macOS)
```sh
# Core tools
brew install git stow starship zoxide eza bat fzf lazygit tmux vim yazi

# Terminal emulators
brew install --cask alacritty ghostty kitty

# Optional tools
brew install figlet lolcat fastfetch 
```

### Quick Install (Linux)
```sh
# Ubuntu/Debian example - adjust package names for your distro
sudo apt install git stow zsh fish tmux vim

# Tools that may require external repos or manual installation
# starship: https://starship.rs/guide/#🚀-installation
# zoxide: https://github.com/ajeetdsouza/zoxide#installation
# eza: https://github.com/eza-community/eza#installation
# lazygit: https://github.com/jesseduffield/lazygit#installation
# yazi: https://github.com/sxyazi/yazi#installation
```

## Install

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow packages into $HOME (symlinks land under ~/.config/*)
stow -v -R alacritty aliases bash bat eza exports fish fzf ghostty i3 kitty lazygit polybar starship tmux vim vimium yazi zsh

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

| Package | Description |
|---------|-------------|
| `aliases` | Shared shell aliases for common commands |
| `alacritty` | Terminal emulator with Dracula theme |
| `bash`/`zsh`/`fish` | Shells with VI mode, Starship prompt, Zoxide |
| `bat` | Cat replacement with syntax highlighting |
| `exports` | Environment variables (XDG paths, etc.) |
| `eza` | Modern ls replacement with icons and Git status |
| `fzf` | Fuzzy finder for files and history |
| `ghostty` | Fast GPU-accelerated terminal |
| `i3` | Tiling window manager (Linux) |
| `kitty` | GPU-based terminal emulator |
| `lazygit` | Terminal UI for Git |
| `polybar` | Status bar for i3 (Linux) |
| `starship` | Fast, customizable shell prompt |
| `tmux` | Terminal multiplexer with TPM plugins |
| `vim` | Editor with vim-plug and Dracula theme |
| `vimium` | Browser extension for Vim keybindings |
| `yazi` | Terminal file manager |

## Troubleshooting

**Stow conflicts?** Use `stow -D <package>` to unstow first, then re-stow with `stow -R <package>`.

**Fonts not working?** Ensure JetBrainsMono Nerd Font is installed and your terminal is configured to use it.

**TPM plugins not loading?** In tmux, press `Ctrl+b` then `I` to install plugins.

## Notes

- `.stowrc` targets `$HOME` and ignores `fonts`. Run stow from the repo root.
- Wrapper dotfiles (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and simply source configs from `~/.config/*`.
- macOS Homebrew: shell configs detect `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel) and initialize whichever exists.
