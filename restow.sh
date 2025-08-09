#!/bin/bash
# restow.sh — restows all stow packages in the current directory

set -e  # exit on error

DOTFILES_DIR="$HOME/.dotfiles"

cd "$DOTFILES_DIR" || {
    echo "❌ Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
}

# Restow all subdirectories (each is a stow package)
for pkg in */ ; do
    pkg="${pkg%/}"  # remove trailing slash
    echo "🔄 Restowing: $pkg"
    stow -R "$pkg"
done

echo "✅ All packages restowed."
