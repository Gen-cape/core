{
  writeShellScriptBin,
  gpu-screen-recorder,
  coreutils,
  killall,
}: let
  # Function to get Russian month name
  get-month-name = writeShellScriptBin "get-month-name" ''
    case "$1" in
      "01") echo "января" ;;
      "02") echo "февраля" ;;
      "03") echo "марта" ;;
      "04") echo "апреля" ;;
      "05") echo "мая" ;;
      "06") echo "июня" ;;
      "07") echo "июля" ;;
      "08") echo "августа" ;;
      "09") echo "сентября" ;;
      "10") echo "октября" ;;
      "11") echo "ноября" ;;
      "12") echo "декабря" ;;
    esac
  '';

  # Helper script for replay buffer recording
  start-replay = writeShellScriptBin "start-replay" ''
    year="$(${coreutils}/bin/date +%Y)"
    month="$(${coreutils}/bin/date +%m)"
    day="$(${coreutils}/bin/date +%d)"
    month_name="$(${get-month-name}/bin/get-month-name $month)"
    dated_dir="$year-$month-$day"

    mkdir -p ~/Videos/Replays/"$dated_dir"

    ${gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w screen \
      -f 60 \
      -q medium \
      -k h264 \
      -a default_output \
      -c mp4 \
      -r 30 \
      -o ~/Videos/Replays/"$dated_dir"
  '';

  # Helper script for regular recording (120 fps)
  start-recording = writeShellScriptBin "start-recording" ''
    year="$(${coreutils}/bin/date +%Y)"
    month="$(${coreutils}/bin/date +%m)"
    day="$(${coreutils}/bin/date +%d)"
    month_name="$(${get-month-name}/bin/get-month-name $month)"
    timestamp="$(${coreutils}/bin/date +%H-%M-%S)"
    dated_dir="$year-$month-$day"

    mkdir -p ~/Videos/Recordings/"$dated_dir"

    ${gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w screen \
      -f 120 \
      -q high \
      -k h264 \
      -a default_output \
      -o ~/Videos/Recordings/"$dated_dir/Recording_$timestamp.mp4"
  '';

  # Helper script for regular recording (60 fps)
  start-recording-60 = writeShellScriptBin "start-recording-60" ''
    year="$(${coreutils}/bin/date +%Y)"
    month="$(${coreutils}/bin/date +%m)"
    day="$(${coreutils}/bin/date +%d)"
    month_name="$(${get-month-name}/bin/get-month-name $month)"
    timestamp="$(${coreutils}/bin/date +%H-%M-%S)"
    dated_dir="$year-$month-$day"

    mkdir -p ~/Videos/Recordings/"$dated_dir"

    ${gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w screen \
      -f 60 \
      -q high \
      -k h264 \
      -a default_output \
      -o ~/Videos/Recordings/"$dated_dir/Recording_$timestamp.mp4"
  '';

  # Helper script for stopping recording/replay
  stop-recording = writeShellScriptBin "stop-recording" ''
    ${killall}/bin/killall -SIGINT gpu-screen-recorder
  '';

  # Helper script for saving replay
  save-replay = writeShellScriptBin "save-replay" ''
    ${killall}/bin/killall -SIGUSR1 gpu-screen-recorder
  '';

  # Helper script for pausing/unpausing recording
  toggle-pause-recording = writeShellScriptBin "toggle-pause-recording" ''
    ${killall}/bin/killall -SIGUSR2 gpu-screen-recorder
  '';
in {
  inherit start-replay start-recording start-recording-60 stop-recording save-replay toggle-pause-recording;
}
