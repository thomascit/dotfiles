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

- `gnu stow` — the only hard requirement; nothing can be linked without it
- `git` — needed only to *obtain* the repo, and only if you don't already have a
  checkout. `setup.sh` falls back to a tarball download when git is absent.

Both can be installed for you — see [Bootstrap without cloning](#bootstrap-without-cloning).

All other tools (nvim, tmux, zsh, etc.) should be installed separately beforehand. The setup script only manages config files, not package installation — the one exception is `--minimal --with-deps`, which apt-installs the server tool set on Debian/Ubuntu (see [Minimal / Server Install](#minimal--server-install)).

Every config guards the optional tools it uses, so a missing tool degrades that feature rather than breaking the shell.

**Current shell:** `zsh`

## Quick Start

```sh
git clone git@github.com:thomascit/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/setup.sh
```

### Bootstrap without cloning

On a fresh machine you can pipe the script straight from GitHub — it fetches the
repo itself:

```sh
curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh \
  | bash -s -- --minimal --with-deps
```

The `-s --` is required: it tells `bash` to read the script from stdin and pass
the remaining words through as arguments.

**The repo still ends up on disk.** Stow works by creating symlinks that point
into the checkout, so it has to stay where it lands — `~/Projects/dotfiles` by
default, or wherever `DOTFILES_DIR` points. "Without cloning" means you don't
have to clone it *yourself*, not that nothing is written.

How the repo is obtained, in order — whichever works first wins:

| Method | Requires | Result |
|---|---|---|
| SSH clone | git + an SSH key on the host | full checkout, push access |
| HTTPS clone | git | full checkout, read-only remote |
| Tarball | curl or wget, and tar | plain directory, no `.git` |

So a box with no SSH key still works, and a box with no git at all still works.
A tarball install cannot `git pull`, so re-run the bootstrap to update it.

Environment overrides:

| Variable | Default | Purpose |
|---|---|---|
| `DOTFILES_DIR` | `~/Projects/dotfiles` | where the checkout goes |
| `DOTFILES_BRANCH` | `main` | branch to fetch |

`DOTFILES_DIR` takes precedence over everything, including the script's own
location, so you can point a run at an alternate checkout deliberately.

## Setup Script

The setup script stows configs, installs plugin managers, and copies fonts. It does not install packages.

```sh
./setup.sh --full       # Stow all CLI configs + plugin managers + fonts
./setup.sh --minimal    # Server/headless: reduced set, no prompts, no network
./setup.sh --custom     # Select specific packages to stow
./setup.sh --plugins    # Install plugin managers only (TPM, vim-plug, Zinit, yazi plugins)
./setup.sh --fonts      # Install fonts from reference/fonts/
./setup.sh --uninstall  # Remove dotfile symlinks and plugin managers
./setup.sh --help       # Show help and package lists
```

`--minimal` is the only flag that is fully non-interactive; every other flow
prompts on `/dev/tty` and so cannot be scripted.

## Minimal / Server Install

For a bare Debian or Ubuntu box where you want a working shell but no desktop:

```sh
./setup.sh --minimal              # configs only
./setup.sh --minimal --with-deps  # also apt-install what the repos provide

# Or straight from GitHub on a box with nothing installed yet:
curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh \
  | bash -s -- --minimal --with-deps
```

With `--with-deps`, dependencies are installed *before* the repo is fetched, so
`git` and `stow` can be missing at the start — that is what makes the one-liner
above work on a bare host.

Stows `bash zsh fish tmux vim bat btop eza starship lazygit`. `zsh` is included
even if you never run it, because `bash/bashrc` sources
`~/.config/zsh/aliases.sh`.

Excluded on purpose: `nvim` (needs Neovim ≥ 0.9 and network for lazy.nvim),
`yazi` and `sesh` (not packaged for Debian or Ubuntu at all), `atuin` (absent
from Debian 12, and expects a sync server), plus all terminal and window
manager configs.

Skips fonts (glyphs come from your local terminal, not the server) and the
TPM / vim-plug / Zinit plugin managers, since all three need network access.
Add them later on a networked host with `./setup.sh --plugins`.

`--with-deps` needs root or `sudo`. It probes `apt-cache policy` for each
package and installs only what your host's repos actually carry, reporting the
rest — so it degrades on older releases instead of failing.

### Tool availability by release

Verified against the Debian and Ubuntu archives. The configs guard for every
tool below, so an absent one is a missing feature, never a broken shell.

| Tool | Debian 12 | Debian 13 | Ubuntu 24.04 | Ubuntu 26.04 |
|---|---|---|---|---|
| `bash` `zsh` `vim` `git` `stow` | ✅ | ✅ | ✅ | ✅ |
| `tmux` | 3.3a | 3.5a | 3.4 | ✅ |
| `fish` | 3.6 | 4.0 | 3.7 | 4.x |
| `bat` (binary `batcat`) | 0.22 | 0.25 | ✅ | ✅ |
| `fd-find` (binary `fdfind`) | 8.6 | 10.2 | ✅ | ✅ |
| `ripgrep` | 13.0 | 14.1 | ✅ | ✅ |
| `btop` | 1.2 | 1.3 | ✅ | ✅ |
| `fzf` | 0.38 | 0.60 | 0.44 | ✅ |
| `zoxide` | 0.4 | 0.9 | 0.9 | ✅ |
| `eza` | ❌ | 0.21 | 0.18 | 0.23 |
| `starship` | ❌ | 1.22 | ❌ | 1.22 |
| `atuin` | ❌ | 18.6 | ❌ | ✅ |
| `lazygit` | ❌ | 0.50 | ❌ | 0.57 |
| `neovim` | 0.7 | 0.10 | 0.9.5 | ✅ |
| `yazi` `sesh` | ❌ | ❌ | ❌ | ❌ |

Debian 13 or Ubuntu 26.04 gives you nearly everything. On Debian 12 you lose
`starship`, `eza` and `lazygit` — the prompt falls back to plain, `ls` and `cat`
stay as the coreutils versions.

`ncurses-term` is installed alongside: it provides the `tmux-256color` terminfo
entry that `tmux.conf` asks for. Without it tmux would refuse to start, though
the config also falls back to `screen-256color` as a second line of defence.

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
| `sesh` | Smart session manager for tmux (fzf-powered switcher) |
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
Run `./setup.sh --fonts` then restart the terminal. Fonts install to `~/.local/share/fonts` on Linux and `~/Library/Fonts` on macOS. On Linux, `fc-cache -f` is run automatically but you may need to restart the application.

**TPM plugins not loading?**
Start tmux and press `<prefix>+I` to install plugins. The prefix is `Ctrl+Space`.

**Neovim plugins not loading?**
lazy.nvim auto-bootstraps on first launch. If plugins are missing, open Neovim and run `:Lazy sync`.

## Secret Scanning

A `pre-commit` hook in `.githooks/` runs [gitleaks](https://github.com/gitleaks/gitleaks) against staged changes to catch accidentally committed secrets.

Activate the hook (the setup script does this automatically):

```sh
git config core.hooksPath .githooks
```

Install the scanner:

```sh
brew install gitleaks   # macOS
# Linux: see https://github.com/gitleaks/gitleaks#installing
```

If `gitleaks` is not on `PATH`, the hook prints a warning and lets the commit proceed. Bypass entirely (not recommended) with `git commit --no-verify`.

## Opencode Agent

This repo ships an [opencode](https://opencode.ai) subagent that knows the stow layout, package groups, and commit conventions used here.

| Item | Value |
|------|-------|
| Agent | `dotfiles-manager` |
| Location | [`.opencode/agents/dotfiles-manager.md`](.opencode/agents/dotfiles-manager.md) |
| Mode | `subagent` |

It handles routine maintenance — adding or editing stow packages, keeping `setup.sh` and the docs in sync, and enforcing secret-safe Git hygiene. It never commits or pushes without being asked.

Only the agent definition is tracked; everything else under `.opencode/` (node_modules, lockfiles, caches) is ignored.

## Notes

- `.stowrc` targets `$HOME` and ignores `reference/`. Run stow from the repo root.
- Wrapper files (`.bashrc`, `.zshrc`, `.vimrc`) live in the repo root and source the actual configs from `~/.config/`.
