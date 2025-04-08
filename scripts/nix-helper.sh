#!/usr/bin/env bash
set -eo pipefail # Use -e to exit on error, -o pipefail for pipe safety

# --- Configuration & Setup ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/nix-helper.cfg"
FLAKE_ROOT_DEFAULT="." # Default relative path to flake from project root

# Source configuration if it exists
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=scripts/nix-helper.cfg
    source "$CONFIG_FILE"
fi

# Determine Flake Root (use config default or override)
FLAKE_ROOT="${FLAKE_ROOT:-$FLAKE_ROOT_DEFAULT}"

# Determine Privilege Escalation Method
if [[ -z "${PAMT}" ]]; then
    if command -v doas &>/dev/null; then
        PAMT="doas"
    elif command -v sudo &>/dev/null; then
        PAMT="sudo"
    else
        echo "Error: Neither 'sudo' nor 'doas' found. Required for OS operations." >&2
        exit 1
    fi
fi

# Determine if gum is available
USE_GUM=false
if command -v gum &>/dev/null; then
    USE_GUM=true
fi

# --- Color Definitions (using tput for better compatibility) ---
# Check if terminal supports color
if [[ -t 1 ]] && command -v tput &>/dev/null && [[ "$(tput colors)" -ge 8 ]]; then
    # Use tput names where possible, fall back to ANSI codes if needed
    # Normal
    C_RESET=$(tput sgr0)
    C_BOLD=$(tput bold)
    C_BLACK=$(tput setaf 0)   # COLOR_BLACK
    C_RED=$(tput setaf 1)     # COLOR_RED
    C_GREEN=$(tput setaf 2)   # COLOR_GREEN
    C_YELLOW=$(tput setaf 3)  # COLOR_YELLOW
    C_BLUE=$(tput setaf 4)    # COLOR_BLUE
    C_MAGENTA=$(tput setaf 5) # COLOR_MAGENTA
    C_CYAN=$(tput setaf 6)    # COLOR_CYAN - Primary Accent
    C_WHITE=$(tput setaf 7)   # COLOR_WHITE
    # Bright
    C_BR_BLACK=$(tput setaf 8)  # COLOR_BRIGHT_BLACK (Often Gray)
    C_BR_RED=$(tput setaf 9)    # COLOR_BRIGHT_RED
    C_BR_GREEN=$(tput setaf 10) # COLOR_BRIGHT_GREEN
    C_BR_YELLOW=$(tput setaf 11) # COLOR_BRIGHT_YELLOW
    C_BR_BLUE=$(tput setaf 12)  # COLOR_BRIGHT_BLUE
    C_BR_MAGENTA=$(tput setaf 13) # COLOR_BRIGHT_MAGENTA
    C_BR_CYAN=$(tput setaf 14)   # COLOR_BRIGHT_CYAN - Active Accent
    C_BR_WHITE=$(tput setaf 15)  # COLOR_BRIGHT_WHITE
else # No color support or tput not found
    C_RESET="" C_BOLD="" C_BLACK="" C_RED="" C_GREEN="" C_YELLOW="" C_BLUE="" C_MAGENTA="" C_CYAN="" C_WHITE=""
    C_BR_BLACK="" C_BR_RED="" C_BR_GREEN="" C_BR_YELLOW="" C_BR_BLUE="" C_BR_MAGENTA="" C_BR_CYAN="" C_BR_WHITE=""
fi
# --- Gum Fallback Functions ---

