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
PACKAGES_MACOS="aerospace alacritty ghostty kitty homebrew vimium"
PACKAGES_LINUX="alacritty ghostty kitty hypr i3 polybar waybar vimium"

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
            ;;
        *)
            error "Unsupported operating system: $OSTYPE"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────────────────
# Installation Functions
# ─────────────────────────────────────────────────────────────────────────────

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

    case "$DISTRO" in
        ubuntu|debian|pop)
            sudo apt update
            sudo apt install -y git stow curl zsh tmux vim build-essential
            ;;
        fedora)
            sudo dnf install -y git stow curl zsh tmux vim
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -Syu --noconfirm git stow curl zsh tmux vim base-devel
            ;;
        *)
            warn "Unknown distribution: $DISTRO"
            warn "Please install git, stow, curl, zsh, tmux, and vim manually"
            return
            ;;
    esac

    success "Base Linux packages installed"
}

install_packages_from_brewfile() {
    if [[ ! -f "$DOTFILES_DIR/homebrew/Brewfile" ]]; then
        warn "Brewfile not found, skipping package installation"
        return
    fi

    info "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile" || warn "Some packages may have failed to install"
    success "Brewfile packages installed"
}

install_starship() {
    if command_exists starship; then
        success "Starship already installed"
        return
    fi

    info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    success "Starship installed"
}

install_additional_linux_tools() {
    info "Installing additional tools for Linux..."

    # zoxide
    if ! command_exists zoxide; then
        info "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # fzf
    if ! command_exists fzf; then
        info "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-bash --no-fish
    fi

    # eza (modern ls)
    if ! command_exists eza; then
        case "$DISTRO" in
            ubuntu|debian|pop)
                sudo apt install -y eza 2>/dev/null || warn "eza not available in repos, install manually"
                ;;
            arch|manjaro|endeavouros)
                sudo pacman -S --noconfirm eza
                ;;
            *)
                warn "Please install eza manually: https://github.com/eza-community/eza"
                ;;
        esac
    fi

    # bat
    if ! command_exists bat && ! command_exists batcat; then
        case "$DISTRO" in
            ubuntu|debian|pop)
                sudo apt install -y bat
                # Create symlink if installed as batcat
                if command_exists batcat && ! command_exists bat; then
                    mkdir -p "$HOME/.local/bin"
                    ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
                fi
                ;;
            arch|manjaro|endeavouros)
                sudo pacman -S --noconfirm bat
                ;;
            *)
                warn "Please install bat manually"
                ;;
        esac
    fi

    success "Additional Linux tools installed"
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
            local fonts_dir="$DOTFILES_DIR/fonts"
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
        local fonts_dir="$DOTFILES_DIR/fonts"
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
    echo "  2) Terminal only (shells, editors, utilities)"
    echo "  3) Platform only (window managers, terminals, GUI apps)"
    echo "  4) Custom installation"
    echo "  5) Install plugin managers only"
    echo "  6) Install fonts only"
    echo "  7) Exit"
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
        install_homebrew
        brew install git stow bash zsh fish starship tmux vim neovim bat btop eza lazygit yazi
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

# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

main() {
    show_banner
    detect_os

    info "Detected OS: $OS"
    if [[ "$OS" == "linux" ]]; then
        info "Detected distro: ${DISTRO:-unknown}"
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
        prompt "Select an option [1-7]:"
        read_input choice

        case "$choice" in
            1) run_full_install; break ;;
            2) run_terminal_install; break ;;
            3) run_platform_install; break ;;
            4) run_custom_install; break ;;
            5) run_plugin_managers_only; break ;;
            6) run_fonts_only; break ;;
            7) info "Exiting..."; exit 0 ;;
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
