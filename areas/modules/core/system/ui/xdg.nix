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
  config = mkIf video.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      #common = let
      #  portal =
      #    if cfg.desktop == "hyprland"
      #    then "hyprland"
      #    else if cfg.desktop == "sway"
      #    then "wlr"
      #    else "gtk"; # FIXME: does this actually implement what we need?
      #in {
      #  default = ["gtk"];
      #  "org.freedesktop.impl.portal.Screencast" = ["${portal}"];
      #  "org.freedesktop.impl.portal.Screenshot" = ["${portal}"];
      #};
    };

    programs.xwayland.enable = true;
  };
}
