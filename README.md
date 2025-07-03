# Dotfiles

These are my personal dotfiles that configure my development environment and tools.

## Prerequisites

- GNU Stow
- Git
- tmux plugin manager (TPM)

## Configurations

- Alacritty
- Fish
- Ghostty
- i3
- Kitty
- Neovim
- Polybar
- Starship
- Tmux

## Installation

```sh
git clone https://github.com/thomascit/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

## Usage

To reload TPM and apply your tmux configuration:

1. Start a tmux session:
   ```sh
   tmux
   ```
2. Inside tmux, press `<prefix> + I` (usually `Ctrl+b I`) to install any new or updated plugins.
3. Press `<prefix> + r` (usually `Ctrl+b r`) to reload the tmux configuration.
