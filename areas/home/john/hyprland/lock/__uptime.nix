{writeShellScriptBin, ...}:
writeShellScriptBin "get-uptime" ''
  if [[ -r /proc/uptime ]]; then
    s=$(< /proc/uptime)
    s=''${s/.*}
  else
    echo "Error: Uptime could not be determined." >&2
    exit 1
  fi

  d="$((s / 60 / 60 / 24)) days"
  h="$((s / 60 / 60 % 24)) hours"
  m="$((s / 60 % 60)) minutes"

  # Remove plural if < 2
  ((''${d/ *} == 1)) && d=''${d/s}
  ((''${h/ *} == 1)) && h=''${h/s}
  ((''${m/ *} == 1)) && m=''${m/s}

  # Build uptime string with line breaks
  uptime_str=""
  if [[ -n "$d" ]]; then
    uptime_str="$d\n"
  fi

  # Remove trailing comma and spaces
  uptime_str=''${uptime_str%*, }

  # Print formatted uptime
  echo -e "Keep up! $uptime_str"
''
