# NixOS Helper Justfile
# Provides recipes for common NixOS, Home Manager, and nh operations.

# Ensure scripts are executable
default: all

all:
    @echo "Available recipes:"
    @just --list

# --- Settings ---
# set shell := ["bash", "-euo", "pipefail"] # Strict mode for bash recipes

# Path to the helper script
# HELPER_SCRIPT := "./scripts/nix-helper.sh"
HELPER_SCRIPT := "./areas/external/scripts/nix-helper.sh"
# Path to the script configuration
HELPER_CONFIG := "./areas/external/scripts/nix-helper.cfg"

# --- Setup & Checks ---

# Ensure helper script exists and is executable
check-script:
    @bash -c '\
        SCRIPT_PATH="{{HELPER_SCRIPT}}"; \
        echo "--> Checking helper script: $SCRIPT_PATH"; \
        if [ ! -f "$SCRIPT_PATH" ]; then \
            echo "Error: Helper script not found at $SCRIPT_PATH"; \
            exit 1; \
        fi; \
        if [ ! -x "$SCRIPT_PATH" ]; then \
            echo "Warning: Helper script $SCRIPT_PATH is not executable. Attempting chmod +x..."; \
            chmod +x "$SCRIPT_PATH"; \
            if [ ! -x "$SCRIPT_PATH" ]; then \
                echo "Error: Failed to make helper script $SCRIPT_PATH executable. Check permissions."; \
                exit 1; \
            else \
                echo "Success: Helper script $SCRIPT_PATH is now executable."; \
            fi; \
        else \
            echo "Info: Helper script $SCRIPT_PATH is already executable."; \
        fi; \
        echo "<-- Script check passed."; \
    '

# Check for dependencies (basic check, script does more thorough check)
check-deps:
    @echo "Checking basic dependencies..."
    @if ! command -v bash &>/dev/null; then echo "Error: bash is required."; exit 1; fi
    @if ! command -v nixos-rebuild &>/dev/null; then echo "Warning: nixos-rebuild not found (required for 'os' commands)."; fi
    @if ! command -v home-manager &>/dev/null; then echo "Warning: home-manager not found (required for 'home' commands)."; fi
    @if ! command -v nh &>/dev/null; then echo "Info: 'nh' command not found (optional helper)."; fi
    @if ! command -v gum &>/dev/null; then \
        echo "Info: 'gum' not found. Falling back to basic menus."; \
        echo "Install gum for a better experience (https://github.com/charmbracelet/gum)."; \
    else \
        echo "Info: 'gum' found. Using enhanced menus."; \
    fi
    @echo "Dependency check complete."


# --- Core Recipes ---

# NixOS System Operations (nixos-rebuild)
os: check-script check-deps
    @echo "Launching NixOS Rebuild Helper..."
    @{{HELPER_SCRIPT}} os

# Home Manager Operations
home: check-script check-deps
    @echo "Launching Home Manager Helper..."
    @{{HELPER_SCRIPT}} home

# nh Helper Operations
nh: check-script check-deps
    @echo "Launching nh Helper..."
    @{{HELPER_SCRIPT}} nh

# Remote Deployment (nixos-anywhere)
remote: check-script check-deps
    @echo "Launching NixOS Anywhere Helper..."
    @{{HELPER_SCRIPT}} remote

# Show current configuration
config: check-script
    @echo "Displaying Configuration..."
    @{{HELPER_SCRIPT}} config

# Edit the helper script configuration
edit-config:
    @echo "Opening config file: {{HELPER_CONFIG}}"
    @${EDITOR:-nvim} {{HELPER_CONFIG}}

# Edit the main helper script
edit-script:
    @echo "Opening script file: {{HELPER_SCRIPT}}"
    @${EDITOR:-nvim} {{HELPER_SCRIPT}}

# --- Aliases (Optional) ---
rebuild: os
switch: os # common alias
boot: os # common alias
deploy: remote
