#!/usr/bin/env bash
#
# Dotfiles Setup Script
# Installs config files via GNU Stow
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_SLUG="thomascit/dotfiles"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

# Three ways in, in order of preference:
#   SSH    — push access, needs a key on the host
#   HTTPS  — read-only clone, no key, still needs git
#   Tarball— no key and no git; leaves a plain directory with no .git
DOTFILES_REPO="git@github.com:${DOTFILES_SLUG}.git"
DOTFILES_REPO_HTTPS="https://github.com/${DOTFILES_SLUG}.git"
DOTFILES_TARBALL="https://codeload.github.com/${DOTFILES_SLUG}/tar.gz/refs/heads/${DOTFILES_BRANCH}"

# Detect dotfiles directory: use script location if run locally, otherwise default.
# BASH_SOURCE[0] is unset when the script is piped (curl … | bash), and under
# `set -u` that is fatal, so it must be expanded defensively.
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  SCRIPT_DIR=""
fi

# Precedence, most explicit first:
#   1. DOTFILES_DIR from the environment — the caller said exactly where
#   2. the script's own directory, when it sits in a checkout
#   3. the documented default (matches README and the `u` alias)
if [[ -n "${DOTFILES_DIR:-}" ]]; then
  :
elif [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/.stowrc" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  DOTFILES_DIR="$HOME/Projects/dotfiles"
fi

# Stow package groups
PACKAGES_CLI="atuin bash bat btop eza fish lazygit nvim sesh starship tmux vim yazi zsh"
PACKAGES_TERMINALS="alacritty ghostty kitty"
PACKAGES_WM_LINUX="hypr noctalia rofi wofi"

# Headless/server subset. Shells, editor and multiplexer, plus config-only
# packages whose tools are in the Debian/Ubuntu repos. A stowed config for a
# tool you have not installed is just an unused symlink, so these cost nothing
# and activate later if you install the tool.
#
# Deliberately excluded:
#   nvim   — needs Neovim >= 0.9 (Debian 12 ships 0.7) and network for lazy.nvim
#   yazi   — not packaged for Debian or Ubuntu at all
#   sesh   — not packaged for Debian or Ubuntu at all
#   atuin  — not in Debian 12; also expects a sync server
# zsh is required even if unused: bash/bashrc sources ~/.config/zsh/aliases.sh.
PACKAGES_MINIMAL="bash zsh fish tmux vim bat btop eza starship lazygit"

# Packages install_apt_deps() will try. Availability is probed at runtime
# rather than assumed, so this list is safe across Debian and Ubuntu releases:
# whatever the host's repos do not carry is reported and skipped.
#   ncurses-term  provides the tmux-256color terminfo entry (tmux won't start
#                 without it, given tmux.conf's default-terminal)
#   curl          needed by install_vim_plug
#   xclip         clipboard over `ssh -X`
APT_DEPS_MINIMAL="git stow tmux vim fish zsh ncurses-term bat fd-find ripgrep \
fzf zoxide btop eza starship lazygit trash-cli xclip curl"

# Wrapper files to copy (not stowed) to $HOME
WRAPPER_FILES=".bashrc .zshrc .vimrc"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
prompt()  { echo -e "${PURPLE}[?]${NC} $1"; }

read_input() { read -r "$@" </dev/tty; }

command_exists() { command -v "$1" &>/dev/null; }

detect_os() {
  case "$OSTYPE" in
  darwin*) OS="macos" ;;
  # Match any linux-*, not just linux-gnu: musl hosts (Alpine) are still Linux
  # and should not hard-error out of a config-only installer.
  linux*)  OS="linux" ;;
  *)       error "Unsupported OS: $OSTYPE" ;;
  esac

  # Distro name, for reporting only. Nothing branches on it: package manager
  # and tool availability are probed directly, so there is no distro or version
  # table here to fall out of date.
  DISTRO_NAME=""
  if [[ "$OS" == "linux" && -r /etc/os-release ]]; then
    DISTRO_NAME="$(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-}")"
  fi
}

