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

> _Dotfiles for developers who appreciate clean configs, powerful tools, and the Dracula aesthetic._

[![Theme: Dracula](https://img.shields.io/badge/Theme-Dracula-bd93f9?style=flat-square)](https://draculatheme.com)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Manager: GNU Stow](https://img.shields.io/badge/Manager-GNU_Stow-4EAA25?style=flat-square)](https://www.gnu.org/software/stow/)

</div>

---

## Prerequisites

Install these before running the setup script:

- `git`
- `gnu stow`

All other tools (nvim, tmux, zsh, etc.) should be installed separately beforehand. The setup script only manages config files, not package installation.

**Current shell:** `zsh`

## Quick Start

```sh
git clone git@github.com:thomascit/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/setup.sh
```

## Setup Script

The setup script stows configs, installs plugin managers, and copies fonts. It does not install packages.

```sh
./setup.sh --full       # Stow all CLI configs + plugin managers + fonts
./setup.sh --custom     # Select specific packages to stow
./setup.sh --plugins    # Install plugin managers only (TPM, vim-plug, Zinit, yazi plugins)
./setup.sh --fonts      # Install fonts from reference/fonts/
./setup.sh --uninstall  # Remove dotfile symlinks and plugin managers
./setup.sh --help       # Show help and package lists
```

## What's Inside

| Package | Description |
|---------|-------------|
| `alacritty` | Terminal emulator with Dracula theme |
| `atuin` | Shell history sync and search |
| `bash` / `zsh` / `fish` | Shells with VI mode, Starship prompt, Zoxide, shared aliases |
| `bat` | Cat replacement with syntax highlighting |
| `btop` | Resource monitor |
| `eza` | Modern ls replacement with icons and Git status |
| `ghostty` | Fast GPU-accelerated terminal |
| `hypr` | Hyprland compositor — `kitty` terminal, `firefox` browser, `nemo` file manager |
| `kitty` | GPU-based terminal emulator |
| `lazygit` | Terminal UI for Git |
| `noctalia` | Hyprland shell — bar, launcher, dock, lock screen, notifications, control center |
| `nvim` | Neovim with LazyVim + lazy.nvim configuration |
| `rofi` | Application launcher (X11) |
| `starship` | Fast, customizable shell prompt |
| `tmux` | Terminal multiplexer with TPM plugins and Dracula theme |
| `vim` | Vim with vim-plug and Dracula theme |
| `wofi` | Application launcher (Wayland) |
| `yazi` | Terminal file manager with plugins |

### Reference Files (not stowed)

| File | Description |
|------|-------------|
| `reference/fonts/` | JetBrainsMono Nerd Font |
| `reference/vimium/` | Vimium browser extension settings (Dracula theme + custom keymaps) |


## Theme

Dracula across the board — vim, nvim, fish, tmux, terminals, rofi, wofi, yazi, noctalia. See https://draculatheme.com.

## Fonts

JetBrainsMono Nerd Font is included at `reference/fonts/`. Install with:

```sh
./setup.sh --fonts
```

Terminal configs (alacritty, ghostty, kitty) and noctalia are pre-configured to use this font.

## Plugin Managers

| Tool | Manager | Notes |
|------|---------|-------|
| Vim | vim-plug | Run `:PlugInstall` on first launch |
| Neovim | lazy.nvim (LazyVim) | Auto-bootstraps on first launch |
| Zsh | Zinit | Bootstraps automatically on first shell start |
| Tmux | TPM | Press `<prefix>+I` to install plugins after first launch |
| Yazi | ya pkg | Run `ya pkg install` or use `./setup.sh --plugins` |

## Keybindings

See [`KEYBINDINGS.md`](KEYBINDINGS.md) for a full reference of all custom keybindings across every tool.

Quick per-tool references:
- [`tmux/TMUX.md`](tmux/TMUX.md) — Tmux prefix bindings and shell aliases
- [`zsh/ZSH.md`](zsh/ZSH.md) — Zsh aliases, functions, and plugins

## Uninstall

```sh
./setup.sh --uninstall
```

Options:
- **Full**: Unstow all packages + remove wrapper files + remove plugin managers
- **Unstow only**: Remove symlinks only
- **Remove plugins only**: Remove TPM, vim-plug, Zinit
- **Remove wrappers only**: Remove `.bashrc`, `.zshrc`, `.vimrc` from `$HOME`

## Troubleshooting

**Stow conflicts with existing files?**
Stow will refuse to create a symlink if a real file already exists at the target. Back it up and remove it first:
```sh
mv ~/.config/nvim ~/.config/nvim.bak
stow -R nvim
```

**Stow conflicts with existing symlinks pointing elsewhere?**
Unstow the package first to clean up, then restow:
```sh
stow -D nvim && stow nvim
```

**Fonts not showing in terminals?**
Run `./setup.sh --fonts` then restart the terminal. On Linux, `fc-cache -f` is run automatically but you may need to restart the application.

**TPM plugins not loading?**
Start tmux and press `<prefix>+I` to install plugins. The prefix is `Ctrl+Space`.

**Neovim plugins not loading?**
lazy.nvim auto-bootstraps on first launch. If plugins are missing, open Neovim and run `:Lazy sync`.

## Notes

- `.stowrc` targets `$HOME` and ignores `reference/`. Run stow from the repo root.
- Wrapper files (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and source the actual configs from `~/.config/`.
