#!/usr/bin/env bash
set -e

echo "Installing Neovim config..."

# Check if nix is available
if ! command -v nix &> /dev/null; then
    echo "Error: Nix is not installed. Please install Nix first."
    exit 1
fi

# Install the neovim config
echo "Installing neovim config package..."
nix profile install github:yourusername/neovim-config

echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  nvim          # Run neovim with your config"
echo "  nix develop   # Enter dev shell with LSPs (in config directory)"
echo ""
echo "Your neovim config is now available system-wide."