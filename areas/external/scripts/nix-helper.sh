#!/usr/bin/env bash
#scripts/nix-helper.sh
set -eo pipefail # Use -e to exit on error, -o pipefail for pipe safety

# --- Configuration & Setup ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/nix-helper.cfg"
FLAKE_ROOT_CONFIG_DEFAULT="." # Default relative path to flake from config

# Source configuration if it exists
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=scripts/nix-helper.cfg
    source "$CONFIG_FILE"
fi

# Determine Flake Root (use config default or override)
# Use the variable name from the config file: DEFAULT_FLAKE_PATH
FLAKE_ROOT_REL_PATH="${DEFAULT_FLAKE_PATH:-$FLAKE_ROOT_CONFIG_DEFAULT}"

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
    # Source Gum specific env vars from config if they exist and we're using gum
    if [[ -f "$CONFIG_FILE" ]]; then
        # This simple sourcing assumes the export lines are safe.
        # More robust would be to parse specific vars, but let's keep it simple.
         grep '^export GUM_' "$CONFIG_FILE" > /tmp/gum_config_exports.sh
         # shellcheck source=/tmp/gum_config_exports.sh
         source /tmp/gum_config_exports.sh
         rm /tmp/gum_config_exports.sh
    fi
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
                # Check if opt is empty (can happen in some shells if input is just Enter)
                if [[ -z "$opt" ]]; then
                    echo "${C_RED}Invalid selection. Please choose a number.${C_RESET}" >&2
                else
                    echo "$opt"
                    return 0
                fi
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
        # Use --height to prevent issues with long lists
        local choice
        choice=$(gum choose --header "$1" --height 15 "${@:2}") || return 1 # Return error on ESC/cancel
        echo "$choice" # Gum outputs selection to stdout
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
        # Gum returns 0 for yes, 1 for no/ESC
        gum confirm "$1"
    else
        gum_confirm_fallback "$@"
    fi
}

# Get text input
# Usage: input "Prompt" ["Placeholder"]
# Returns the input string
gum_input_fallback() {
    local prompt="$1"
    local placeholder="${2:-}" # Use provided placeholder or empty string
    local input_val=""
    if [[ -n "$placeholder" ]]; then
        read -rp "${C_CYAN}${prompt} ${C_BR_BLACK}[${placeholder}]: ${C_RESET}" input_val
    else
         read -rp "${C_CYAN}${prompt}: ${C_RESET}" input_val
    fi
    echo "$input_val"
}
input() {
    if $USE_GUM; then
        # Gum automatically handles cancellation (ESC)
        gum input --prompt "$1 " --placeholder "${2:-}"
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
    if [ -n "$USE_GUM" ]; then
      TTY=$(tty)
    else
      TTY=''
    fi

    if $USE_GUM && [ -n "$TTY" ]; then
        # Gum password needs a tty
        gum input --password --prompt "$1: " < "$TTY"
    else
        if $USE_GUM && [ -z "$TTY" ]; then
            print_warning "Cannot use 'gum password' without a TTY, falling back to 'read -s'."
        fi
        gum_password_fallback "$@"
    fi
}

# Spin while command executes (Fallback Definition)
gum_spin_fallback() {
    local title="$1"
    shift
    echo "${C_CYAN}Running: ${title}...${C_RESET}"
    "$@" # Execute command directly
}

# Spin while command executes (Main Function)
# Usage: spin "Title" command args...
spin() {
    local title="$1"
    shift # Remove title from argument list $@

    if $USE_GUM; then
        # Correct usage: gum spin [OPTIONS] -- <COMMAND> [ARGS...]
        # The command and its arguments MUST come after the --
        # "$@" now contains the actual command and its arguments
        #Spinner options: line, dot, minidot, jump, pulse, points, glob, moon, monkey, meter, hamburger
        gum spin --spinner dot --title "$title" --show-output -- "$@"
    else
        # Fallback just needs the original arguments (title + command + args)
        # We need to call it with the original title and the shifted args "$@"
        gum_spin_fallback "$title" "$@"
    fi
    # Return the exit code of the executed command
    return $?
}


