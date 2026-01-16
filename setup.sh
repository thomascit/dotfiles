#!/usr/bin/env bash
#
# Dotfiles Setup Script
# Automated installation for macOS and Linux
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_REPO="https://github.com/thomascit/dotfiles.git"

# Detect dotfiles directory: use script location if run locally, otherwise default
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/.stowrc" ]]; then
    # Script is running from within the dotfiles repo
    DOTFILES_DIR="$SCRIPT_DIR"
else
    # Script is being piped from curl or run from elsewhere
    DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
fi

# Stow packages by category
# Terminal: shell, prompt, multiplexer, editors, file managers, utilities
PACKAGES_TERM="bash zsh fish starship tmux vim nvim bat btop eza lazygit yazi"

# Platform-specific packages
PACKAGES_MACOS="aerospace alacritty ghostty kitty"
PACKAGES_LINUX="alacritty ghostty kitty hypr i3 polybar waybar"

# Combined full packages (built dynamically based on OS)
PACKAGES_FULL=""

# Wrapper files to copy to $HOME
WRAPPER_FILES=".bashrc .zshrc .vimrc"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

prompt() {
    echo -e "${PURPLE}[?]${NC} $1"
}

# Read user input (works even when script is piped)
read_input() {
    read -r "$@" < /dev/tty
}

command_exists() {
    command -v "$1" &>/dev/null
}

detect_os() {
    case "$OSTYPE" in
        darwin*)
            OS="macos"
            ;;
        linux-gnu*)
            OS="linux"
            # Detect distribution
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                DISTRO="$ID"
            else
                DISTRO="unknown"
            fi
            # Detect WSL
            if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
                IS_WSL=true
            else
                IS_WSL=false
            fi
            ;;
        *)
            error "Unsupported operating system: $OSTYPE"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────────────────
# Installation Functions
# ─────────────────────────────────────────────────────────────────────────────

install_xcode_cli() {
    if [[ "$OS" != "macos" ]]; then
        return
    fi

    if xcode-select -p &>/dev/null; then
        success "Xcode Command Line Tools already installed"
        return
    fi

    info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    until xcode-select -p &>/dev/null; do
        sleep 5
    done

    success "Xcode Command Line Tools installed"
}

install_homebrew() {
    if command_exists brew; then
        success "Homebrew already installed"
        return
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    if [[ "$OS" == "macos" ]]; then
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    elif [[ "$OS" == "linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    success "Homebrew installed"
}

install_linux_packages() {
    info "Installing base packages for Linux..."

    local packages=""
    local install_cmd=""
    local failed_packages=()

    case "$DISTRO" in
        debian|ubuntu|mint|kali|parrotos)
            sudo apt update
            packages="git stow curl zsh fish tmux vim ripgrep build-essential btop lazygit trash-cli"
            install_cmd="sudo apt install -y"
            ;;
        fedora|asahi)
            packages="git stow curl zsh fish tmux vim ripgrep btop lazygit trash-cli"
            install_cmd="sudo dnf install -y"
            ;;
        opensuse*)
            packages="git stow curl zsh fish tmux vim ripgrep btop lazygit trash-cli"
            install_cmd="sudo zypper install -y"
            ;;
        arch|steamos|cachyos|bazzite)
            sudo pacman -Syu --noconfirm
            packages="git stow curl zsh fish tmux vim ripgrep base-devel btop lazygit trash-cli"
            install_cmd="sudo pacman -S --noconfirm"
            ;;
        *)
            warn "Unknown distribution: $DISTRO"
            warn "Please install git, stow, curl, zsh, tmux, and vim manually"
            return
            ;;
    esac

    for pkg in $packages; do
        if ! $install_cmd "$pkg" 2>/dev/null; then
            failed_packages+=("$pkg")
        fi
    done

    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        warn "Failed to install: ${failed_packages[*]}"
    else
        success "Base Linux packages installed"
    fi
}

