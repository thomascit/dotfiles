#!/usr/bin/env bash
#
# Dotfiles Setup Script
# Installs config files via GNU Stow
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_REPO="git@github.com:thomascit/dotfiles.git"

# Detect dotfiles directory: use script location if run locally, otherwise default
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/.stowrc" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
fi

# Stow package groups
PACKAGES_CLI="bash bat btop eza fish lazygit nvim starship tmux vim yazi zsh"
PACKAGES_TERMINALS="alacritty ghostty kitty"
PACKAGES_WM_LINUX="hypr noctalia rofi wofi"

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
  darwin*)     OS="macos" ;;
  linux-gnu*)  OS="linux" ;;
  *)           error "Unsupported OS: $OSTYPE" ;;
  esac
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

clone_dotfiles() {
  if [[ -d "$DOTFILES_DIR" ]]; then
    success "Dotfiles already at $DOTFILES_DIR"
    info "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --rebase || warn "Could not pull latest changes"
    return
  fi

  info "Cloning dotfiles repository..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  success "Dotfiles cloned to $DOTFILES_DIR"
}

stow_packages() {
  local packages="$1"

  if ! command_exists stow; then
    error "GNU Stow is required but not installed. Please install it first."
  fi

  info "Stowing packages: $packages"

  for package in $packages; do
    if [[ -d "$DOTFILES_DIR/$package" ]]; then
      stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -v "^LINK" || true
      success "Stowed $package"
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
      stow -v -D -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 || true
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

install_tpm() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"

  if [[ -d "$tpm_dir" ]]; then
    success "TPM already installed"
    return
  fi

  info "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  success "TPM installed"
  info "Run tmux and press <prefix>+I to install plugins"
}

install_vim_plug() {
  local plug_file="$HOME/.vim/autoload/plug.vim"

  if [[ -f "$plug_file" ]]; then
    success "vim-plug already installed"
    return
  fi

  info "Installing vim-plug..."
  curl -fLo "$plug_file" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  success "vim-plug installed"
  info "Run vim and execute :PlugInstall to install plugins"
}

install_zinit() {
  local zinit_dir="$HOME/.local/share/zinit/zinit.git"

  if [[ -d "$zinit_dir" ]]; then
    success "Zinit already installed"
    return
  fi

  info "Installing Zinit (Zsh plugin manager)..."
  mkdir -p "$(dirname "$zinit_dir")"
  git clone https://github.com/zdharma-continuum/zinit "$zinit_dir"
  success "Zinit installed"
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
  if [[ "$OS" == "macos" ]]; then
    dest="$HOME/Library/Fonts"
  else
    dest="$HOME/.local/share/fonts"
  fi

  mkdir -p "$dest"
  find "$fonts_dir" -name "*.ttf" -exec cp {} "$dest/" \;
  find "$fonts_dir" -name "*.otf" -exec cp {} "$dest/" \;

  if [[ "$OS" == "linux" ]]; then
    fc-cache -f >/dev/null 2>&1 && info "Font cache refreshed"
  fi

  success "Fonts installed to $dest"
}

# ─────────────────────────────────────────────────────────────────────────────
# Install Flows
# ─────────────────────────────────────────────────────────────────────────────

run_full_install() {
  info "Installing all configs..."

  create_xdg_dirs
  clone_dotfiles
  stow_packages "$PACKAGES_CLI"
  copy_wrapper_files
  install_tpm
  install_vim_plug
  install_zinit
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

  echo ""
  echo -e "${CYAN}Available packages:${NC}"
  echo ""
  echo -e "  ${YELLOW}CLI:${NC}       $PACKAGES_CLI"
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
  install_tpm
  install_vim_plug
  install_zinit
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
    echo "  3) Terminal emulators"
    echo "  4) Window managers"
    echo "  5) Custom"
    echo ""
    prompt "Select packages to unstow [1-5]:"
    read_input unstow_choice

    case "$unstow_choice" in
    1) unstow_packages "$PACKAGES_CLI $PACKAGES_TERMINALS $(get_wm_packages)" ;;
    2) unstow_packages "$PACKAGES_CLI" ;;
    3) unstow_packages "$PACKAGES_TERMINALS" ;;
    4) unstow_packages "$(get_wm_packages)" ;;
    5)
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
  echo "  2) Custom install (select packages)"
  echo "  3) Install plugin managers only (TPM, vim-plug, Zinit)"
  echo "  4) Install fonts only"
  echo "  5) Uninstall"
  echo "  6) Exit"
  echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

main() {
  show_banner
  detect_os

  info "Detected OS: $OS"

  if ! command_exists git; then
    error "Git is required but not installed"
  fi

  if ! command_exists stow; then
    error "GNU Stow is required but not installed"
  fi

  # CLI argument handling
  case "${1:-}" in
  --full | -f)
    run_full_install
    exit 0
    ;;
  --custom | -c)
    run_custom_install
    exit 0
    ;;
  --plugins | -p)
    run_plugin_managers_only
    exit 0
    ;;
  --fonts)
    run_fonts_only
    exit 0
    ;;
  --uninstall | -u)
    run_uninstall
    exit 0
    ;;
  --help | -h)
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --full, -f      Stow all CLI configs + plugin managers + fonts"
    echo "  --custom, -c    Select specific packages to stow"
    echo "  --plugins, -p   Install plugin managers only (TPM, vim-plug, Zinit)"
    echo "  --fonts         Install fonts from reference/fonts/"
    echo "  --uninstall, -u Remove dotfile symlinks and plugin managers"
    echo "  --help, -h      Show this help message"
    echo ""
    echo "Package groups:"
    echo "  CLI:       $PACKAGES_CLI"
    echo "  Terminals: $PACKAGES_TERMINALS"
    echo "  WM:        $PACKAGES_WM_LINUX"
    echo ""
    echo "Without options, an interactive menu is shown."
    exit 0
    ;;
  esac

  # Interactive mode
  while true; do
    show_menu
    prompt "Select an option [1-6]:"
    read_input choice

    case "$choice" in
    1) run_full_install;         break ;;
    2) run_custom_install;       break ;;
    3) run_plugin_managers_only; break ;;
    4) run_fonts_only;           break ;;
    5) run_uninstall;            break ;;
    6) info "Exiting..."; exit 0 ;;
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
