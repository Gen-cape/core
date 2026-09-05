{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optionals concatLists;
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wluma
    hypridle
    brightnessctl
    pamixer
    playerctl
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof noctalia-lock || noctalia-shell --lock"; # or hyprlock / swaylock
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "mangoctl output * dpms on"; # wake display via MangoWM IPC
      };

      listener = [
        # Dim screen / reduce brightness
        {
          timeout = 150; # 2.5 min
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        # Lock session
        {
          timeout = 300; # 5 min
          on-timeout = "loginctl lock-session";
        }
        # Turn off display (DPMS)
        {
          timeout = 330; # 5.5 min
          on-timeout = "mangoctl output * dpms off";
          on-resume = "mangoctl output * dpms on";
        }
        # Suspend to RAM
        {
          timeout = 600; # 10 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