# Is this a Debian-family host with apt available?
is_apt_host() {
  command_exists apt-get && command_exists apt-cache
}

# Resolve how to escalate for apt. Sets SUDO to "" when already root, to "sudo"
# when available, or fails so callers can warn instead of exploding.
resolve_sudo() {
  SUDO=""
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    return 0
  fi
  if command_exists sudo; then
    SUDO="sudo"
    return 0
  fi
  return 1
}

# True when apt has a real installation candidate for the package. This is the
# core of "probe, don't assume": it answers whether *this* host can install the
# package, which is what actually matters, instead of hardcoding which release
# carries what.
apt_candidate() {
  local candidate
  candidate="$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/ {print $2; exit}')"
  [[ -n "$candidate" && "$candidate" != "(none)" ]]
}

get_wm_packages() {
  echo "$PACKAGES_WM_LINUX"
}

# ─────────────────────────────────────────────────────────────────────────────
# Core Functions
# ─────────────────────────────────────────────────────────────────────────────

create_xdg_dirs() {
  info "Creating XDG directories..."
  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.local/share"
  mkdir -p "$HOME/.local/state"
  mkdir -p "$HOME/.local/state/vim/undo"
  mkdir -p "$HOME/.cache"
  success "XDG directories created"
}

# Download and unpack the repo as a tarball. This is the no-git, no-SSH-key
# path used when bootstrapping a bare host. The result is a plain directory
# with no .git, which is fine for stow (it only needs the files to stay put)
# but means updates have to be re-fetched rather than pulled.
fetch_tarball() {
  local tmp_tar tmp_dir
  tmp_tar="$(mktemp -t dotfiles-tarball.XXXXXX)"
  tmp_dir="$(mktemp -d -t dotfiles-extract.XXXXXX)"
  # shellcheck disable=SC2064  # expand now: these paths must not change later
  trap "rm -rf '$tmp_tar' '$tmp_dir'" RETURN

  info "Downloading $DOTFILES_TARBALL"
  if command_exists curl; then
    if ! curl -fsSL "$DOTFILES_TARBALL" -o "$tmp_tar"; then
      warn "Download failed"
      return 1
    fi
  elif command_exists wget; then
    if ! wget -qO "$tmp_tar" "$DOTFILES_TARBALL"; then
      warn "Download failed"
      return 1
    fi
  else
    warn "Neither curl nor wget is available"
    return 1
  fi

  if ! command_exists tar; then
    warn "tar is not available — cannot unpack"
    return 1
  fi

  # GitHub tarballs contain a single <repo>-<ref> top-level directory;
  # --strip-components=1 drops it so files land directly in DOTFILES_DIR.
  mkdir -p "$DOTFILES_DIR"
  if ! tar -xzf "$tmp_tar" -C "$DOTFILES_DIR" --strip-components=1; then
    warn "Failed to unpack tarball"
    return 1
  fi

  # Sanity check: a valid checkout always has .stowrc at its root.
  if [[ ! -f "$DOTFILES_DIR/.stowrc" ]]; then
    warn "Unpacked tree does not look like the dotfiles repo (.stowrc missing)"
    return 1
  fi

  return 0
}