# Choose one item from a list
# Usage: choose "Prompt" "Option1" "Option2" ...
# Returns the selected option string
gum_choose_fallback() {
    local prompt="$1"
    shift
    local options=("$@")
    echo "${C_CYAN}${prompt}${C_RESET}"
    PS3="${C_YELLOW}Select option: ${C_RESET}"
    select opt in "${options[@]}" "Cancel"; do
        case "$REPLY" in
            [1-$((${#options[@]}))]) # Valid number selection
                echo "$opt"
                return 0
                ;;
            $((${#options[@]} + 1))) # Cancel option
                 echo "Cancelled." >&2
                 return 1
                 ;;
             *) echo "${C_RED}Invalid choice: $REPLY. Please select a number.${C_RESET}" >&2 ;;
        esac
    done
}
choose() {
    if $USE_GUM; then
        # Gum automatically handles cancellation (ESC)
        gum choose --header "$1" "${@:2}"
    else
        gum_choose_fallback "$@"
    fi
}

# Confirm a yes/no question
# Usage: confirm "Prompt"
# Returns 0 for yes, 1 for no
gum_confirm_fallback() {
    local prompt="$1"
    while true; do
        read -rp "${C_YELLOW}${prompt} (y/n): ${C_RESET}" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "${C_RED}Please answer yes or no.${C_RESET}";;
        esac
    done
}
confirm() {
    if $USE_GUM; then
        gum confirm "$1"
    else
        gum_confirm_fallback "$1"
    fi
}

# Get text input
# Usage: input "Prompt" "Placeholder"
# Returns the input string
gum_input_fallback() {
    local prompt="$1"
    local placeholder="$2"
    local input_val=""
    read -rp "${C_CYAN}${prompt} ${C_BR_BLACK}[${placeholder}]: ${C_RESET}" input_val
    echo "$input_val"
}
input() {
    if $USE_GUM; then
        gum input --prompt "$1 " --placeholder "$2"
    else
        gum_input_fallback "$@"
    fi
}

# Get password input
# Usage: password "Prompt"
# Returns the password string
gum_password_fallback() {
    local prompt="$1"
    local pass=""
    read -rsp "${C_CYAN}${prompt}: ${C_RESET}" pass
    echo # Print newline after hidden input
    echo "$pass"
}
password() {
    if $USE_GUM; then
        # Gum handles the prompt style via env vars
        gum input --password --prompt "$1 "
    else
        gum_password_fallback "$@"
    fi
}

# Spin while command executes
# Usage: spin "Title" command args...
gum_spin_fallback() {
    local title="$1"
    shift
    echo "${C_CYAN}Running: ${title}...${C_RESET}"
    "$@" # Execute command directly
}
spin() {
    if $USE_GUM; then
        gum spin --title "$1" -- "$@"
    else
        gum_spin_fallback "$@"
    fi
}

# --- Helper Functions ---
print_header() {
    local title="$1"
    if $USE_GUM; then
        gum style --border rounded --border-foreground "$C_BLUE" --padding "1 2" --margin "1 0" "${C_BOLD}${C_BR_CYAN}${title}${C_RESET}"
    else
        echo -e "\n${C_BOLD}${C_BR_CYAN}=== ${title} ===${C_RESET}"
    fi
}

print_success() {
    echo "${C_GREEN}✓ ${1}${C_RESET}"
}

print_error() {
    echo "${C_RED}✗ Error: ${1}${C_RESET}" >&2
}

print_warning() {
    echo "${C_YELLOW}⚠ Warning: ${1}${C_RESET}"
}

print_info() {
    echo "${C_BLUE}ℹ ${1}${C_RESET}"
}

# Executes a command, optionally with privilege escalation
# Usage: run_cmd [--privileged] command args...
run_cmd() {
    local use_privilege=false
    if [[ "$1" == "--privileged" ]]; then
        use_privilege=true
        shift
    fi
    local cmd_str=("$@")

    echo "${C_BR_BLACK}Executing: ${use_privilege:+${PAMT} }${cmd_str[*]}${C_RESET}"

    if confirm "Proceed with execution?"; then
        if $use_privilege; then
            # Original: spin "Running with ${PAMT}..." "$PAMT" "${cmd_str[@]}"
            spin "Privileged Task" "$PAMT" "${cmd_str[@]}"  # Use a simpler title
        else
            # Original: spin "Running..." "${cmd_str[@]}"
            spin "Normal Task" "${cmd_str[@]}" # Use a simpler title
        fi

        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            print_success "Command finished successfully."
        else
            print_error "Command failed with exit code $exit_code."
            # Don't exit the script here, let the caller decide
        fi
        return $exit_code
    else
        print_warning "Execution cancelled by user."
        return 1 # Non-zero exit code for cancellation
    fi
}

# Select flake target (#current or #host)
select_flake_target() {
    local default_dot="Current directory (.)"
    local specific_host="Specific host (#host)"
    local target_type
    target_type=$(choose "Select Flake Target:" "$default_dot" "$specific_host") || exit 1

    if [[ "$target_type" == "$default_dot" ]]; then
        echo "."
    elif [[ "$target_type" == "$specific_host" ]]; then
        local host_name
        host_name=$(input "Enter host name (e.g., 'my-server'):" "hostname") || exit 1
        if [[ -z "$host_name" ]]; then
            print_error "Host name cannot be empty."
            exit 1
        fi
        echo ".#${host_name}"
    else
         print_error "Invalid selection."
         exit 1
    fi
}

# Ask common options (show trace)
ask_common_options() {
    local show_trace_flag=""
    if confirm "Show trace (--show-trace)?"; then
        show_trace_flag="--show-trace"
    fi
    echo "$show_trace_flag"
}

# --- Command Handlers ---

# Handle nixos-rebuild commands
handle_nixos_rebuild() {
    print_header "NixOS Rebuild"
    local action
    action=$(choose "Select nixos-rebuild action:" "switch" "boot" "test" "dry-build") || exit 1

    local flake_target
    flake_target=$(select_flake_target) || exit 1

    local trace_flag
    trace_flag=$(ask_common_options) || exit 1

    local cmd_args=("nixos-rebuild" "$action" "--flake" "${FLAKE_ROOT}${flake_target}")
    [[ -n "$trace_flag" ]] && cmd_args+=("$trace_flag")

    run_cmd --privileged "${cmd_args[@]}"
}

# Handle nh commands
handle_nh() {
    print_header "nh Helper"
    if ! command -v nh &>/dev/null; then
        print_error "'nh' command not found. Install it first (e.g., https://github.com/viperML/nh)."
        exit 1
    fi

    local nh_action
    nh_action=$(choose "Select nh action:" \
        "os boot" \
        "os switch" \
        "os test" \
        "os boot + home switch + reboot") || exit 1

    local trace_flag=""
    local cmd_args=("nh")
    local requires_privilege=false
    local needs_reboot=false

    case "$nh_action" in
        "os boot" | "os switch" | "os test")
            cmd_args+=("os" "${nh_action#os }") # Extract action part
            if confirm "Show trace (-- --show-trace)?"; then
                trace_flag="--show-trace"
                cmd_args+=("--" "$trace_flag")
            fi
            requires_privilege=true
            ;;
        "os boot + home switch + reboot")
            # This requires multiple steps
            print_info "This will run 'nh os boot', then 'nh home switch', then reboot."
            if confirm "Proceed?"; then
                print_info "Step 1: nh os boot"
                if run_cmd --privileged nh os boot; then
                    print_info "Step 2: nh home switch"
                    # nh home switch usually doesn't need sudo, but run_cmd handles confirmation
                    if run_cmd nh home switch; then
                         print_info "Step 3: Rebooting"
                         if confirm "Reboot now?"; then
                             run_cmd --privileged reboot
                         else
                             print_warning "Reboot cancelled. Please reboot manually later."
                         fi
                    else
                        print_error "'nh home switch' failed. Aborting sequence."
                        exit 1
                    fi
                else
                    print_error "'nh os boot' failed. Aborting sequence."
                    exit 1
                fi
            else
                print_warning "Operation cancelled."
            fi
            # Exit after handling this multi-step action
            exit 0
            ;;
        *)
            print_error "Invalid nh action selected."
            exit 1
            ;;
    esac

    if $requires_privilege; then
        run_cmd --privileged "${cmd_args[@]}"
    else
         # This case shouldn't be reached with current options, but keep for future
         run_cmd "${cmd_args[@]}"
    fi
}

# Handle home-manager commands
handle_home_manager() {
    print_header "Home Manager"
    local action="switch" # Only action currently supported

    local flake_target
    flake_target=$(select_flake_target) || exit 1

    local trace_flag
    trace_flag=$(ask_common_options) || exit 1

    local cmd_args=("home-manager" "$action" "--flake" "${FLAKE_ROOT}${flake_target}")
    [[ -n "$trace_flag" ]] && cmd_args+=("$trace_flag")

    # Home Manager usually doesn't require sudo
    run_cmd "${cmd_args[@]}"
}

# Handle nixos-anywhere command
handle_nixos_anywhere() {
    print_header "NixOS Anywhere Remote Deployment"
    print_warning "Ensure SSH access to the target is configured (key-based auth recommended)."

    local target_host_flake
    target_host_flake=$(input "Enter target Flake host name (e.g., 'my-remote-box'):" "hostname") || exit 1
    if [[ -z "$target_host_flake" ]]; then
        print_error "Target host Flake name cannot be empty."
        exit 1
    fi

    local target_user
    target_user=$(choose "Select SSH user for deployment:" "nixos" "root") || exit 1

    local target_ip
    target_ip=$(input "Enter target IP address or hostname:" "IP_or_hostname") || exit 1
     if [[ -z "$target_ip" ]]; then
        print_error "Target IP/hostname cannot be empty."
        exit 1
    fi

    local target_ssh_dest="${target_user}@${target_ip}"

    local generate_hw_config=false
    local hw_config_path=""
    if confirm "Generate hardware config on target?"; then
        generate_hw_config=true
        hw_config_path_default="./hosts/${target_host_flake}/hardware.nix"
        hw_config_path=$(input "Hardware config output path on target:" "$hw_config_path_default") || exit 1
        hw_config_path="${hw_config_path:-$hw_config_path_default}" # Use default if empty
        print_info "Hardware config will be generated at: ${C_YELLOW}${hw_config_path}${C_RESET} on the target machine."
        print_warning "Ensure the target path exists or nixos-generate-config can create it."
    fi

    local anywhere_rev="${NIXOS_ANYWHERE_REV:-github:nix-community/nixos-anywhere}" # Use configured or a default
    if confirm "Use a specific nixos-anywhere revision/source?"; then
        anywhere_rev_input=$(input "Enter nixos-anywhere source (e.g., nixpkgs#nixos-anywhere or github:owner/repo/rev):" "$anywhere_rev") || exit 1
        anywhere_rev="${anywhere_rev_input:-$anywhere_rev}" # Use default if empty
    fi


    local cmd_args=("nix" "run")
    # Add experimental features if needed for `nix run` (usually not needed for just running)
    # cmd_args+=("--extra-experimental-features" "nix-command flakes")
    cmd_args+=("$anywhere_rev" "--")
    cmd_args+=("--flake" "${FLAKE_ROOT}#${target_host_flake}")

    if $generate_hw_config; then
        cmd_args+=("--option" "hardware.flake" "github:nixos/nixos-hardware")
        print_warning "This command syntax for nixos-anywhere generate-hardware-config might need verification based on the tool's version."
        cmd_args+=("--build-on-remote") # Usually needed
        # The syntax changed. Let's try to adapt based on common patterns.
        # It might inject commands via SSH or have specific flags.
        # This is a placeholder - VERIFY THE CORRECT nixos-anywhere SYNTAX for config generation.
        # Option 1: Using --ssh-option or similar if available
        # cmd_args+=("--ssh-option" "SendEnv=NIXOS_GENERATE_CONFIG_ARGS='--force --root /mnt --dir ${hw_config_path%/*}'") # Example hypothetical syntax
        # Option 2: Passing commands directly if supported
        # cmd_args+=("--" "ssh" "$target_ssh_dest" "'mkdir -p ${hw_config_path%/*} && nixos-generate-config --root /mnt --dir ${hw_config_path%/*}'") # Another guess
        print_error "Hardware config generation via nixos-anywhere flags is complex and version-dependent."
        print_warning "Recommended: Run nixos-anywhere without generation first, then manually SSH in and run:"
        print_info "${C_YELLOW}nixos-generate-config --root /mnt --dir /etc/nixos ${C_RESET}(adjust path if needed)"
        print_info "Then copy the file back."
        if ! confirm "Try to proceed with potentially incorrect generation flags?"; then
             print_warning "Skipping hardware generation flag."
             generate_hw_config=false # Disable it if user aborts the attempt
        else
             # Add the arguments based on older understanding - MIGHT FAIL
             cmd_args+=("--generate-hardware-config" "nixos-generate-config ${hw_config_path}")
        fi

    fi

    cmd_args+=("$target_ssh_dest")


    print_info "Target Flake: ${C_YELLOW}${FLAKE_ROOT}#${target_host_flake}${C_RESET}"
    print_info "Target SSH Destination: ${C_YELLOW}${target_ssh_dest}${C_RESET}"
    print_info "Using nixos-anywhere source: ${C_YELLOW}${anywhere_rev}${C_RESET}"
    if $generate_hw_config; then
         print_info "Attempting Hardware Config Generation to: ${C_YELLOW}${hw_config_path}${C_RESET} (on target)"
    fi

    # nixos-anywhere does not need sudo locally
    run_cmd "${cmd_args[@]}"
}


# --- Main Execution Logic ---

# Ensure a command category was passed
if [[ $# -eq 0 ]]; then
    print_error "No command category specified."
    echo "Usage: $0 [os|home|nh|remote|config]"
    exit 1
fi

COMMAND_CATEGORY="$1"
shift # Remove the category from arguments

# Make sure FLAKE_ROOT exists if it's not just "."
if [[ "$FLAKE_ROOT" != "." ]] && [[ ! -d "$FLAKE_ROOT" ]]; then
   print_error "Flake directory specified in config does not exist: $FLAKE_ROOT"
   exit 1
fi
# Change to flake root directory context if specified and exists
# This simplifies flake path references like '.'
cd "$FLAKE_ROOT" || exit 1
print_info "Operating relative to flake path: $(pwd)"


case "$COMMAND_CATEGORY" in
    os)
        handle_nixos_rebuild "$@"
        ;;
    home)
        handle_home_manager "$@"
        ;;
    nh)
        handle_nh "$@"
        ;;
    remote)
        handle_nixos_anywhere "$@"
        ;;
    config)
        print_header "Configuration"
        print_info "Config file: ${CONFIG_FILE}"
        print_info "Flake root: $(pwd)"
        print_info "Privilege command: ${PAMT}"
        print_info "Using gum: ${USE_GUM}"
        print_info "Nixos-Anywhere Source: ${NIXOS_ANYWHERE_REV:-Not Set}"
        # Add more config display if needed
        ;;
    *)
        print_error "Unknown command category: $COMMAND_CATEGORY"
        echo "Available categories: os, home, nh, remote, config"
        exit 1
        ;;
esac

exit 0 # Explicitly exit with success if we reach here
