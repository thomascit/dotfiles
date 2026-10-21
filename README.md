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
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Servers: Linux over SSH](https://img.shields.io/badge/Servers-Linux_over_SSH-FCC624?style=flat-square&logo=linux&logoColor=black)](#linux-server-install)
[![Manager: GNU Stow](https://img.shields.io/badge/Manager-GNU_Stow-4EAA25?style=flat-square)](https://www.gnu.org/software/stow/)

</div>

---

## Platform Model

| Host | Role | What gets installed |
|---|---|---|
| **macOS** | Workstation | Everything: Brewfile apps, CLI configs, terminal configs, fonts |
| **Linux** | Server, used over SSH | Only headless tools: shells, tmux, vim and CLI utilities (`--minimal`) |

Desktop Linux (Hyprland, noctalia, rofi, wofi) and the discontinued Neovim
config were removed. The last commit containing them is tagged
**`linux-final`** — `git checkout linux-final` to get them back.

## Prerequisites

- `gnu stow` — the only hard requirement; nothing can be linked without it
- `git` — needed only to *obtain* the repo, and only if you don't already have a
  checkout. `setup.sh` falls back to a tarball download when git is absent.

Both can be installed for you — see [Bootstrap without cloning](#bootstrap-without-cloning).

On macOS, tools come from the [Brewfile](#brewfile) (`./setup.sh --brew`). On a
Linux server, `--minimal --with-deps` apt-installs the headless tool set (see
[Linux Server Install](#linux-server-install)). Otherwise the script only manages
config files.

Every config guards the optional tools it uses, so a missing tool degrades that feature rather than breaking the shell.

**Current shell:** `zsh`

## Quick Start

**macOS** (install [Homebrew](https://brew.sh) first):

```sh
git clone git@github.com:thomascit/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/setup.sh --brew   # installs your local Brewfile (not in the repo — see below)
~/Projects/dotfiles/setup.sh          # interactive menu
```

**Linux server**, straight over SSH — see [Linux Server Install](#linux-server-install):

```sh
curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh \
  | bash -s -- --minimal --with-deps
```

## Brewfile

`Brewfile` is a snapshot of everything Homebrew manages on the Mac — taps,
formulae, casks, VS Code extensions and global npm packages — produced by
[`brew bundle`](https://docs.brew.sh/Brew-Bundle-and-Brewfile).

It is **local-only**: `/Brewfile` is git-ignored and was purged from history, so
the public repo does not publish the app list. A fresh clone has no Brewfile —
copy it over from another Mac (or run `brew bundle dump` there) into the repo
root before `./setup.sh --brew`, which otherwise skips with a warning.

```sh
./setup.sh --brew              # install everything in it
brew bundle check              # is anything missing?
brew bundle dump --force       # refresh it after installing something
brew bundle cleanup            # list what is installed but NOT in it
brew bundle cleanup --force    # ...and uninstall those
```

Run `brew bundle` commands from the repo root (or pass `--file=Brewfile`).
Re-dump after `brew install` so the file stays the source of truth. There is
nothing to commit — back it up some other way if you need it on another Mac.

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

The setup script stows configs, installs plugin managers, copies fonts and
(on macOS) installs the Brewfile.

```sh
# macOS only — refused on Linux
./setup.sh --full       # Brewfile (asks) + all CLI configs + plugin managers + fonts
./setup.sh --custom     # Select specific packages to stow
./setup.sh --brew       # Install everything in the Brewfile
./setup.sh --fonts      # Install fonts from reference/fonts/

# Linux server (also works on macOS)
./setup.sh --minimal    # Headless configs + Ranger plugins, no prompts

# Both
./setup.sh --plugins    # Install TPM, vim-plug, Zinit and pinned Ranger plugins
./setup.sh --uninstall  # Remove dotfile symlinks and plugin managers
./setup.sh --help       # Show help and package lists
```

Run with no flags for an interactive menu; on Linux it only offers the server
flows. `--minimal` is the only flag that is fully non-interactive; every other
flow prompts on `/dev/tty` and so cannot be scripted.

## Linux Server Install

For a Debian or Ubuntu server you reach over SSH. Only things that work inside
an SSH session are installed — no terminal emulators, fonts, GUI apps or
clipboard tools, because all of those live on the *client* (your Mac):

```sh
./setup.sh --minimal              # configs + Ranger plugins
./setup.sh --minimal --with-deps  # also apt-install what the repos provide

# Or straight from GitHub on a box with nothing installed yet:
curl -fsSL https://raw.githubusercontent.com/thomascit/dotfiles/main/setup.sh \
  | bash -s -- --minimal --with-deps
```

With `--with-deps`, dependencies are installed *before* the repo is fetched, so
`git` and `stow` can be missing at the start — that is what makes the one-liner
above work on a bare host.

Stows `bash zsh fish tmux vim bat btop eza starship lazygit ranger`. `zsh` is included
even if you never run it, because `bash/bashrc` sources
`~/.config/zsh/aliases.sh`.

Excluded on purpose: `atuin` (absent from Debian 12, and expects a sync
server), `superfile` (not packaged for Debian/Ubuntu), and the terminal
emulator configs (they run on the client).

### Clipboard over SSH (OSC 52)

There is no `xclip` on a server — it would need X forwarding. Instead, the `c`
function and tmux copy mode use **OSC 52**: an escape sequence that asks your
*local* terminal to put text on its clipboard.

```sh
cat ~/.ssh/id_ed25519.pub | c    # lands on your Mac's clipboard
```

tmux forwards it because `tmux.conf` sets `set-clipboard on`. Ghostty and kitty
allow OSC 52 writes by default; payloads are capped at roughly 100 KB.

Automatically downloads the pinned Ranger plugins after linking configs. Git
and network access are required; failed downloads warn without stopping setup.
The fzf-filter and zoxide plugins are skipped when their executables are missing;
`--with-deps` attempts to install those dependencies first.

Skips fonts (glyphs come from your local terminal, not the server) and
TPM / vim-plug / Zinit. Add those later with `./setup.sh --plugins`.

Also skips the git pre-commit hook: a server checkout is read-only in practice,
so a secret scan there has nothing to scan.

`--with-deps` needs root or `sudo`. It probes `apt-cache policy` for each
package and installs only what your host's repos actually carry, reporting the
rest — so it degrades on older releases instead of failing.

### Binary names differ on Debian/Ubuntu

Two packages install under a different name than upstream:

| apt package | binary |
|---|---|
| `bat` | `batcat` |
| `fd-find` | `fdfind` |

The shell configs alias `fd` to `fdfind`; use `batcat` explicitly on these hosts
(`cat` is not overridden). Aliases do not provide executables to scripts or
tmux popups, so `--minimal`
also symlinks `~/.local/bin/fd` → `fdfind` when `fdfind` is present and `fd` is
not, which is what the tmux project and session pickers need.

### Updating a server install

```sh
git -C ~/Projects/dotfiles pull        # git checkout (SSH or HTTPS)
```

For a tarball install there is no `.git`, so re-run the bootstrap one-liner
instead.

**Edited files take effect immediately** — stow symlinks point *into* the
checkout, so pulling is enough. You only need to re-run `--minimal` when a whole
new *package* is added, since that needs a new symlink.

### Read-only vs push access

A keyless host falls back to an HTTPS clone, which is read-only. That is usually
what you want on a server: edit on your workstation, pull on the server, no
credentials stored on the box.

To push from it later, add an SSH key to the host, register it with GitHub
(a per-repo deploy key with write access keeps the blast radius small), then:

```sh
git -C ~/Projects/dotfiles remote set-url origin git@github.com:thomascit/dotfiles.git
```

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
| `ranger` | ✅ | ✅ | ✅ | ✅ |

Debian 13 or Ubuntu 26.04 gives you nearly everything. On Debian 12 you lose
`starship`, `eza` and `lazygit` — the prompt falls back to plain and `ls`
stays as the coreutils version. `cat` is never overridden on any platform.

`ncurses-term` is installed alongside: it provides the `tmux-256color` terminfo
entry that `tmux.conf` asks for. Without it tmux would refuse to start, though
the config also falls back to `screen-256color` as a second line of defence.

## What's Inside

| Package | Description |
|---------|-------------|
| `alacritty` | Terminal emulator with Dracula theme (macOS) |
| `atuin` | Shell history sync and search |
| `bash` / `zsh` / `fish` | Shells with VI mode, Starship prompt, Zoxide, shared aliases |
| `bat` | Syntax-highlighted file viewer (invoke `bat` or `batcat`; `cat` is unchanged) |
| `btop` | Resource monitor |
| `eza` | Modern ls replacement with icons and Git status |
| `ghostty` | Fast GPU-accelerated terminal (macOS) |
| `kitty` | GPU-based terminal emulator (macOS) |
| `lazygit` | Terminal UI for Git |
| `ranger` | Terminal file manager with Dracula colors and Vim-style navigation |
| `starship` | Fast, customizable shell prompt |
| `superfile` | Modern terminal file manager (`spf`) with Dracula theme |
| `tmux` | Terminal multiplexer with TPM plugins and Dracula theme |
| `vim` | Vim with vim-plug and Dracula theme (`$EDITOR`) |

### Reference Files (not stowed)

| File | Description |
|------|-------------|
| `Brewfile` | Homebrew manifest — local-only, git-ignored; see [Brewfile](#brewfile) |
| `reference/fonts/` | JetBrainsMono Nerd Font |
| `reference/vimium/` | Vimium browser extension settings (Dracula theme + custom keymaps) |


## Theme

Dracula across the board — vim, fish, tmux, terminals, ranger, fzf. See https://draculatheme.com.

## Fonts

JetBrainsMono Nerd Font is included at `reference/fonts/`. Install with:

```sh
./setup.sh --fonts
```

Terminal configs (alacritty, ghostty, kitty) are pre-configured to use this font.
Servers need no fonts: over SSH, glyphs are drawn by your local terminal.

## Plugin Managers

| Tool | Manager | Notes |
|------|---------|-------|
| Vim | vim-plug | Run `:PlugInstall` on first launch |
| Zsh | Zinit | Bootstraps automatically on first shell start |
| Tmux | TPM | Press `<prefix>+I` to install plugins after first launch |
| Ranger | Pinned Git clones | devicons2, fzf-filter, zoxide and archives; installed by full / server install / `--plugins` |

To install just the four Ranger plugins, run
`bash ranger/.config/ranger/install-plugins.sh` from this repository, then restart
Ranger. Ignored clones are pinned to reviewed commits of
[cdump/ranger-devicons2](https://github.com/cdump/ranger-devicons2),
[MuXiu1997/ranger-fzf-filter](https://github.com/MuXiu1997/ranger-fzf-filter),
[jchook/ranger-zoxide](https://github.com/jchook/ranger-zoxide), and
[maximtrp/ranger-archives](https://github.com/maximtrp/ranger-archives). The installer never
updates or overwrites existing clones. Review upstream code before changing pins
and manually updating clean clones. Select a Nerd Font for icons; Dracula stays
unchanged. Without devicons2, Ranger uses its default filename display.
Server installs also run the installer; plugin shortcuts require the corresponding
plugin. Uninstall does not delete clones automatically.

`fzf` and `zoxide` must be on PATH; the installer skips a new plugin download
when its required executable is missing. Keep `zoxide` installed while its plugin
is present: the directory-change hook invokes it and records visits in your
shared zoxide database. Interactive `zi` also needs `fzf`. No dependencies are
installed by this script. `zf` filters the current directory live (not recursive);
Escape cancels, or use `:fzf_filter` with no query to clear an accepted filter.
Filters persist per directory unless `clear_filters_on_dir_change` is enabled
(Ranger defaults it to false).
`cz` prefills `:z ` for a directory query; `cZ` runs `:zi` interactively.
Default `f` and `/` are preserved. oscyank and quit_cd_wd are not installed.

Archives use external tools detected at runtime, e.g. `zip`/`unzip` and
`tar`/`gzip`; `7z`/`7zz`/`7za`, `rar`/`unrar` and other compressors add formats.
Python 3.9+ is needed for all plugin features. No archive tools are installed by
the installer. Mark archive(s), or highlight one with no marks, then press `ex`
and Enter (`:extract`) to extract here; `:extract "output directory"` chooses an
output directory. This argument is **not** an archive filename. `:extract_to_dirs`
extracts each selected archive into its own subdirectory; `:extract_raw FLAGS`
passes archiver-specific flags. Extraction clears Ranger's copy/cut buffer.

Mark files/directories, then press `ec`, enter `files.zip` or `files.tar.gz`, and
Enter (`:compress files.zip`). Syntax: `:compress [FLAGS] [FILENAME.EXT]`, e.g.
`:compress -9 "my files.zip"`. Bare `:compress` uses the current directory's name
plus `.zip`; quote names containing spaces. Operations run through Ranger's task
queue. Extract only trusted archives into an appropriate directory: member-path
safety and overwrite behavior depend on the external archiver, not a sandbox.

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
mv ~/.config/vim ~/.config/vim.bak
stow -R vim
```

**Ignore rules not taking effect?**
Stow reads `.stowrc` from the **current directory**, not from the directory given
with `-d`. Always run it from the repo root:
```sh
cd ~/Projects/dotfiles && stow -R -t "$HOME" tmux
```
`setup.sh` does this for you.

**Stray `~/TMUX.md` / `~/ZSH.md`?**
Hosts set up before those docs were added to `.stowrc`'s ignore list still have
them symlinked into `$HOME`. Stow no longer manages ignored files, so re-running
setup will not clean them up:
```sh
rm ~/TMUX.md ~/ZSH.md
```

**Stow conflicts with existing symlinks pointing elsewhere?**
Unstow the package first to clean up, then restow:
```sh
stow -D vim && stow vim
```

**Fonts not showing in terminals?**
Run `./setup.sh --fonts` then restart the terminal. Fonts install to `~/Library/Fonts`.

**TPM plugins not loading?**
Start tmux and press `<prefix>+I` to install plugins. The prefix is `Ctrl+Space`.

## Secret Scanning

A `pre-commit` hook in `.githooks/` runs [gitleaks](https://github.com/gitleaks/gitleaks) against staged changes to catch accidentally committed secrets.

Activate the hook (the setup script does this automatically):

```sh
git config core.hooksPath .githooks
```

Install the scanner:

```sh
brew install gitleaks   # already in the Brewfile
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
