#!/usr/bin/env bash

# Comprehensive cleanup before stow
echo "🧹 Cleaning up existing configs to prevent stow conflicts..."

CONFIG_PATHS=(
    "$HOME/.config/aliases.fish"
    "$HOME/.config/aliases.sh"
    "$HOME/.config/bash"
    "$HOME/.config/bat"
    "$HOME/.config/eza"
    "$HOME/.config/exports.fish"
    "$HOME/.config/exports.sh"
    "$HOME/.config/fish"
    "$HOME/.config/fzf"
    "$HOME/.config/fzfrc.fish"
    "$HOME/.config/fzfrc.sh"
    "$HOME/.config/ghostty"
    "$HOME/.config/lazygit"
    "$HOME/.config/nvim"
    "$HOME/.config/starship"
    "$HOME/.config/tmux"
    "$HOME/.config/vim"
    "$HOME/.config/yazi"
    "$HOME/.config/zsh"
    "$HOME/.zsh"
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
)

for path in "${CONFIG_PATHS[@]}"; do
    if [[ -e "$path" || -L "$path" ]]; then
        echo "   🗑️  Removing $path"
        rm -rf "$path"
    fi
done

# Stow configs (force overwrite mode)
echo "📦 Running stow for configs..."
stow -R zsh fish bash starship tmux ghostty yazi nvim exports aliases fzf eza bat vim lazygit

OS_NAME="$(uname -s)"
case "$OS_NAME" in
    Darwin)
        echo "🍎 Detected macOS; stowing aerospace config..."
        if [[ -d "aerospace" ]]; then
            stow -R aerospace
        else
            echo "⚠️  aerospace directory not found; skipping."
        fi
        ;;
    Linux)
        echo "🐧 Detected Linux; stowing tiling WM configs..."
        for dir in hyprland i3 polybar waybar hyprpanel; do
            if [[ -d "$dir" ]]; then
                stow -R "$dir"
            else
                echo "⚠️  $dir directory not found; skipping."
            fi
        done
        ;;
    *)
        echo "⚠️  Unsupported OS ($OS_NAME); skipping OS-specific stow."
        ;;
esac

# Copy rc files
echo "📄 Copying rc files..."
cp -v .zshrc .bashrc .vimrc "$HOME/"

# Clone TPM (tmux plugin manager)
echo "🔌 Installing tmux plugin manager (TPM)..."
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "✅ TPM installed successfully."
else
    echo "✅ TPM already installed, skipping."
fi

# Reminder
echo "✅ Setup complete!"
echo "👉 Reminder: Refresh tmux config with <prefix> + C-I"

# Setting default shell to Fish
FISH_PATH="$(brew --prefix)/bin/fish"
echo "Adding $FISH_PATH to /etc/shells..."
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if command -v dscl >/dev/null 2>&1; then
    CURRENT_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
elif command -v getent >/dev/null 2>&1; then
    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
else
    CURRENT_SHELL=""
fi
if [[ -z "${CURRENT_SHELL}" ]]; then
    CURRENT_SHELL="$SHELL"
fi

echo "Current shell: $CURRENT_SHELL"
if [[ "$CURRENT_SHELL" == "$FISH_PATH" ]]; then
    echo "Default shell already set to fish; skipping chsh."
else
    echo "Changing default shell to fish..."
    chsh -s "$FISH_PATH"
fi

