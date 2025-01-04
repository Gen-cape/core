{osConfig, ...}: let
  inherit (osConfig) modules;
  # theming
  #inherit (modules.style) pointerCursor;
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww-daemon &"
      # "spoofdpi &"
      "pypr &"
      #"waybar &"
      # set cursor for HL itself
      #"hyprctl setcursor ${pointerCursor.name} ${toString pointerCursor.size}"
    ];
  };
}