fetch_dotfiles() {
  if [[ -d "$DOTFILES_DIR" ]]; then
    success "Dotfiles already at $DOTFILES_DIR"

    # A tarball checkout has no .git, so there is nothing to pull.
    if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
      info "Not a git checkout (tarball install) — skipping update"
      return
    fi

    # Skip the rebase pull if the working tree is dirty — rebase would refuse
    # anyway, and we don't want to risk clobbering uncommitted local changes.
    if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null)" ]]; then
      warn "Working tree has uncommitted changes — skipping pull to protect local work"
      info "Commit or stash your changes, then run: git -C \"$DOTFILES_DIR\" pull --rebase"
    else
      info "Pulling latest changes..."
      git -C "$DOTFILES_DIR" pull --rebase || warn "Could not pull latest changes"
    fi
    return
  fi

  mkdir -p "$(dirname "$DOTFILES_DIR")"

  # Try in order of capability, so a host with a key keeps push access and a
  # bare host still gets a working checkout.
  if command_exists git; then
    info "Cloning via SSH..."
    if git clone --quiet "$DOTFILES_REPO" "$DOTFILES_DIR" 2>/dev/null; then
      success "Dotfiles cloned to $DOTFILES_DIR (SSH, push access)"
      return
    fi
    warn "SSH clone failed (no key on this host?) — trying HTTPS"

    info "Cloning via HTTPS..."
    if git clone --quiet "$DOTFILES_REPO_HTTPS" "$DOTFILES_DIR"; then
      success "Dotfiles cloned to $DOTFILES_DIR (HTTPS, read-only)"
      info "For push access later: git -C \"$DOTFILES_DIR\" remote set-url origin $DOTFILES_REPO"
      return
    fi
    warn "HTTPS clone failed — trying tarball"
  else
    info "git not found — fetching a tarball instead"
  fi

  if fetch_tarball; then
    success "Dotfiles unpacked to $DOTFILES_DIR (tarball, no git history)"
    info "To convert to a git checkout later, install git and re-clone."
    return
  fi

  error "Could not obtain the dotfiles repo. Install git or curl/wget, or clone manually to $DOTFILES_DIR"
}

# Back-compat alias: older call sites and muscle memory use clone_dotfiles.
clone_dotfiles() { fetch_dotfiles; }

configure_git_hooks() {
  if [[ ! -d "$DOTFILES_DIR/.githooks" ]]; then
    return
  fi

  # Tarball installs have no .git, so `git config` would fail here — and under
  # set -e that would abort the whole run.
  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    info "Not a git checkout — skipping git hooks setup"
    return
  fi

  info "Configuring git hooks (pre-commit secret scan)..."
  git -C "$DOTFILES_DIR" config core.hooksPath .githooks
  success "Git hooks enabled — pre-commit will run gitleaks on staged changes"

  if ! command_exists gitleaks; then
    warn "gitleaks is not installed — the pre-commit hook will skip scans until installed"
    if [[ "${OS:-}" == "macos" ]]; then
      info "Install with: brew install gitleaks"
    else
      info "Install: see https://github.com/gitleaks/gitleaks#installing"
    fi
  fi
}

stow_packages() {
  local packages="$1"

  if ! command_exists stow; then
    error "GNU Stow is required but not installed. Please install it first."
  fi

  info "Stowing packages: $packages"

  for package in $packages; do
    if [[ -d "$DOTFILES_DIR/$package" ]]; then
      local stow_output stow_status
      # Split declaration from assignment: `local x="$(cmd)"` would mask cmd's
      # exit code (local's own status wins). We need stow's real status.
      #
      # Run with the repo as cwd: stow reads .stowrc from the *current
      # directory*, not from -d, so without the cd the repo's ignore rules are
      # silently skipped and package docs get linked into $HOME. The subshell
      # keeps the cd from leaking into the rest of the script.
      stow_output="$(cd "$DOTFILES_DIR" && stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1)" && stow_status=0 || stow_status=$?

      # Show stow's output minus the noisy per-symlink LINK lines
      printf '%s\n' "$stow_output" | grep -v "^LINK" || true

      if [[ $stow_status -eq 0 ]]; then
        success "Stowed $package"
      else
        warn "Failed to stow $package (stow exited $stow_status) — resolve conflicts above"
      fi
    else
      warn "Package directory not found, skipping: $package"
    fi
  done
}

unstow_packages() {
  local packages="$1"

  if ! command_exists stow; then
    error "GNU Stow is required but not installed."
  fi

  info "Unstowing packages: $packages"

  for package in $packages; do
    if [[ -d "$DOTFILES_DIR/$package" ]]; then
      # cd for the same reason as stow_packages: .stowrc is read from cwd.
      (cd "$DOTFILES_DIR" && stow -v -D -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1) || true
      success "Unstowed $package"
    else
      warn "Package directory not found, skipping: $package"
    fi
  done
}

