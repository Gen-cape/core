#!/bin/bash

# --- Configuration ---
# !!! IMPORTANT: Replace this with the EXACT path to your controller device !!!
# Find it using 'ls /dev/input/by-id/' or tools like 'evtest'
DEVICE_PATH="/dev/input/by-id/usb-8BitDo_8BitDo_Ultimate_wireless_Controller_for_PC_E417D82A6DE4-event-joystick"

# Location to store the Process ID (PID) of the running loop
PID_FILE="/tmp/makima_macro_loop.pid"

# --- Timing Configuration ---
# You might need to adjust these timings based on the game/application
X_PRESS_DURATION=0.08   # How long X is held during the "tap"
WAIT_AFTER_X=0.43       # Pause after tapping X
LT_HOLD_DURATION=0.15   # How long LT (ABS_Z) is held at max value (255)
WAIT_AFTER_LT=0.30      # Pause after releasing LT
A_PRESS_DURATION=0.08   # How long A is held during the "tap"
WAIT_BEFORE_REPEAT=0.18 # Pause after tapping A before the whole sequence repeats (was WAIT_AFTER_A + LOOP_DELAY)

# --- End Configuration ---

# Function defining the macro sequence
run_macro_sequence() {
    echo "Sequence: Start" >&2 # Debug output

    # 1. Tap X button (BTN_NORTH)
    echo "  Step 1: Tap X (BTN_NORTH)" >&2
    evemu-event "$DEVICE_PATH" --type EV_KEY --code BTN_NORTH --value 1 --sync
    sleep "$X_PRESS_DURATION"
    evemu-event "$DEVICE_PATH" --type EV_KEY --code BTN_NORTH --value 0 --sync
    echo "    - X Released" >&2

    # 2. Wait after X
    echo "  Step 2: Wait after X (${WAIT_AFTER_X}s)" >&2
    sleep "$WAIT_AFTER_X"

    # 3. Press and Release LT (ABS_Z)
    echo "  Step 3: Press/Hold/Release LT (ABS_Z)" >&2
    #    Press LT fully (set to max value 255)
    evemu-event "$DEVICE_PATH" --type EV_ABS --code ABS_Z --value 255 --sync
    echo "    - LT Pressed (Value 255)" >&2
    #    Hold LT pressed
    sleep "$LT_HOLD_DURATION"
    #    Release LT (set back to 0)
    evemu-event "$DEVICE_PATH" --type EV_ABS --code ABS_Z --value 0 --sync
    echo "    - LT Released (Value 0)" >&2

    # 4. Wait after LT
    echo "  Step 4: Wait after LT (${WAIT_AFTER_LT}s)" >&2
    sleep "$WAIT_AFTER_LT"

    # 5. Tap A button (BTN_SOUTH)
    echo "  Step 5: Tap A (BTN_SOUTH)" >&2
    #    Press A
    evemu-event "$DEVICE_PATH" --type EV_KEY --code BTN_SOUTH --value 1 --sync
    sleep "$A_PRESS_DURATION"
    #    Release A
    evemu-event "$DEVICE_PATH" --type EV_KEY --code BTN_SOUTH --value 0 --sync
    echo "    - A Released" >&2

    # 6. Wait before repeating the entire sequence
    echo "  Step 6: Wait before repeat (${WAIT_BEFORE_REPEAT}s)" >&2
    sleep "$WAIT_BEFORE_REPEAT"
    echo "Sequence: End" >&2 # Debug output
}

# Function for the continuous loop
run_loop() {
    # Ensure the device exists and we have permissions before looping
    if [ ! -c "$DEVICE_PATH" ]; then
       echo "ERROR: Device path '$DEVICE_PATH' does not exist or is not a character device." >&2
       echo "Verify the path in the Configuration section." >&2
       rm -f "$PID_FILE" # Clean up PID file if we created it erroneously
       exit 1
    fi
     if [ ! -w "$DEVICE_PATH" ]; then
       echo "ERROR: Device path '$DEVICE_PATH' is not writable." >&2
       echo "Check permissions (you might need to run as root or add your user to the 'input' group)." >&2
       rm -f "$PID_FILE" # Clean up PID file if we created it erroneously
       exit 1
    fi


    echo "Starting macro loop for device: $DEVICE_PATH" >&2
    while true; do
        run_macro_sequence
        # Note: The main delay between loops is now WAIT_BEFORE_REPEAT inside run_macro_sequence
        # We keep a minimal safety sleep here in case run_macro_sequence exits unexpectedly.
        sleep 0.01
    done
}

# --- Main Logic ---
# Check if the script is already running
if [ -f "$PID_FILE" ]; then
    # PID file exists, try to stop the running process.
    PID=$(cat "$PID_FILE")
    echo "PID file found ($PID_FILE). Attempting to stop macro loop (PID: $PID)..." >&2
    # Check if the process actually exists before trying to kill
    if ps -p "$PID" > /dev/null; then
        kill "$PID"
        # Wait a moment for the process to terminate gracefully
        sleep 0.5
        # Check again, force kill if still running
        if ps -p "$PID" > /dev/null; then
            echo "Process $PID did not stop gracefully, sending KILL signal (-9)..." >&2
            kill -9 "$PID"
            sleep 0.2 # Give OS time to process kill -9
        fi

        # Verify if killed
        if ps -p "$PID" > /dev/null; then
             echo "ERROR: Failed to kill process $PID." >&2
             # Don't remove PID file if kill failed
        else
             echo "Macro loop (PID: $PID) stopped successfully." >&2
             rm -f "$PID_FILE" # Remove the PID file only if successfully stopped
        fi
    else
        echo "Warning: Process $PID not found. Maybe it crashed or was stopped manually?" >&2
        echo "Removing stale PID file: $PID_FILE" >&2
        rm -f "$PID_FILE" # Remove the stale PID file
    fi
    # notify-send "Controller Macro Stopped" # Uncomment if you have notify-send installed
else
    # PID file does not exist. Start the loop in the background.
    echo "Starting macro loop in background..." >&2
    # Run the loop function in the background
    run_loop &
    LOOP_PID=$!  # Get the PID of the background process
    # Check if the background process actually started
    # Give it a tiny moment to potentially fail (e.g., permissions)
    sleep 0.1
    if ps -p "$LOOP_PID" > /dev/null; then
        echo "$LOOP_PID" > "$PID_FILE" # Store the PID in the file
        echo "Macro loop started with PID: $LOOP_PID. PID stored in $PID_FILE." >&2
        echo "Run this script again to stop." >&2
        # notify-send "Controller Macro Started (Looping)" # Uncomment if you have notify-send installed
    else
        echo "ERROR: Failed to start the macro loop in the background." >&2
        echo "Check script output/logs for errors (like permissions or wrong device path)." >&2
        # PID file should not have been created by the failed 'run_loop', but double-check
        rm -f "$PID_FILE"
        exit 1
    fi
fi

exit 0
