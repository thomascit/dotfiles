<div align="center">

<pre>
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
</pre>

### 🎨 Personal Development Environment Configuration

> _Meticulously crafted dotfiles for macOS & Linux developers who appreciate clean configs, powerful tools, and the Dracula aesthetic._

[![Theme: Dracula](https://img.shields.io/badge/Theme-Dracula-bd93f9?style=flat-square)](https://draculatheme.com)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-999999?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/)
[![Manager: GNU Stow](https://img.shields.io/badge/Manager-GNU_Stow-4EAA25?style=flat-square)](https://www.gnu.org/software/stow/)

**Managed with GNU Stow** • **XDG Base Directory Compliant** • **Modular & Portable**

---

</div>

## Quick Start

### Automated Setup (Recommended)

```sh
# One-liner installation (clones to ~/dotfiles)
bash <(curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh)

# Or clone anywhere you prefer, then run setup
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

> **Note**: The setup script auto-detects its location. Clone the repo wherever you like and run `./setup.sh` from there.

The setup script provides:
- **Full installation**: Terminal + platform-specific packages
- **Terminal only**: Shells, editors, utilities (bash, zsh, fish, vim, nvim, tmux, etc.)
- **Platform only**: Window managers, terminal emulators, GUI apps
- **Custom installation**: Choose specific packages
- **Plugin managers**: TPM, vim-plug, and zinit
- **Fonts**: JetBrainsMono Nerd Font

Command line options:
```sh
./setup.sh --full       # Full install (terminal + platform)
./setup.sh --terminal   # Terminal packages only
./setup.sh --platform   # Platform-specific packages only
./setup.sh --stow       # Stow packages only (no software install)
./setup.sh --plugins    # Install plugin managers only
./setup.sh --fonts      # Install fonts only
./setup.sh --help       # Show help and package lists
```

Package groups:
| Group | Packages |
|-------|----------|
| **Terminal** | bash, zsh, fish, starship, tmux, vim, nvim, bat, btop, eza, lazygit, yazi |
| **macOS** | aerospace, alacritty, ghostty, kitty, homebrew, vimium |
| **Linux** | alacritty, ghostty, kitty, hypr, i3, polybar, waybar, vimium |

### Manual Setup

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Terminal only (works on any system)
stow -v -R bash zsh fish starship tmux vim nvim bat btop eza lazygit yazi
cp .bashrc .zshrc .vimrc "$HOME/"

# macOS platform packages
stow -v -R aerospace alacritty ghostty kitty homebrew vimium

# Linux platform packages
stow -v -R alacritty ghostty kitty hypr i3 polybar waybar vimium
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
- **macOS**: Aerospace (tiling window manager)
- **Linux (X11)**: i3 (window manager), Polybar (status bar)
- **Linux (Wayland)**: Hyprland (compositor), Waybar (status bar)

### Optional
- Figlet, Lolcat, Fastfetch

### Quick Install (macOS)

**Option 1: Using Brewfile (Recommended)**
```sh
# Stow the Brewfile first (from your dotfiles directory)
stow -v -R homebrew

# Install all packages
brew bundle --file "$HOME/Brewfile"
```

**Option 2: Manual Installation**
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

For automated installation, use the setup script (see [Quick Start](#quick-start)).

### Manual Installation

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow terminal packages (cross-platform)
stow -v -R bash zsh fish starship tmux vim nvim bat btop eza lazygit yazi

# Stow platform-specific packages (choose one)
stow -v -R aerospace alacritty ghostty kitty homebrew vimium  # macOS
stow -v -R alacritty ghostty kitty hypr i3 polybar waybar vimium  # Linux

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

Includes JetBrainsMono Nerd Font at `fonts/`. The setup script installs fonts automatically, or install manually:

- macOS: open the `.ttf` file to install, or run `./setup.sh --fonts`
- Linux: copy to `~/.local/share/fonts` then run `fc-cache -f -v`

> **Note**: Terminal configs (alacritty, ghostty, kitty) are pre-configured to use JetBrainsMono Nerd Font - no manual setup needed.

## Tmux + TPM

TPM (Tmux Plugin Manager) is installed automatically by the setup script, or install manually:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then start tmux and install plugins:

1. Launch tmux: `tmux`
2. Press `<prefix> + I` (default: `Ctrl+Space` then `I`) to install plugins
3. Press `<prefix> + r` (default: `Ctrl+Space` then `r`) to reload config

**Note**: Plugins are managed by TPM and are not tracked in this repository.

## Plugin Managers

The setup script installs all plugin managers automatically, or they bootstrap themselves on first use:

- **Vim**: uses `vim-plug`. The `vim/.config/vim/vimrc` auto-installs vim-plug and triggers `PlugInstall` on first run.
- **Zsh**: uses `zinit` (zdharma-continuum) for plugins. `zsh/.config/zsh/zshrc` bootstraps zinit if missing.
- **Tmux**: uses `TPM`. Unlike vim-plug and zinit, TPM does not auto-bootstrap. Install manually or use `./setup.sh --plugins`, then press `<prefix> + I` to install plugins.

## What's Inside

| Package | Description |
|---------|-------------|
| `aerospace` | Tiling window manager for macOS |
| `alacritty` | Terminal emulator with Dracula theme |
| `bash`/`zsh`/`fish` | Shells with VI mode, Starship prompt, Zoxide, shared aliases |
| `bat` | Cat replacement with syntax highlighting |
| `btop` | Resource monitor with customizable interface |
| `eza` | Modern ls replacement with icons and Git status |
| `ghostty` | Fast GPU-accelerated terminal |
| `homebrew` | Brewfile for automated package installation (macOS) |
| `hypr` | Hyprland compositor configuration (Linux) |
| `i3` | Tiling window manager (Linux) |
| `kitty` | GPU-based terminal emulator |
| `lazygit` | Terminal UI for Git |
| `nvim` | Neovim with LazyVim configuration |
| `polybar` | Status bar for i3 (Linux) |
| `starship` | Fast, customizable shell prompt |
| `tmux` | Terminal multiplexer with TPM plugins |
| `vim` | Editor with vim-plug and Dracula theme |
| `vimium` | Browser extension for Vim keybindings |
| `waybar` | Wayland status bar (Linux) |
| `yazi` | Terminal file manager with plugins |

## Troubleshooting

**Stow conflicts?** Use `stow -D <package>` to unstow first, then re-stow with `stow -R <package>`.

**Fonts not working?** Ensure JetBrainsMono Nerd Font is installed. Terminal configs are pre-configured to use it.

**TPM plugins not loading?** In tmux, press `Ctrl+Space` then `I` to install plugins.

## Notes

- `.stowrc` targets `$HOME` and ignores `fonts`. Run stow from the repo root.
- Wrapper dotfiles (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and simply source configs from `~/.config/*`.
- macOS Homebrew: shell configs detect `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel) and initialize whichever exists.
