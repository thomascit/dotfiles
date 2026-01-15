<div align="center">

<pre>
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
</pre>

### Personal Development Environment Configuration

> _Meticulously crafted dotfiles for macOS & Linux developers who appreciate clean configs, powerful tools, and the Dracula aesthetic._

[![Theme: Dracula](https://img.shields.io/badge/Theme-Dracula-bd93f9?style=flat-square)](https://draculatheme.com)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-999999?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/)
[![Manager: GNU Stow](https://img.shields.io/badge/Manager-GNU_Stow-4EAA25?style=flat-square)](https://www.gnu.org/software/stow/)

**Managed with GNU Stow** • **XDG Base Directory Compliant** • **Modular & Portable**

---

</div>

## Quick Start

```sh
# One-liner installation
bash <(curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh)

# Or clone first, then run setup
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

> **Note**: The setup script auto-detects its location. Clone the repo wherever you like and run `./setup.sh` from there.

## Setup Script

The setup script handles OS detection, package installation, stowing configs, and plugin manager setup.

### Installation Options

| Option | Description |
|--------|-------------|
| **Full** | Terminal + platform-specific packages |
| **Terminal** | Shells, editors, utilities (recommended for WSL) |
| **Platform** | Window managers, terminal emulators, GUI apps |
| **Custom** | Choose specific packages |

### Command Line

```sh
./setup.sh --full       # Full install (terminal + platform)
./setup.sh --terminal   # Terminal packages only
./setup.sh --platform   # Platform-specific packages only
./setup.sh --stow       # Stow packages only (no software install)
./setup.sh --plugins    # Install plugin managers only
./setup.sh --fonts      # Install fonts only
./setup.sh --help       # Show help and package lists
```

### Package Groups

| Group | Packages |
|-------|----------|
| **Terminal** | bash, zsh, fish, starship, tmux, vim, nvim, bat, btop, eza, lazygit, yazi |
| **macOS** | aerospace, alacritty, ghostty, kitty |
| **Linux** | alacritty, ghostty, kitty, hypr, i3, polybar, waybar |

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
| `hypr` | Hyprland compositor configuration (Linux) |
| `i3` | Tiling window manager (Linux) |
| `kitty` | GPU-based terminal emulator |
| `lazygit` | Terminal UI for Git |
| `nvim` | Neovim with LazyVim configuration |
| `polybar` | Status bar for i3 (Linux) |
| `starship` | Fast, customizable shell prompt |
| `tmux` | Terminal multiplexer with TPM plugins |
| `vim` | Editor with vim-plug and Dracula theme |
| `waybar` | Wayland status bar (Linux) |
| `yazi` | Terminal file manager with plugins |

### Reference Files (not stowed)

| File | Description |
|------|-------------|
| `reference/Brewfile` | Homebrew packages for macOS |
| `reference/fonts/` | JetBrainsMono Nerd Font |
| `reference/vimium/` | Vimium browser extension settings |

## Theme

Dracula is the preferred theme across these dotfiles. Many configs default to a Dracula theme or variant (Vim, Fish, tmux, terminals). For more details, see https://draculatheme.com.

## Fonts

JetBrainsMono Nerd Font is included at `reference/fonts/`. The setup script installs fonts automatically. Terminal configs (alacritty, ghostty, kitty) are pre-configured to use this font.

## Plugin Managers

The setup script installs all plugin managers automatically, or they bootstrap themselves on first use:

- **Vim**: uses `vim-plug` - auto-installs and runs `PlugInstall` on first run
- **Zsh**: uses `zinit` - bootstraps automatically if missing
- **Tmux**: uses `TPM` - requires `<prefix> + I` to install plugins after setup

## Troubleshooting

**Stow conflicts?** Run `stow -D <package>` to unstow first, then `stow -R <package>`.

**Fonts not working?** Ensure JetBrainsMono Nerd Font is installed via `./setup.sh --fonts`.

**TPM plugins not loading?** In tmux, press `Ctrl+Space` then `I` to install plugins.

## Notes

- `.stowrc` targets `$HOME` and ignores `reference/`. Run stow from the repo root.
- Wrapper dotfiles (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and source configs from `~/.config/*`.
- macOS Homebrew: shell configs detect `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel) automatically.
