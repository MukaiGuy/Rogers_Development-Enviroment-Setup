#!/bin/bash

# Linux Development Environment Setup Script
# Author: Rogers Development Environment Setup
# Description: Installs essential tools, Oh My Zsh, and fzf on Linux systems

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

# Update system packages
update_system() {
    show_progress 1 5 "Updating System Packages"

    log "INFO" "Updating package lists..."
    sudo apt-get update -y

    log "INFO" "Upgrading installed packages..."
    sudo apt full-upgrade -y

    log "INFO" "System update completed"
}

# Install essential packages
install_packages() {
    show_progress 2 5 "Installing Essential Packages"

    local packages=("zsh" "git" "curl" "wget" "python3" "python3-venv" "python3-pip")

    for package in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package "; then
            log "INFO" "$package is already installed"
        else
            log "INFO" "Installing $package..."
            sudo apt-get install -y "$package"
        fi
    done

    log "INFO" "Essential packages installation completed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    show_progress 3 5 "Installing Oh My Zsh"

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "INFO" "Oh My Zsh is already installed"
    else
        log "INFO" "Downloading and installing Oh My Zsh..."
        # Using wget since it's more commonly available on Linux
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log "INFO" "Oh My Zsh installation completed"
    fi
}

# Install fzf
install_fzf() {
    show_progress 4 5 "Installing fzf (Fuzzy Finder)"

    if command_exists fzf; then
        log "INFO" "fzf is already installed"
    else
        log "INFO" "Installing fzf..."
        sudo apt-get install -y fzf

        # Install fzf key bindings if available
        if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
            log "INFO" "fzf key bindings are available"
        fi

        log "INFO" "fzf installation completed"
    fi
}

# Clean up system
cleanup_system() {
    show_progress 5 5 "Cleaning Up"

    log "INFO" "Removing unnecessary packages..."
    sudo apt-get autoremove -y

    log "INFO" "Cleaning package cache..."
    sudo apt-get autoclean -y

    log "INFO" "System cleanup completed"
}

# Main execution function
main() {
    log "INFO" "Starting Linux Development Environment Setup"
    log "INFO" "Script directory: $SCRIPT_DIR"

    # Check if we're on Linux
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        log "ERROR" "This script is designed for Linux only"
        exit 1
    fi

    # Check for sudo privileges
    if ! sudo -v; then
        log "ERROR" "This script requires sudo privileges"
        exit 1
    fi

    # Run installation steps
    update_system
    install_packages
    install_oh_my_zsh
    install_fzf
    cleanup_system

    echo -e "\n${GREEN}🎉 Linux setup completed successfully!${NC}"
    echo -e "${YELLOW}Important next steps:${NC}"
    echo -e "  1. Run the personalization script to install custom configurations"
    echo -e "  2. Restart your terminal or log out and back in for zsh to take effect"
    echo -e "  3. If zsh doesn't activate automatically, run: chsh -s \$(which zsh)"
    echo ""

    log "INFO" "Setup process finished"
}

# Error handling
trap 'log "ERROR" "Script failed at line $LINENO. Exit code: $?"' ERR

# Run main function
main "$@"
