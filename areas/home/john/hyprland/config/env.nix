{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland,x11"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        #"SDL_VIDEODRIVER,wayland,x11"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      monitor = [
        ",preferred,auto,auto"
      ];
    };
  };
}
