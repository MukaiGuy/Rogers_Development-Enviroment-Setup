#!/bin/bash
# Quick fix to create .zshrc if missing after installation

# First, check if Oh My Zsh is installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "⚠️  Oh My Zsh is not installed. Installing now..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "❌ Oh My Zsh installation failed. Please check your internet connection."
        exit 1
    fi
    echo "✅ Oh My Zsh installed successfully"
fi

if [[ ! -f "$HOME/.zshrc" ]]; then
    echo "Creating .zshrc file..."
    
    # Try to use Oh My Zsh template first
    if [[ -f "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" ]]; then
        cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
        echo "✅ Created .zshrc from Oh My Zsh template"
    else
        # Create a minimal .zshrc
        cat > "$HOME/.zshrc" << 'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh
EOF
        echo "✅ Created minimal .zshrc"
    fi
    
    # Now try to copy the custom linux-zshrc if available
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$SCRIPT_DIR/linux-zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
        cp "$SCRIPT_DIR/linux-zshrc" "$HOME/.zshrc"
        echo "✅ Installed custom linux-zshrc configuration"
    fi
    
    # Copy theme if available
    if [[ -f "$SCRIPT_DIR/mukaiguy.zsh-theme" ]] && [[ -d "$HOME/.oh-my-zsh/themes" ]]; then
        cp "$SCRIPT_DIR/mukaiguy.zsh-theme" "$HOME/.oh-my-zsh/themes/"
        echo "✅ Installed custom theme"
    fi
    
    echo ""
    echo "Now run: source ~/.zshrc"
else
    echo "~/.zshrc already exists"
fi