install_packages_from_brewfile() {
    if [[ ! -f "$DOTFILES_DIR/reference/Brewfile" ]]; then
        warn "Brewfile not found, skipping package installation"
        return
    fi

    info "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/reference/Brewfile" || warn "Some packages may have failed to install"
    success "Brewfile packages installed"
}

install_starship() {
    if command_exists starship; then
        success "Starship already installed"
        return
    fi

    info "Installing Starship prompt..."
    if curl -sS https://starship.rs/install.sh | sh -s -- -y 2>/dev/null; then
        success "Starship installed"
    else
        warn "starship: failed to install"
    fi
}

install_additional_linux_tools() {
    info "Installing additional tools for Linux..."
    local failed_tools=()

    # zoxide (install latest from GitHub)
    if ! command_exists zoxide; then
        info "Installing zoxide..."
        if zoxide_version=$(curl -sS https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v') && [[ -n "$zoxide_version" ]]; then
            local zoxide_arch
            case "$(uname -m)" in
                x86_64) zoxide_arch="x86_64" ;;
                aarch64|arm64) zoxide_arch="aarch64" ;;
                armv7l) zoxide_arch="armv7" ;;
                *) zoxide_arch="x86_64" ;;
            esac
            if curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/v${zoxide_version}/zoxide-${zoxide_version}-${zoxide_arch}-unknown-linux-musl.tar.gz" | sudo tar -xz -C /usr/local/bin zoxide 2>/dev/null; then
                success "zoxide ${zoxide_version} installed"
            else
                failed_tools+=("zoxide")
            fi
        else
            failed_tools+=("zoxide")
        fi
    fi

    # fzf (install latest from GitHub for shell integration support)
    if ! command_exists fzf; then
        info "Installing fzf..."
        if fzf_version=$(curl -sS https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v') && [[ -n "$fzf_version" ]]; then
            local fzf_arch
            case "$(uname -m)" in
                x86_64) fzf_arch="amd64" ;;
                aarch64|arm64) fzf_arch="arm64" ;;
                armv7l) fzf_arch="armv7" ;;
                *) fzf_arch="amd64" ;;
            esac
            if curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${fzf_version}/fzf-${fzf_version}-linux_${fzf_arch}.tar.gz" | sudo tar -xz -C /usr/local/bin 2>/dev/null; then
                success "fzf ${fzf_version} installed"
            else
                failed_tools+=("fzf")
            fi
        else
            failed_tools+=("fzf")
        fi
    fi

    # neovim (install latest from GitHub)
    if ! command_exists nvim; then
        info "Installing neovim..."
        local nvim_arch
        case "$(uname -m)" in
            x86_64) nvim_arch="linux-x86_64" ;;
            aarch64|arm64) nvim_arch="linux-arm64" ;;
            *) nvim_arch="linux-x86_64" ;;
        esac
        if curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-${nvim_arch}.tar.gz" | sudo tar -xz -C /opt 2>/dev/null; then
            sudo ln -sf "/opt/nvim-${nvim_arch}/bin/nvim" /usr/local/bin/nvim
            sudo ln -sf "/opt/nvim-${nvim_arch}/bin/nvim" /usr/bin/nvim
            success "neovim installed"
        else
            failed_tools+=("neovim")
        fi
    fi

    # eza (modern ls) - install from GitHub releases
    if ! command_exists eza; then
        info "Installing eza..."
        if eza_version=$(curl -sS https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v') && [[ -n "$eza_version" ]]; then
            local eza_arch
            case "$(uname -m)" in
                x86_64) eza_arch="x86_64" ;;
                aarch64|arm64) eza_arch="aarch64" ;;
                *) eza_arch="x86_64" ;;
            esac
            if curl -fsSL "https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_${eza_arch}-unknown-linux-gnu.tar.gz" | sudo tar -xz -C /usr/local/bin 2>/dev/null; then
                success "eza ${eza_version} installed"
            else
                failed_tools+=("eza")
            fi
        else
            failed_tools+=("eza")
        fi
    fi

    # bat
    if ! command_exists bat && ! command_exists batcat; then
        info "Installing bat..."
        case "$DISTRO" in
            debian|ubuntu|mint|kali|parrotos)
                if sudo apt install -y bat 2>/dev/null; then
                    # Create symlink if installed as batcat
                    if command_exists batcat && ! command_exists bat; then
                        mkdir -p "$HOME/.local/bin"
                        ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
                    fi
                    success "bat installed"
                else
                    failed_tools+=("bat")
                fi
                ;;
            fedora|asahi)
                sudo dnf install -y bat 2>/dev/null && success "bat installed" || failed_tools+=("bat")
                ;;
            opensuse*)
                sudo zypper install -y bat 2>/dev/null && success "bat installed" || failed_tools+=("bat")
                ;;
            arch|steamos|cachyos|bazzite)
                sudo pacman -S --noconfirm bat 2>/dev/null && success "bat installed" || failed_tools+=("bat")
                ;;
            *)
                failed_tools+=("bat")
                ;;
        esac
    fi

    # yazi (file manager) - not in most repos, manual install required
    if ! command_exists yazi; then
        failed_tools+=("yazi")
    fi

    # kitten (Kitty terminal helper tool)
    if ! command_exists kitten; then
        info "Installing kitten..."
        if curl -L https://sw.kovidgoyal.net/kitty/installer.sh 2>/dev/null | sh /dev/stdin installer=kitten dest="$HOME/.local" 2>/dev/null; then
            success "kitten installed"
        else
            failed_tools+=("kitten")
        fi
    fi

    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        warn "Failed to install: ${failed_tools[*]}"
    fi

    success "Additional Linux tools complete"
}