copy_wrapper_files() {
  info "Copying wrapper files to \$HOME..."

  for file in $WRAPPER_FILES; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
      if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
        info "Backing up existing $file to $file.backup"
        mv "$HOME/$file" "$HOME/$file.backup"
      fi
      cp "$DOTFILES_DIR/$file" "$HOME/$file"
      success "Copied $file"
    fi
  done
}

remove_wrapper_files() {
  info "Removing wrapper files from \$HOME..."

  for file in $WRAPPER_FILES; do
    if [[ -f "$HOME/$file" ]]; then
      rm "$HOME/$file"
      success "Removed $file"
      if [[ -f "$HOME/$file.backup" ]]; then
        mv "$HOME/$file.backup" "$HOME/$file"
        info "Restored $file from backup"
      fi
    fi
  done
}

# ─────────────────────────────────────────────────────────────────────────────
# Plugin Managers
# ─────────────────────────────────────────────────────────────────────────────

# All three plugin managers are fetched over the network. Because the script
# runs under `set -e`, an unguarded failure here would abort the whole install
# partway through — after stowing, but before fonts and the closing prompts.
# Testing the command inside an `if` exempts it from set -e (same technique as
# stow_packages), so a missing tool or an offline host warns and moves on.
install_tpm() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"

  if [[ -d "$tpm_dir" ]]; then
    success "TPM already installed"
    return
  fi

  if ! command_exists git; then
    warn "git not found — skipping TPM install"
    return
  fi

  info "Installing TPM (Tmux Plugin Manager)..."
  if git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
    success "TPM installed"
    info "Run tmux and press <prefix>+I to install plugins"
  else
    warn "Could not clone TPM (no network?) — tmux will start without plugins"
  fi
}

install_vim_plug() {
  local plug_file="$HOME/.vim/autoload/plug.vim"

  if [[ -f "$plug_file" ]]; then
    success "vim-plug already installed"
    return
  fi

  if ! command_exists curl; then
    warn "curl not found — skipping vim-plug install (vim works without it)"
    return
  fi

  info "Installing vim-plug..."
  if curl -fLo "$plug_file" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    success "vim-plug installed"
    info "Run vim and execute :PlugInstall to install plugins"
  else
    warn "Could not download vim-plug (no network?) — vim will start without plugins"
  fi
}

