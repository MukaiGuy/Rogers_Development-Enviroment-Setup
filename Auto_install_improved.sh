#!/bin/bash

# Auto Install Script for Development Environment Setup
# Author: Rogers Development Environment Setup
# Description: Automatically detects OS and runs appropriate setup scripts

set -e  # Exit on any error
set -u  # Exit on undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_SCRIPT="scripts/devsetup.sh"
MACOS_SCRIPT="scripts/osx_setup_improved.sh"
PERSONALIZE_SCRIPT="scripts/personalize.sh"

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

# Display banner
show_banner() {
    echo -e "${PURPLE}"
    echo "════════════════════════════════════════════════════════════════"
    echo "           Development Environment Auto-Installer"
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
    echo -e "${BLUE}This script will automatically detect your operating system${NC}"
    echo -e "${BLUE}and run the appropriate setup scripts.${NC}"
    echo ""
}

# Detect operating system
detect_os() {
    local os_type=$(uname -s)
    local os_name=""

    case "$os_type" in
        "Linux")
            os_name="Linux"
            if [[ -f /etc/os-release ]]; then
                local distro=$(grep '^NAME=' /etc/os-release | cut -d'"' -f2)
                log "INFO" "Detected Linux distribution: $distro" >&2
            else
                log "INFO" "Detected Linux (distribution unknown)" >&2
            fi
            ;;
        "Darwin")
            os_name="macOS"
            local macos_version=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
            log "INFO" "Detected macOS version: $macos_version" >&2
            ;;
        *)
            log "ERROR" "Unsupported operating system: $os_type" >&2
            log "INFO" "This script supports Linux and macOS only" >&2
            exit 1
            ;;
    esac

    echo "$os_name"
}

# Check if script exists and is executable
validate_script() {
    local script_name="$1"
    local script_path="$SCRIPT_DIR/$script_name"

    if [[ ! -f "$script_path" ]]; then
        log "ERROR" "Required script not found: $script_path"
        log "INFO" "Please ensure all required scripts are in the same directory"
        return 1
    fi

    if [[ ! -x "$script_path" ]]; then
        log "WARN" "Script is not executable: $script_name"
        log "INFO" "Making script executable..."
        chmod +x "$script_path"
    fi

    log "INFO" "Validated script: $script_name"
    return 0
}

# Execute script with error handling
execute_script() {
    local script_name="$1"
    local description="$2"
    local script_path="$SCRIPT_DIR/$script_name"

    echo -e "\n${BLUE}▶ Starting: $description${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

    log "INFO" "Executing $script_name..."

    if "$script_path" 2>&1; then
        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            log "INFO" "$description completed successfully"
            echo -e "${GREEN}✅ $description - COMPLETED${NC}"
        else
            log "ERROR" "$description failed with exit code $exit_code"
            echo -e "${RED}❌ $description - FAILED${NC}"
            return 1
        fi
    else
        local exit_code=$?
        log "ERROR" "$description failed with exit code $exit_code"
        echo -e "${RED}❌ $description - FAILED${NC}"
        echo -e "${RED}Check the error messages above for details${NC}"
        return 1
    fi
}

# Main execution function
main() {
    show_banner

    log "INFO" "Starting auto-installation process"
    log "INFO" "Script directory: $SCRIPT_DIR"

    # Detect operating system
    echo -e "${YELLOW}🔍 Detecting operating system...${NC}"
    local detected_os=$(detect_os)

    # Determine which setup script to use
    local setup_script=""
    case "$detected_os" in
        "Linux")
            setup_script="$LINUX_SCRIPT"
            echo -e "${GREEN}🐧 Linux detected - will use $setup_script${NC}"
            ;;
        "macOS")
            setup_script="$MACOS_SCRIPT"
            echo -e "${GREEN}🍎 macOS detected - will use $setup_script${NC}"
            ;;
    esac

    # Validate required scripts exist
    echo -e "\n${YELLOW}📋 Validating required scripts...${NC}"

    if ! validate_script "$setup_script"; then
        exit 1
    fi

    if ! validate_script "$PERSONALIZE_SCRIPT"; then
        log "WARN" "Personalization script not found - skipping personalization step"
        PERSONALIZE_SCRIPT=""
    fi

    echo -e "${GREEN}✅ Script validation completed${NC}"

    # Ask for user confirmation
    echo -e "\n${YELLOW}📋 Installation Plan:${NC}"
    echo -e "   1️⃣  Run $detected_os setup: ${BLUE}$setup_script${NC}"
    if [[ -n "$PERSONALIZE_SCRIPT" ]]; then
        echo -e "   2️⃣  Run personalization: ${BLUE}$PERSONALIZE_SCRIPT${NC}"
    fi

    echo -e "\n${YELLOW}⚠️  This will install and configure development tools on your system.${NC}"
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "INFO" "Installation cancelled by user"
        echo -e "${YELLOW}Installation cancelled. No changes were made.${NC}"
        exit 0
    fi

    # Execute setup script
    echo -e "\n${PURPLE}🚀 Starting installation process...${NC}\n"

    execute_script "$setup_script" "$detected_os Development Environment Setup"

    # Execute personalization script if available
    if [[ -n "$PERSONALIZE_SCRIPT" ]]; then
        echo -e "\n${BLUE}🎨 Proceeding with personalization...${NC}\n"
        if ! execute_script "$PERSONALIZE_SCRIPT" "Environment Personalization"; then
            log "WARN" "Personalization script failed - creating basic .zshrc as fallback"
            echo -e "${YELLOW}⚠️  Personalization failed, creating basic configuration...${NC}"
            
            # Create basic .zshrc if it doesn't exist
            if [[ ! -f "$HOME/.zshrc" ]]; then
                log "INFO" "Creating basic .zshrc from Oh My Zsh template"
                cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc" 2>/dev/null || true
            fi
        fi
    fi

    # Success message
    echo -e "\n${GREEN}🎉 Auto-installation completed successfully!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  • Restart your terminal or source your shell configuration"
    echo -e "  • Check the setup logs above for any important notes"
    echo -e "  • Test your new development environment"
    echo ""

    log "INFO" "Auto-installation process finished"
}

# Error handling
trap 'log "ERROR" "Auto-installation failed at line $LINENO. Exit code: $?"' ERR

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
else
    log "WARN" "Script is being sourced, not executed directly"
fi