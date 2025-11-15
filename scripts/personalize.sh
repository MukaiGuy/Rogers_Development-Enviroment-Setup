#!/bin/bash

# Personalization Script for Development Environment
# Author: Rogers Development Environment Setup
# Description: Installs custom theme, zsh configuration, and nano settings

set -e  # Exit on any error
set -u  # Exit on undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
THEME_FILE="mukaiguy.zsh-theme"
NANORC_FILE="nanorc.conf"

# Detect OS and set appropriate zshrc file
detect_os_and_set_zshrc() {
    local os_type=$(uname -s)

    case "$os_type" in
        "Linux")
            ZSHRC_FILE="linux-zshrc"
            log "INFO" "Linux detected - using linux-zshrc" >&2
            ;;
        "Darwin")
            ZSHRC_FILE="macOS-zshrc"
            log "INFO" "macOS detected - using macOS-zshrc" >&2
            ;;
        *)
            log "ERROR" "Unsupported operating system: $os_type" >&2
            log "INFO" "Defaulting to linux-zshrc" >&2
            ZSHRC_FILE="linux-zshrc"
            ;;
    esac
}

# Initialize ZSHRC_FILE variable
detect_os_and_set_zshrc

# Progress indicator
show_progress() {
    local step="$1"
    local total="$2"
    local description="$3"
    echo -e "\n${BLUE}=== Step $step/$total: $description ===${NC}\n"
}

# Check if file exists with error handling
check_file() {
    local file="$1"
    local description="$2"

    if [[ ! -f "$file" ]]; then
        log "ERROR" "$description not found at: $file"
        log "INFO" "Please ensure the file exists in the repository directory"
        exit 1
    fi
    log "INFO" "Found $description: $file"
}

# Install custom theme
install_custom_theme() {
    show_progress 1 3 "Installing Custom Theme"

    local theme_source="$PARENT_DIR/$THEME_FILE"
    local theme_dest="$HOME/.oh-my-zsh/themes/$THEME_FILE"

    # Check if Oh My Zsh is installed
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "ERROR" "Oh My Zsh is not installed. Please run the setup script first."
        exit 1
    fi

    check_file "$theme_source" "Custom theme file"

    # Backup existing theme if it exists
    if [[ -f "$theme_dest" ]]; then
        log "INFO" "Backing up existing theme file..."
        cp "$theme_dest" "$theme_dest.backup.$(date +%s)"
    fi

    log "INFO" "Installing custom theme..."
    cp "$theme_source" "$theme_dest"
    log "INFO" "Custom theme installation completed"
}

# Install zsh configuration
install_zshrc() {
    show_progress 2 3 "Installing Zsh Configuration"

    local zshrc_source="$PARENT_DIR/$ZSHRC_FILE"
    local zshrc_dest="$HOME/.zshrc"

    check_file "$zshrc_source" "Custom .zshrc file"

    # Backup existing .zshrc
    if [[ -f "$zshrc_dest" ]]; then
        log "INFO" "Backing up existing .zshrc..."
        cp "$zshrc_dest" "$zshrc_dest.backup.$(date +%s)"
    fi

    log "INFO" "Installing custom .zshrc..."
    cp "$zshrc_source" "$zshrc_dest"
    log "INFO" "Zsh configuration installation completed"
}

# Install nano configuration
install_nanorc() {
    show_progress 3 3 "Installing Nano Configuration"

    local nanorc_source="$PARENT_DIR/$NANORC_FILE"
    local nanorc_dest="$HOME/.nanorc"

    check_file "$nanorc_source" "Nano configuration file"

    # Backup existing .nanorc if it exists
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
    log "INFO" "Starting Environment Personalization"
    log "INFO" "Script directory: $SCRIPT_DIR"
    log "INFO" "Parent directory: $PARENT_DIR"

    # Run installation steps
    install_custom_theme
    install_zshrc
    install_nanorc

    echo -e "\n${GREEN}🎉 Personalization completed successfully!${NC}"
    echo -e "${YELLOW}Important:${NC}"
    echo -e "  • Restart your terminal or run: ${BLUE}source ~/.zshrc${NC}"
    echo -e "  • All previous configurations have been backed up with timestamps"
    echo -e "  • Your terminal will use the mukaiguy theme on next session"
    echo ""

    log "INFO" "Personalization process finished"
}

# Error handling
trap 'log "ERROR" "Personalization script failed at line $LINENO. Exit code: $?"' ERR

# Run main function
main "$@"
