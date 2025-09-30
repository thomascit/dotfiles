#!/usr/bin/env bash

# Symlink the configured dotfiles into the home directory
stow -Rv bash zsh fish eza starship lazygit tmux nvim vim fzf aliases exports bat ghostty

# Move standalone dotfiles into the home directory
cp -v .zshrc "$HOME/.zshrc"
cp -v .bashrc "$HOME/.bashrc"
cp -v .vimrc "$HOME/.vimrc"
