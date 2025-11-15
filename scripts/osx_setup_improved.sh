#!/bin/bash

# macOS Development Environment Setup Script
# Author: Rogers Development Environment Setup
# Description: Installs Homebrew, essential tools, Oh My Zsh, and custom theme

set -e  # Exit on any error
set -u  # Exit on undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
THEME_FILE="mukaiguy.zsh-theme"
ZSHRC_FILE="macOS-zshrc"
NANORC_FILE="nanorc.conf"

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] INFO:${NC} $message" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] WARN:${NC} $message" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ERROR:${NC} $message" ;;
        "DEBUG") echo -e "${BLUE}[${timestamp}] DEBUG:${NC} $message" ;;
    esac
}

# Progress indicator
show_progress() {
    local step="$1"
    local total="$2"
    local description="$3"
    echo -e "\n${BLUE}=== Step $step/$total: $description ===${NC}\n"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if file exists with error handling
check_file() {
    local file="$1"
    local description="$2"

    if [[ ! -f "$file" ]]; then
        log "ERROR" "$description not found at: $file"
        log "INFO" "Please ensure the file exists in the script directory"
        exit 1
    fi
    log "INFO" "Found $description: $file"
}

# Install Homebrew
install_homebrew() {
    show_progress 1 6 "Installing Homebrew"

    if command_exists brew; then
        log "INFO" "Homebrew is already installed"
        log "INFO" "Updating Homebrew..."
        brew update
    else
        log "INFO" "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        log "INFO" "Homebrew installation completed"
    fi
}

# Install essential packages
install_packages() {
    show_progress 2 6 "Installing Essential Packages"

    local packages=("git" "curl" "wget" "pygments" "nano")

    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            log "INFO" "$package is already installed"
        else
            log "INFO" "Installing $package..."
            brew install "$package"
        fi
    done

    log "INFO" "Essential packages installation completed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    show_progress 3 6 "Installing Oh My Zsh"

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "INFO" "Oh My Zsh is already installed"
    else
        log "INFO" "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log "INFO" "Oh My Zsh installation completed"
    fi
}

# Install additional tools
install_additional_tools() {
    show_progress 4 6 "Installing Additional Tools"

    if brew list fzf &>/dev/null; then
        log "INFO" "fzf is already installed"
    else
        log "INFO" "Installing fzf..."
        brew install fzf

        # Install useful key bindings and fuzzy completion
        $(brew --prefix)/opt/fzf/install --all
        log "INFO" "fzf installation completed"
    fi
}

# Install custom theme
install_custom_theme() {
    show_progress 5 6 "Installing Custom Theme"

    local theme_source="$PARENT_DIR/$THEME_FILE"
    local theme_dest="$HOME/.oh-my-zsh/themes/$THEME_FILE"

    check_file "$theme_source" "Custom theme file"

    if [[ -f "$theme_dest" ]]; then
        log "WARN" "Theme file already exists, creating backup..."
        cp "$theme_dest" "$theme_dest.backup.$(date +%s)"
    fi

    log "INFO" "Installing custom theme..."
    cp "$theme_source" "$theme_dest"
    log "INFO" "Custom theme installation completed"
}

# Configure zsh
configure_zsh() {
    show_progress 6 7 "Configuring Zsh"

    local zshrc_source="$PARENT_DIR/$ZSHRC_FILE"
    local zshrc_dest="$HOME/.zshrc"

    check_file "$zshrc_source" "Custom .zshrc file"    # Backup existing .zshrc
    if [[ -f "$zshrc_dest" ]]; then
        log "INFO" "Backing up existing .zshrc..."
        cp "$zshrc_dest" "$zshrc_dest.backup.$(date +%s)"
    fi

    log "INFO" "Installing custom .zshrc..."
    cp "$zshrc_source" "$zshrc_dest"
    log "INFO" "Zsh configuration completed"
}

# Install nanorc configuration
install_nanorc() {
    show_progress 7 7 "Installing Nano Configuration"

    local nanorc_source="$PARENT_DIR/$NANORC_FILE"
    local nanorc_dest="$HOME/.nanorc"

    check_file "$nanorc_source" "Nano configuration file"    # Backup existing .nanorc if it exists
    if [[ -f "$nanorc_dest" ]]; then
        log "INFO" "Backing up existing .nanorc..."
        cp "$nanorc_dest" "$nanorc_dest.backup.$(date +%s)"
    fi

    log "INFO" "Installing nano configuration..."
    cp "$nanorc_source" "$nanorc_dest"
    log "INFO" "Nano configuration installation completed"
}

# Main execution function
main() {
    log "INFO" "Starting macOS Development Environment Setup"
    log "INFO" "Script directory: $SCRIPT_DIR"

    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log "ERROR" "This script is designed for macOS only"
        exit 1
    fi

    # Run installation steps
    install_homebrew
    install_packages
    install_oh_my_zsh
    install_additional_tools
    install_custom_theme
    configure_zsh
    install_nanorc

    echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}"
    echo -e "${YELLOW}Please restart your terminal or run: source ~/.zshrc${NC}"
    echo -e "${BLUE}If you encounter any issues, check the backup files created during installation.${NC}"

    log "INFO" "Setup process finished"
}

# Error handling
trap 'log "ERROR" "Script failed at line $LINENO. Exit code: $?"' ERR

# Run main function
main "$@"