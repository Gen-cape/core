{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types optionalAttrs getExe;

  cfg = config.modules.ui;
  video = config.modules.system.video;
in {
  config = mkIf cfg.waylandBased {
    #environment.etc."greetd/environments".text = ''
    #  ${lib.optionalString (cfg.desktop == "Hyprland") "Hyprland"}
    #  zsh
    #'';
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString (cfg.desktop == "Hyprland") "Hyprland"}
      fish
    '';

    environment = {
      variables = {
        _JAVA_AWT_WM_NONEREPARENTING = "1";
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11";
        ANKI_WAYLAND = "1";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        #SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
      };
    };

    systemd = {
      services = {
        seatd = {
          enable = true;
          script = "${getExe pkgs.seatd} -g wheel";
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            RestartSec = "1";
          };
          wantedBy = ["multi-user.target"];
        };
      };
    };
  };
}