install_kitty() {
    if command_exists kitty; then
        success "Kitty terminal already installed"
        return
    fi

    info "Installing Kitty terminal..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Create symlinks so kitty/kitten are in PATH
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"

    # Desktop integration (for application launchers)
    mkdir -p "$HOME/.local/share/applications"
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/"

    # Update icon path and exec path in desktop file
    sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
        "$HOME/.local/share/applications/kitty.desktop"
    sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" \
        "$HOME/.local/share/applications/kitty.desktop"

    success "Kitty terminal installed to ~/.local/kitty.app"
}

# ─────────────────────────────────────────────────────────────────────────────
# Dotfiles Functions
# ─────────────────────────────────────────────────────────────────────────────

clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        success "Dotfiles already cloned at $DOTFILES_DIR"
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

    info "Stowing packages: $packages"
    cd "$DOTFILES_DIR"

    for package in $packages; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            stow -v -R "$package" 2>&1 | grep -v "^LINK" || true
            success "Stowed $package"
        else
            warn "Package not found: $package"
        fi
    done
}

unstow_packages() {
    local packages="$1"

    info "Unstowing packages: $packages"
    cd "$DOTFILES_DIR"

    for package in $packages; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            stow -v -D "$package" 2>&1 || true
            success "Unstowed $package"
        else
            warn "Package not found: $package"
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
            # Restore backup if it exists
            if [[ -f "$HOME/$file.backup" ]]; then
                mv "$HOME/$file.backup" "$HOME/$file"
                info "Restored $file from backup"
            fi
        fi
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# Plugin Manager Functions
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
    info "Run 'tmux' and press <prefix>+I to install plugins"
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
    info "Run 'vim' and execute :PlugInstall to install plugins"
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

    # TPM
    local tpm_dir="$HOME/.config/tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        rm -rf "$tpm_dir"
        success "Removed TPM"
    fi

    # vim-plug
    local plug_file="$HOME/.vim/autoload/plug.vim"
    if [[ -f "$plug_file" ]]; then
        rm "$plug_file"
        success "Removed vim-plug"
    fi

    # Zinit
    local zinit_dir="$HOME/.local/share/zinit"
    if [[ -d "$zinit_dir" ]]; then
        rm -rf "$zinit_dir"
        success "Removed Zinit"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Font Functions
# ─────────────────────────────────────────────────────────────────────────────

install_fonts() {
    info "Installing fonts..."

    if [[ "$OS" == "macos" ]]; then
        # macOS: Install via Homebrew (preferred)
        if command_exists brew; then
            brew install --cask font-jetbrains-mono-nerd-font
            success "Fonts installed via Homebrew"
        else
            # Fallback: Copy from local fonts directory
            local fonts_dir="$DOTFILES_DIR/reference/fonts"
            if [[ -d "$fonts_dir" ]]; then
                local dest="$HOME/Library/Fonts"
                mkdir -p "$dest"
                find "$fonts_dir" -name "*.ttf" -exec cp {} "$dest/" \;
                find "$fonts_dir" -name "*.otf" -exec cp {} "$dest/" \;
                success "Fonts installed to $dest (local fallback)"
            else
                warn "Fonts directory not found and Homebrew unavailable"
            fi
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Linux: Copy from local fonts directory
        local fonts_dir="$DOTFILES_DIR/reference/fonts"
        if [[ -d "$fonts_dir" ]]; then
            local dest="$HOME/.local/share/fonts"
            mkdir -p "$dest"
            find "$fonts_dir" -name "*.ttf" -exec cp {} "$dest/" \;
            find "$fonts_dir" -name "*.otf" -exec cp {} "$dest/" \;
            fc-cache -f -v >/dev/null 2>&1
            success "Fonts installed to $dest"
        else
            warn "Fonts directory not found"
        fi
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# XDG Directory Setup
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

# ─────────────────────────────────────────────────────────────────────────────
# Main Menu
# ─────────────────────────────────────────────────────────────────────────────

show_banner() {
    echo -e "${PURPLE}"
    cat << 'EOF'
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Personal Development Environment Setup${NC}"
    echo ""
}

show_menu() {
    echo ""
    echo -e "${CYAN}Installation Options:${NC}"
    echo "  1) Full installation (terminal + platform-specific packages)"
    echo "  2) Terminal only (shells, editors, utilities) - recommended for WSL"
    echo "  3) Platform only (window managers, terminals, GUI apps)"
    echo "  4) Custom installation"
    echo "  5) Install plugin managers only"
    echo "  6) Install fonts only"
    echo "  7) Install Kitty terminal (Linux only)"
    echo "  8) Uninstall / remove dotfiles"
    echo "  9) Exit"
    echo ""
}

select_packages() {
    echo ""
    echo -e "${CYAN}Available packages:${NC}"
    echo ""
    echo -e "  ${YELLOW}Terminal:${NC} $PACKAGES_TERM"
    echo ""
    if [[ "$OS" == "macos" ]]; then
        echo -e "  ${YELLOW}macOS:${NC} $PACKAGES_MACOS"
    else
        echo -e "  ${YELLOW}Linux:${NC} $PACKAGES_LINUX"
    fi
    echo ""
    prompt "Enter packages to install (space-separated):"
    read_input SELECTED_PACKAGES
}

get_platform_packages() {
    if [[ "$OS" == "macos" ]]; then
        echo "$PACKAGES_MACOS"
    else
        echo "$PACKAGES_LINUX"
    fi
}

build_full_packages() {
    PACKAGES_FULL="$PACKAGES_TERM $(get_platform_packages)"
}

run_full_install() {
    info "Running full installation..."

    build_full_packages
    create_xdg_dirs
    clone_dotfiles

    if [[ "$OS" == "macos" ]]; then
        install_xcode_cli
        install_homebrew
        install_packages_from_brewfile
    elif [[ "$OS" == "linux" ]]; then
        install_linux_packages
        install_starship
        install_additional_linux_tools
    fi

    stow_packages "$PACKAGES_FULL"
    copy_wrapper_files
    install_tpm
    install_vim_plug
    install_zinit
    install_fonts

    success "Full installation complete!"
}

run_terminal_install() {
    info "Running terminal installation..."

    create_xdg_dirs
    clone_dotfiles

    if [[ "$OS" == "macos" ]]; then
        install_xcode_cli
        install_homebrew
        brew install git stow bash zsh fish starship zoxide fzf tmux vim neovim bat btop eza lazygit yazi trash caarlos0/tap/timer terminal-notifier
    elif [[ "$OS" == "linux" ]]; then
        install_linux_packages
        install_starship
        install_additional_linux_tools
    fi

    stow_packages "$PACKAGES_TERM"
    copy_wrapper_files
    install_tpm
    install_vim_plug
    install_zinit

    success "Terminal installation complete!"
}

run_platform_install() {
    info "Running platform-specific installation..."

    local platform_packages
    platform_packages="$(get_platform_packages)"

    create_xdg_dirs
    clone_dotfiles

    if [[ "$OS" == "macos" ]]; then
        install_xcode_cli
        install_homebrew
        brew install --cask alacritty ghostty kitty
        # aerospace requires tap
        brew install --cask nikitabobko/tap/aerospace 2>/dev/null || warn "Aerospace may require manual installation"
    elif [[ "$OS" == "linux" ]]; then
        install_linux_packages
    fi

    stow_packages "$platform_packages"
    install_fonts

    success "Platform installation complete!"
}

run_custom_install() {
    create_xdg_dirs
    clone_dotfiles

    select_packages

    if [[ -z "$SELECTED_PACKAGES" ]]; then
        warn "No packages selected"
        return
    fi

    if [[ "$OS" == "macos" ]]; then
        install_xcode_cli
        install_homebrew
        prompt "Install packages from Brewfile? (y/n)"
        read_input install_brew
        if [[ "$install_brew" =~ ^[Yy]$ ]]; then
            install_packages_from_brewfile
        fi
    elif [[ "$OS" == "linux" ]]; then
        install_linux_packages
        install_starship
        install_additional_linux_tools
    fi

    stow_packages "$SELECTED_PACKAGES"
    copy_wrapper_files
    install_tpm
    install_vim_plug
    install_zinit

    success "Custom installation complete!"
}

run_stow_only() {
    build_full_packages

    echo ""
    echo -e "${CYAN}Stow Options:${NC}"
    echo "  1) Full (terminal + platform)"
    echo "  2) Terminal only"
    echo "  3) Platform only"
    echo "  4) Custom"
    echo ""
    prompt "Select packages to stow [1-4]:"
    read_input stow_choice

    case "$stow_choice" in
        1) stow_packages "$PACKAGES_FULL" ;;
        2) stow_packages "$PACKAGES_TERM" ;;
        3) stow_packages "$(get_platform_packages)" ;;
        4) select_packages; stow_packages "$SELECTED_PACKAGES" ;;
        *) warn "Invalid option" ;;
    esac

    copy_wrapper_files
    success "Stow complete!"
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
    detect_os
    install_fonts
}

