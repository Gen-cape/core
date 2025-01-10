{
  writeShellScriptBin,
  waybar,
  ...
}:
writeShellScriptBin "reload-graphical-interface" ''
  _ps=(waybar rofi)
  for _prs in "''${_ps[@]}"; do
      if pidof "''${_prs}" >/dev/null; then
          pkill "''${_prs}"
      fi
  done

  ${waybar}/bin/waybar > /dev/null 2>&1 &

  exit 0
''