install_zinit() {
  local zinit_dir="$HOME/.local/share/zinit/zinit.git"

  if [[ -d "$zinit_dir" ]]; then
    success "Zinit already installed"
    return
  fi

  if ! command_exists git; then
    warn "git not found — skipping Zinit install"
    return
  fi

  info "Installing Zinit (Zsh plugin manager)..."
  mkdir -p "$(dirname "$zinit_dir")"
  if git clone https://github.com/zdharma-continuum/zinit "$zinit_dir"; then
    success "Zinit installed"
  else
    warn "Could not clone Zinit (no network?) — zsh will start without plugins"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Dependencies (apt only — no third-party repos, no curl|bash installers)
# ─────────────────────────────────────────────────────────────────────────────

install_apt_deps() {
  if ! is_apt_host; then
    warn "Not a Debian/Ubuntu host (no apt) — skipping dependency install"
    return
  fi

  if ! resolve_sudo; then
    warn "Not root and sudo not available — skipping dependency install"
    info "Install manually: $APT_DEPS_MINIMAL"
    return
  fi

  info "Refreshing apt package lists..."
  if ! $SUDO apt-get update -qq; then
    warn "apt-get update failed — continuing with existing package lists"
  fi

  # Split the wanted list by what this host can actually see. A package missing
  # here means the distro release does not carry it, which is expected on older
  # releases (Debian 12 has no eza, starship, lazygit or atuin, for example).
  local available=() missing=() pkg
  for pkg in $APT_DEPS_MINIMAL; do
    if apt_candidate "$pkg"; then
      available+=("$pkg")
    else
      missing+=("$pkg")
    fi
  done

  if ((${#available[@]})); then
    info "Installing ${#available[@]} package(s): ${available[*]}"
    if $SUDO apt-get install -y -qq "${available[@]}"; then
      success "Dependencies installed"
    else
      warn "Some packages failed to install — see apt output above"
    fi
  else
    warn "No candidate packages found — are your apt sources configured?"
  fi

  if ((${#missing[@]})); then
    echo ""
    warn "Not available in this host's repos: ${missing[*]}"
    info "The stowed configs guard for these, so their absence is handled."
    info "To get them, use a newer release or install them by another route."
  fi
}

install_atuin() {
  if command_exists atuin; then
    success "Atuin already installed"
    return
  fi

  info "Installing Atuin..."
  if [[ "${OS:-}" == "macos" ]]; then
    brew install atuin
    success "Atuin installed"
  else
    warn "Please install atuin manually: https://atuin.sh/docs/install"
  fi
}

install_yazi_plugins() {
  if ! command_exists ya; then
    warn "ya not found, skipping yazi plugin install"
    return
  fi

  info "Installing yazi plugins and flavors..."
  ya pkg install
  success "Yazi plugins installed"
}

remove_plugin_managers() {
  info "Removing plugin managers..."

  local tpm_dir="$HOME/.config/tmux/plugins/tpm"
  [[ -d "$tpm_dir" ]] && rm -rf "$tpm_dir" && success "Removed TPM"

  local plug_file="$HOME/.vim/autoload/plug.vim"
  [[ -f "$plug_file" ]] && rm "$plug_file" && success "Removed vim-plug"

  local zinit_dir="$HOME/.local/share/zinit"
  [[ -d "$zinit_dir" ]] && rm -rf "$zinit_dir" && success "Removed Zinit"
}

# ─────────────────────────────────────────────────────────────────────────────
# Fonts (from local reference directory only)
# ─────────────────────────────────────────────────────────────────────────────

install_fonts() {
  local fonts_dir="$DOTFILES_DIR/reference/fonts"

  if [[ ! -d "$fonts_dir" ]]; then
    warn "No fonts directory found at $fonts_dir, skipping"
    return
  fi

  info "Installing fonts from $fonts_dir..."

  local dest
  if [[ "${OS:-}" == "macos" ]]; then
    dest="$HOME/Library/Fonts"
  else
    dest="$HOME/.local/share/fonts"
  fi

  mkdir -p "$dest"
  # Single pass matching both TrueType and OpenType fonts.
  # The `+` terminator batches files into fewer cp invocations than `\;`.
  find "$fonts_dir" \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$dest/" +

  if [[ "${OS:-}" == "linux" ]]; then
    fc-cache -f >/dev/null 2>&1 && info "Font cache refreshed"
  fi

  success "Fonts installed to $dest"
}

# ─────────────────────────────────────────────────────────────────────────────
# Install Flows
# ─────────────────────────────────────────────────────────────────────────────

# Report which optional tools are present, so it is obvious what will and will
# not work after a minimal install. The configs guard for all of these, so an
# absent tool is a missing feature rather than a broken shell.
report_capabilities() {
  echo ""
  echo -e "${CYAN}Tool availability:${NC}"

  local tool
  for tool in zsh fish tmux vim starship zoxide fzf rg bat batcat eza btop lazygit trash; do
    if command_exists "$tool"; then
      printf "  ${GREEN}%-14s present${NC}\n" "$tool"
    else
      printf "  ${YELLOW}%-14s absent${NC}\n" "$tool"
    fi
  done

  # tmux refuses to start without this terminfo entry, so call it out directly.
  if command_exists infocmp && infocmp tmux-256color >/dev/null 2>&1; then
    printf "  ${GREEN}%-14s present${NC}\n" "tmux-256color"
  else
    printf "  ${YELLOW}%-14s absent  (tmux falls back to screen-256color)${NC}\n" "tmux-256color"
  fi
}

# Headless install: config only, no prompts, no network fetches. Safe to run
# unattended over SSH, which the interactive flows are not — read_input() reads
# from /dev/tty, so anything with a prompt cannot be scripted.
run_minimal_install() {
  info "Installing minimal (server) config set..."
  [[ -n "${DISTRO_NAME:-}" ]] && info "Distro: $DISTRO_NAME"

  create_xdg_dirs

  # Dependencies first: this may be the step that installs git and stow, both of
  # which the fetch and stow below need. That ordering is what lets
  # `curl … | bash -s -- --minimal --with-deps` work on a completely bare host.
  if [[ "${WITH_DEPS:-0}" == "1" ]]; then
    install_apt_deps
    ensure_prereqs
  else
    info "Skipping dependency install (pass --with-deps to install via apt)"
  fi

  fetch_dotfiles
  configure_git_hooks
  stow_packages "$PACKAGES_MINIMAL"
  copy_wrapper_files

  # Deliberately skipped for a server: fonts (glyphs come from the client
  # terminal, not the host), and TPM/vim-plug/Zinit (all require network).
  report_capabilities

  echo ""
  success "Minimal installation complete!"
  info "Skipped: fonts, and the TPM/vim-plug/Zinit plugin managers (network)."
  # $0 is "bash" when piped, so point at the on-disk copy instead.
  info "To add plugin managers later on a networked host: $DOTFILES_DIR/setup.sh --plugins"
}

run_full_install() {
  info "Installing all configs..."

  create_xdg_dirs
  clone_dotfiles
  configure_git_hooks
  stow_packages "$PACKAGES_CLI"
  copy_wrapper_files
  install_atuin
  install_tpm
  install_vim_plug
  install_zinit
  install_yazi_plugins
  install_fonts

  echo ""
  prompt "Install terminal emulator configs? (y/n)"
  read_input ans_term
  [[ "$ans_term" =~ ^[Yy]$ ]] && stow_packages "$PACKAGES_TERMINALS"

  echo ""
  prompt "Install window manager configs? (y/n)"
  read_input ans_wm
  [[ "$ans_wm" =~ ^[Yy]$ ]] && stow_packages "$(get_wm_packages)"

  success "Full installation complete!"
}

run_custom_install() {
  create_xdg_dirs
  clone_dotfiles
  configure_git_hooks

  echo ""
  echo -e "${CYAN}Available packages:${NC}"
  echo ""
  echo -e "  ${YELLOW}CLI:${NC}       $PACKAGES_CLI"
  echo -e "  ${YELLOW}Minimal:${NC}   $PACKAGES_MINIMAL"
  echo -e "  ${YELLOW}Terminals:${NC} $PACKAGES_TERMINALS"
  echo -e "  ${YELLOW}WM:${NC}        $PACKAGES_WM_LINUX"
  echo ""
  prompt "Enter packages to stow (space-separated):"
  read_input SELECTED_PACKAGES

  if [[ -z "$SELECTED_PACKAGES" ]]; then
    warn "No packages selected"
    return
  fi

  stow_packages "$SELECTED_PACKAGES"

  echo ""
  prompt "Copy wrapper files (.bashrc, .zshrc, .vimrc) to \$HOME? (y/n)"
  read_input ans_wrap
  [[ "$ans_wrap" =~ ^[Yy]$ ]] && copy_wrapper_files

  success "Custom installation complete!"
}

run_plugin_managers_only() {
  info "Installing plugin managers..."
  create_xdg_dirs
  install_atuin
  install_tpm
  install_vim_plug
  install_zinit
  install_yazi_plugins
  success "Plugin managers installed!"
}

run_fonts_only() {
  clone_dotfiles
  install_fonts
}

run_uninstall() {
  echo ""
  echo -e "${CYAN}Uninstall Options:${NC}"
  echo "  1) Full uninstall (unstow all + remove plugins + remove wrappers)"
  echo "  2) Unstow packages only"
  echo "  3) Remove plugin managers only"
  echo "  4) Remove wrapper files only"
  echo "  5) Cancel"
  echo ""
  prompt "Select option [1-5]:"
  read_input uninstall_choice

  case "$uninstall_choice" in
  1)
    prompt "This will remove all dotfile symlinks and plugin managers. Continue? (y/n)"
    read_input confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      unstow_packages "$PACKAGES_CLI $PACKAGES_TERMINALS $(get_wm_packages)"
      remove_wrapper_files
      remove_plugin_managers
      success "Full uninstall complete!"
    else
      info "Cancelled"
    fi
    ;;
  2)
    echo ""
    echo -e "${CYAN}Unstow Options:${NC}"
    echo "  1) All packages"
    echo "  2) CLI packages"
    echo "  3) Minimal (server) packages"
    echo "  4) Terminal emulators"
    echo "  5) Window managers"
    echo "  6) Custom"
    echo ""
    prompt "Select packages to unstow [1-6]:"
    read_input unstow_choice

    case "$unstow_choice" in
    1) unstow_packages "$PACKAGES_CLI $PACKAGES_TERMINALS $(get_wm_packages)" ;;
    2) unstow_packages "$PACKAGES_CLI" ;;
    3) unstow_packages "$PACKAGES_MINIMAL" ;;
    4) unstow_packages "$PACKAGES_TERMINALS" ;;
    5) unstow_packages "$(get_wm_packages)" ;;
    6)
      prompt "Enter packages to unstow (space-separated):"
      read_input SELECTED_PACKAGES
      unstow_packages "$SELECTED_PACKAGES"
      ;;
    *) warn "Invalid option" ;;
    esac
    ;;
  3) remove_plugin_managers ;;
  4) remove_wrapper_files ;;
  5) info "Cancelled" ;;
  *) warn "Invalid option" ;;
  esac
}

