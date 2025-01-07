{
  writeShellScriptBin,
  wl-clipboard,
  libnotify,
  wtype,
  lib,
  ...
}: let
  spread-propaganda = writeShellScriptBin "spread-propaganda" ''
    cat ${./propaganda.txt} | ${wl-clipboard}/bin/wl-copy \
      && ${libnotify}/bin/notify-send "Propaganda" "ready to spread!" \
      && sleep 0.3 \
      && ${lib.getExe wtype} -M ctrl -M shift -k v -m shift -m ctrl -s 300 -k Return
  '';
in {inherit spread-propaganda;}