run_kitty_install() {
    if [[ "$OS" != "linux" ]]; then
        warn "Kitty installer is for Linux only. On macOS, use: brew install --cask kitty"
        return
    fi

    create_xdg_dirs
    install_kitty
    success "Kitty installation complete!"
}

run_uninstall() {
    info "Running uninstall..."
    build_full_packages

    echo ""
    echo -e "${CYAN}Uninstall Options:${NC}"
    echo "  1) Full uninstall (unstow all + remove plugins + remove wrappers)"
    echo "  2) Unstow packages only"
    echo "  3) Remove plugin managers only"
    echo "  4) Remove wrapper files only"
    echo "  5) Cancel"
    echo ""
    prompt "Select uninstall option [1-5]:"
    read_input uninstall_choice

    case "$uninstall_choice" in
        1)
            prompt "This will remove all dotfiles symlinks and plugin managers. Continue? (y/n)"
            read_input confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                unstow_packages "$PACKAGES_FULL"
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
            echo "  2) Terminal only"
            echo "  3) Platform only"
            echo "  4) Custom"
            echo ""
            prompt "Select packages to unstow [1-4]:"
            read_input unstow_choice

            case "$unstow_choice" in
                1) unstow_packages "$PACKAGES_FULL" ;;
                2) unstow_packages "$PACKAGES_TERM" ;;
                3) unstow_packages "$(get_platform_packages)" ;;
                4) select_packages; unstow_packages "$SELECTED_PACKAGES" ;;
                *) warn "Invalid option" ;;
            esac
            ;;
        3)
            remove_plugin_managers
            ;;
        4)
            remove_wrapper_files
            ;;
        5)
            info "Cancelled"
            ;;
        *)
            warn "Invalid option"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