# ─────────────────────────────────────────────────────────────────────────────
# Banner & Menu
# ─────────────────────────────────────────────────────────────────────────────

show_banner() {
  echo -e "${PURPLE}"
  cat <<'EOF'
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
  echo -e "${NC}"
  echo -e "${CYAN}Dotfiles Config Installer${NC}"
  echo ""
}

show_menu() {
  echo ""
  echo -e "${CYAN}Options:${NC}"
  echo "  1) Full install (CLI + wrappers + plugin managers + fonts)"
  echo "  2) Minimal install (server/headless: shells + tmux + vim, no network)"
  echo "  3) Custom install (select packages)"
  echo "  4) Install plugin managers only (TPM, vim-plug, Zinit, yazi plugins)"
  echo "  5) Install fonts only"
  echo "  6) Uninstall"
  echo "  7) Exit"
  echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

# GNU Stow is the one true hard requirement: without it nothing can be linked.
# git is only needed to *obtain* the repo, and fetch_dotfiles can fall back to a
# tarball, so it is not required when a checkout already exists.
#
# Checks run after argument parsing so that --with-deps gets a chance to install
# them first. That ordering is what makes `curl … | bash -s -- --minimal
# --with-deps` work on a host that has neither.
ensure_prereqs() {
  # A checkout that already exists needs no fetch tool at all.
  if [[ ! -d "$DOTFILES_DIR" ]] \
     && ! command_exists git && ! command_exists curl && ! command_exists wget; then
    error "Need git, curl or wget to fetch the dotfiles — install one, e.g.: sudo apt-get install -y git"
  fi

  if ! command_exists stow; then
    if [[ "${OS:-}" == "linux" ]] && is_apt_host; then
      warn "GNU Stow is required but not installed"
      info "Install it with:  sudo apt-get install -y stow"
      info "Or re-run with:   --minimal --with-deps  (installs dependencies for you)"
      exit 1
    fi
    error "GNU Stow is required but not installed"
  fi
}

main() {
  show_banner
  detect_os

  info "Detected OS: $OS"

  # CLI argument handling. A loop rather than a single `case` so modifiers like
  # --with-deps can be combined with an action flag.
  ACTION=""
  WITH_DEPS=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --full | -f)      ACTION="full" ;;
    --minimal | -m)   ACTION="minimal" ;;
    --custom | -c)    ACTION="custom" ;;
    --plugins | -p)   ACTION="plugins" ;;
    --fonts)          ACTION="fonts" ;;
    --uninstall | -u) ACTION="uninstall" ;;
    --with-deps)      WITH_DEPS=1 ;;
    --help | -h)      ACTION="help" ;;
    *) warn "Unknown option: $1 (see --help)" ;;
    esac
    shift
  done

  if [[ "$WITH_DEPS" == "1" && "$ACTION" != "minimal" ]]; then
    warn "--with-deps only applies to --minimal; ignoring"
  fi

  # --help needs no tools; everything else does. Prereqs are checked after
  # parsing so --with-deps can install them, and inside run_minimal_install
  # rather than here for that same flow.
  case "$ACTION" in
  help) : ;;
  minimal) [[ "$WITH_DEPS" == "1" ]] || ensure_prereqs ;;
  *) ensure_prereqs ;;
  esac

  case "$ACTION" in
  full)      run_full_install;         exit 0 ;;
  minimal)   run_minimal_install;      exit 0 ;;
  custom)    run_custom_install;       exit 0 ;;
  plugins)   run_plugin_managers_only; exit 0 ;;
  fonts)     run_fonts_only;           exit 0 ;;
  uninstall) run_uninstall;            exit 0 ;;
  help)
    # $0 is "bash" when piped, which would render a misleading usage line.
    local invocation="$0"
    [[ -z "$SCRIPT_DIR" ]] && invocation="curl -fsSL <url>/setup.sh | bash -s --"
    echo "Usage: $invocation [OPTION]"
    echo ""
    echo "Options:"
    echo "  --full, -f      Stow all CLI configs + plugin managers + fonts"
    echo "  --minimal, -m   Server/headless: stow a reduced set, no prompts, no network"
    echo "  --custom, -c    Select specific packages to stow"
    echo "  --plugins, -p   Install plugin managers only (TPM, vim-plug, Zinit, yazi plugins)"
    echo "  --fonts         Install fonts from reference/fonts/"
    echo "  --uninstall, -u Remove dotfile symlinks and plugin managers"
    echo "  --help, -h      Show this help message"
    echo ""
    echo "Modifiers:"
    echo "  --with-deps     With --minimal, also apt-install what the host's repos"
    echo "                  provide (needs root or sudo). Availability is probed,"
    echo "                  so anything missing is reported and skipped."
    echo ""
    echo "Environment:"
    echo "  DOTFILES_DIR     Where to place/find the checkout (default: ~/Projects/dotfiles)"
    echo "  DOTFILES_BRANCH  Branch to fetch (default: main)"
    echo ""
    echo "Bootstrap on a bare host (no clone, no SSH key, git optional):"
    echo "  curl -fsSL https://raw.githubusercontent.com/$DOTFILES_SLUG/$DOTFILES_BRANCH/setup.sh \\"
    echo "    | bash -s -- --minimal --with-deps"
    echo ""
    echo "  The repo is fetched automatically: SSH clone if a key works, else"
    echo "  HTTPS, else a tarball when git is unavailable. It must stay on disk —"
    echo "  stow creates symlinks that point into it."
    echo ""
    echo "Package groups:"
    echo "  CLI:       $PACKAGES_CLI"
    echo "  Minimal:   $PACKAGES_MINIMAL"
    echo "  Terminals: $PACKAGES_TERMINALS"
    echo "  WM:        $PACKAGES_WM_LINUX"
    echo ""
    echo "Without options, an interactive menu is shown."
    echo "--minimal is the only flag that is fully non-interactive; every other"
    echo "flow prompts on /dev/tty and so cannot be scripted."
    exit 0
    ;;
  esac

  # Interactive mode
  while true; do
    show_menu
    prompt "Select an option [1-7]:"
    read_input choice

    case "$choice" in
    1) run_full_install;         break ;;
    2) run_minimal_install;      break ;;
    3) run_custom_install;       break ;;
    4) run_plugin_managers_only; break ;;
    5) run_fonts_only;           break ;;
    6) run_uninstall;            break ;;
    7) info "Exiting..."; exit 0 ;;
    *) warn "Invalid option, please try again" ;;
    esac
  done

  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}Done!${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${CYAN}Next steps:${NC}"
  echo "  - Restart your terminal or source your shell config"
  echo "  - Start tmux and press <prefix>+I to install plugins"
  echo ""
}

main "$@"
