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
    # Capture the output and exit code
    local update_output
    local update_exit_code
    update_output=$(sudo apt-get update -y 2>&1) || update_exit_code=$?
    
    if [[ $update_exit_code -ne 0 ]]; then
        # Check if it's just a repository signature issue (non-critical)
        if echo "$update_output" | grep -q "NO_PUBKEY\|not signed\|GPG error"; then
            log "WARN" "Some repositories have GPG key issues but main repositories are accessible"
            log "WARN" "You may want to fix repository issues later, but continuing with installation..."
            echo "$update_output" | grep -E "NO_PUBKEY|not signed|GPG error" | head -3
        else
            log "ERROR" "Failed to update package lists. Check your internet connection and apt sources."
            echo "$update_output"
            return 100
        fi
    fi

    log "INFO" "Upgrading installed packages..."
    if ! sudo apt full-upgrade -y; then
        log "ERROR" "Failed to upgrade packages. You may need to resolve conflicts manually."
        return 100
    fi

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
            if ! sudo apt-get install -y "$package"; then
                log "ERROR" "Failed to install $package"
                return 100
            fi
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
        if ! sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            log "ERROR" "Failed to install Oh My Zsh. Check your internet connection."
            return 100
        fi
        log "INFO" "Oh My Zsh installation completed"
        
        # Verify installation
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            log "ERROR" "Oh My Zsh directory not found after installation"
            return 100
        fi
    fi
}

# Install fzf
install_fzf() {
    show_progress 4 5 "Installing fzf (Fuzzy Finder)"

    if command_exists fzf; then
        log "INFO" "fzf is already installed"
    else
        log "INFO" "Installing fzf..."
        if ! sudo apt-get install -y fzf; then
            log "ERROR" "Failed to install fzf"
            return 100
        fi

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
    if ! sudo apt-get autoremove -y; then
        log "WARN" "Failed to remove unnecessary packages (non-critical)"
    fi

    log "INFO" "Cleaning package cache..."
    if ! sudo apt-get autoclean -y; then
        log "WARN" "Failed to clean package cache (non-critical)"
    fi
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
    update_system || exit 100
    install_packages || exit 100
    install_oh_my_zsh || exit 100
    install_fzf || exit 100
    cleanup_system || exit 100

    # Set zsh as default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log "INFO" "Setting zsh as default shell..."
        if chsh -s "$(which zsh)"; then
            log "INFO" "Default shell changed to zsh"
        else
            log "WARN" "Could not automatically change shell. Run manually: chsh -s $(which zsh)"
        fi
    else
        log "INFO" "zsh is already the default shell"
    fi

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