# --- Helper Functions ---
print_header() {
    local title="$1"
    if $USE_GUM; then
        gum style --border rounded --border-foreground "$COLOR_BLUE" --padding "1 2" --margin "1 0" "${C_BOLD}${C_BR_CYAN}${title}${C_RESET}"
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
    # Use printf %q to safely quote arguments for display
    local cmd_str_display
    cmd_str_display=$(printf "%q " "$@")

    echo "${C_BR_BLACK}Executing: ${use_privilege:+${PAMT} }${cmd_str_display}${C_RESET}"

    if confirm "Proceed with execution?"; then
        local spin_title="Task"
        if $use_privilege; then
             spin_title="Privileged Task"
             # Pass PAMT as the command, and the original command+args as its arguments
             spin "$spin_title" "$PAMT" "$@"
        else
             spin_title="Normal Task"
             # Pass the command and its arguments directly
             spin "$spin_title" "$@"
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
    target_type=$(choose "Select Flake Target:" "$default_dot" "$specific_host") || return 1 # Return error code if choose fails

    if [[ "$target_type" == "$default_dot" ]]; then
        echo "."
        return 0
    elif [[ "$target_type" == "$specific_host" ]]; then
        local host_name
        host_name=$(input "Enter host name (e.g., 'my-server'):" "hostname") || return 1
        if [[ -z "$host_name" ]]; then
            print_error "Host name cannot be empty."
            return 1
        fi
        # Ensure it starts with .#
        if [[ "$host_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
             echo ".#${host_name}"
             return 0
        else
            print_error "Invalid host name format."
            return 1
        fi
    else
         # This case might be reachable if `choose` returns unexpected empty string
         print_error "Invalid selection or cancelled."
         return 1
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
    # Removed dry-run because it's often not privileged, handled separately if needed
    action=$(choose "Select nixos-rebuild action:" "switch" "boot" "test") || exit 1 # Exit if choose fails

    local flake_target
    flake_target=$(select_flake_target) || exit 1 # Exit if select fails

    local trace_flag
    trace_flag=$(ask_common_options) # Don't exit if options are cancelled

    # CORRECTED: Use flake_target directly, as we are already in FLAKE_ROOT
    local cmd_args=("nixos-rebuild" "$action" "--flake" "${flake_target}")
    [[ -n "$trace_flag" ]] && cmd_args+=("$trace_flag")

    run_cmd --privileged "${cmd_args[@]}"
}

# Handle nixos-rebuild dry-run (separately as it's often not privileged)
handle_nixos_dry_run() {
     print_header "NixOS Dry Run"
     local flake_target
     flake_target=$(select_flake_target) || exit 1 # Exit if select fails

     local trace_flag
     trace_flag=$(ask_common_options) # Don't exit if options are cancelled

     # CORRECTED: Use flake_target directly
     local cmd_args=("nixos-rebuild" "dry-build" "--flake" "${flake_target}")
     [[ -n "$trace_flag" ]] && cmd_args+=("$trace_flag")

     run_cmd "${cmd_args[@]}" # No --privileged needed for dry-run
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
    # local needs_reboot=false # Removed as not directly used

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
            if confirm "Proceed with multi-step operation?"; then
                print_info "Step 1: nh os boot"
                # Run directly using run_cmd which handles confirmation and privilege
                if run_cmd --privileged nh os boot; then
                    print_info "Step 2: nh home switch"
                    # nh home switch usually doesn't need sudo
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
                print_warning "Multi-step operation cancelled."
            fi
            # Exit after handling this multi-step action
            exit 0
            ;;
        *)
            print_error "Invalid nh action selected."
            exit 1
            ;;
    esac

    # Execute single-step nh commands that require privilege
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
    trace_flag=$(ask_common_options)

    # CORRECTED: Use flake_target directly
    local cmd_args=("home-manager" "$action" "--flake" "${flake_target}")
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

    # Removed hardware config generation due to complexity and variability in nixos-anywhere
    print_info "Note: Hardware config generation via flags is removed."
    print_info "Run deploy first, then SSH manually:"
    print_info "${C_YELLOW}ssh ${target_ssh_dest}${C_RESET}"
    print_info "And run: ${C_YELLOW}nixos-generate-config --root /mnt --dir /etc/nixos${C_RESET} (adjust paths if needed)"

    local anywhere_rev="${NIXOS_ANYWHERE_REV:-github:nix-community/nixos-anywhere}" # Use configured or a default
    if confirm "Use a specific nixos-anywhere revision/source?"; then
        anywhere_rev_input=$(input "Enter nixos-anywhere source:" "$anywhere_rev") || exit 1 # Assume cancel means use default
        anywhere_rev="${anywhere_rev_input:-$anywhere_rev}" # Use default if empty or cancelled
    fi


    local cmd_args=("nix" "run")
    cmd_args+=("--extra-experimental-features" "nix-command flakes") # Often needed by nix run
    cmd_args+=("$anywhere_rev" "--")
    # CORRECTED: Use .#hostname for the flake target
    cmd_args+=("--flake" ".#${target_host_flake}")
    cmd_args+=("--build-on-remote") # Usually needed/desired

    cmd_args+=("$target_ssh_dest")


    print_info "Target Flake: ${C_YELLOW}.#${target_host_flake}${C_RESET}"
    print_info "Target SSH Destination: ${C_YELLOW}${target_ssh_dest}${C_RESET}"
    print_info "Using nixos-anywhere source: ${C_YELLOW}${anywhere_rev}${C_RESET}"

    # nixos-anywhere does not need sudo locally
    run_cmd "${cmd_args[@]}"
}


# --- Main Execution Logic ---

# Ensure a command category was passed
if [[ $# -eq 0 ]]; then
    print_error "No command category specified."
    echo "Usage: $0 [os|dryrun|home|nh|remote|config]"
    exit 1
fi

COMMAND_CATEGORY="$1"
shift # Remove the category from arguments

# --- Change to Flake Root Directory ---
# Resolve the relative path from the script's dir to an absolute path
ABS_FLAKE_ROOT="$(cd "${SCRIPT_DIR}/${FLAKE_ROOT_REL_PATH}" &>/dev/null && pwd)"

if [[ -z "$ABS_FLAKE_ROOT" ]] || [[ ! -d "$ABS_FLAKE_ROOT" ]]; then
   print_error "Flake directory specified in config ('${FLAKE_ROOT_REL_PATH}') does not resolve to a valid directory from script location."
   exit 1
fi

# Change to the absolute flake root directory context
cd "$ABS_FLAKE_ROOT" || { print_error "Failed to change directory to flake root: ${ABS_FLAKE_ROOT}"; exit 1; }
print_info "Operating relative to flake path: ${C_YELLOW}$(pwd)${C_RESET}"
# --- End Change Directory ---


# --- Execute Command Category Handler ---
case "$COMMAND_CATEGORY" in
    os)
        handle_nixos_rebuild "$@"
        ;;
    dryrun)
        handle_nixos_dry_run "$@"
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
        print_info "Config file found: ${CONFIG_FILE}"
        print_info "Resolved Flake root: $(pwd)"
        print_info "Privilege command: ${PAMT}"
        print_info "Using gum: ${USE_GUM}"
        print_info "Nixos-Anywhere Source: ${NIXOS_ANYWHERE_REV:-Not Set in config}"
        # Add more config display if needed
        ;;
    *)
        print_error "Unknown command category: $COMMAND_CATEGORY"
        echo "Available categories: os, dryrun, home, nh, remote, config"
        exit 1
        ;;
esac

exit $? # Exit with the status of the last executed command handler