main() {
    show_banner
    detect_os

    info "Detected OS: $OS"
    if [[ "$OS" == "linux" ]]; then
        info "Detected distro: ${DISTRO:-unknown}"
        if [[ "$IS_WSL" == true ]]; then
            info "Running in WSL"
        fi
    fi

    # Check for required commands
    if ! command_exists git; then
        error "Git is required but not installed"
    fi

    if ! command_exists curl; then
        error "Curl is required but not installed"
    fi

    # Handle command line arguments
    case "${1:-}" in
        --full|-f)
            run_full_install
            exit 0
            ;;
        --terminal|-t)
            run_terminal_install
            exit 0
            ;;
        --platform)
            run_platform_install
            exit 0
            ;;
        --stow|-s)
            run_stow_only
            exit 0
            ;;
        --plugins|-p)
            run_plugin_managers_only
            exit 0
            ;;
        --fonts)
            run_fonts_only
            exit 0
            ;;
        --kitty|-k)
            run_kitty_install
            exit 0
            ;;
        --uninstall|-u)
            run_uninstall
            exit 0
            ;;
        --help|-h)
            echo "Usage: $0 [OPTION]"
            echo ""
            echo "Options:"
            echo "  --full, -f      Full installation (terminal + platform)"
            echo "  --terminal, -t  Terminal packages only (shells, editors, utilities)"
            echo "  --platform      Platform-specific packages only (WM, terminals, GUI)"
            echo "  --stow, -s      Stow packages only (no software installation)"
            echo "  --plugins, -p   Install plugin managers only"
            echo "  --fonts         Install fonts only"
            echo "  --kitty, -k     Install Kitty terminal (Linux only)"
            echo "  --uninstall, -u Remove dotfiles symlinks and plugin managers"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Package groups:"
            echo "  Terminal: $PACKAGES_TERM"
            echo "  macOS:    $PACKAGES_MACOS"
            echo "  Linux:    $PACKAGES_LINUX"
            echo ""
            echo "Without options, an interactive menu is shown."
            exit 0
            ;;
    esac

    # Interactive mode
    while true; do
        show_menu
        prompt "Select an option [1-9]:"
        read_input choice

        case "$choice" in
            1) run_full_install; break ;;
            2) run_terminal_install; break ;;
            3) run_platform_install; break ;;
            4) run_custom_install; break ;;
            5) run_plugin_managers_only; break ;;
            6) run_fonts_only; break ;;
            7) run_kitty_install; break ;;
            8) run_uninstall; break ;;
            9) info "Exiting..."; exit 0 ;;
            *) warn "Invalid option, please try again" ;;
        esac
    done

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. Restart your terminal or source your shell config:"
    echo "     - Zsh:  source ~/.zshrc"
    echo "     - Bash: source ~/.bashrc"
    echo "     - Fish: source ~/.config/fish/config.fish"
    echo "  2. Start tmux and press Ctrl+Space then I to install plugins"
    echo ""
}

main "$@"
