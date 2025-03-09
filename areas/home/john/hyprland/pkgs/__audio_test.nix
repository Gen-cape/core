# audio-scripts.nix
{
  writeShellScriptBin,
  pulseaudio,
  mpv,
  libnotify,
}: let
  play-audio-to-mic = writeShellScriptBin "play-audio-to-mic" ''
    # Get the audio file and volume from arguments
    AUDIO_FILE="$1"
    VOLUME="''${2:-20}"  # Default to 20% if not specified

    # Check if the file exists
    if [ ! -f "$AUDIO_FILE" ]; then
      echo "Error: File $AUDIO_FILE not found!"
      ${libnotify}/bin/notify-send "Audio Error" "File $AUDIO_FILE not found!"
      exit 1
    fi

    echo "Setting up virtual microphone for playback..."

    # Get the current default source (your real microphone)
    DEFAULT_SOURCE=$(${pulseaudio}/bin/pactl info | grep "Default Source" | cut -d: -f2 | tr -d ' ')

    # Get all current source-outputs (applications recording audio) and their sources
    mapfile -t sources < <(${pulseaudio}/bin/pactl list short sources)
    declare -A source_map
    for line in "''${sources[@]}"; do
      index=$(echo $line | awk '{print $1}')
      name=$(echo $line | awk '{print $2}')
      source_map[$index]=$name
    done

    source_outputs=$(${pulseaudio}/bin/pactl list source-outputs)
    declare -A original_sources
    while read -r line; do
      if [[ $line =~ ^Source\ Output\ \#([0-9]+) ]]; then
        index=''${BASH_REMATCH[1]}
      elif [[ $line =~ ^Source:\ ([0-9]+) ]]; then
        source_index=''${BASH_REMATCH[1]}
        original_sources[$index]=''${source_map[$source_index]}
      fi
    done <<< "$source_outputs"

    # Create a null sink for audio playback
    module_id=$(${pulseaudio}/bin/pactl load-module module-null-sink sink_name=audio_playback_sink)
    monitor_source="audio_playback_sink.monitor"

    # Set the volume of the sink to the specified percentage
    echo "Setting virtual sink volume to $VOLUME%"
    ${pulseaudio}/bin/pactl set-sink-volume audio_playback_sink "$VOLUME%"

    # Move all source-outputs to the virtual source
    for so_index in "''${!original_sources[@]}"; do
      echo "Moving source-output $so_index to virtual source"
      ${pulseaudio}/bin/pactl move-source-output $so_index $monitor_source
    done

    # Set the default source to the virtual source for new recordings
    echo "Setting default source to virtual microphone"
    ${pulseaudio}/bin/pactl set-default-source $monitor_source

    # Play the audio file to the null sink
    echo "Playing $AUDIO_FILE to virtual sink at $VOLUME% volume"
    ${mpv}/bin/mpv --audio-device=pulse/audio_playback_sink "$AUDIO_FILE"
    MPV_EXIT=$?

    if [ $MPV_EXIT -ne 0 ]; then
      echo "Error: mpv failed to play $AUDIO_FILE (exit code: $MPV_EXIT)"
      ${libnotify}/bin/notify-send "Audio Error" "mpv failed to play $AUDIO_FILE"
    else
      echo "Audio playback finished successfully"
    fi

    # Restore all source-outputs to their original sources
    for so_index in "''${!original_sources[@]}"; do
      echo "Restoring source-output $so_index to original source"
      ${pulseaudio}/bin/pactl move-source-output $so_index ''${original_sources[$so_index]}
    done

    # Restore the default source
    echo "Restoring default source to $DEFAULT_SOURCE"
    ${pulseaudio}/bin/pactl set-default-source $DEFAULT_SOURCE

    # Clean up by unloading the null sink
    echo "Cleaning up virtual sink"
    ${pulseaudio}/bin/pactl unload-module $module_id

    echo "Script completed!"
  '';
in {
  inherit play-audio-to-mic;
}
