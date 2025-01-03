{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.ui;
  vd = config.modules.system.video;
  hyprlandPkg = cfg.desktops.hyprland.package;
in {
  disabledModules = ["programs/hyprland.nix"];

  config = mkIf (vd.enable && cfg.desktop == "hyprland") {
    services.displayManager.sessionPackages = [hyprlandPkg];

    xdg.portal = {
      enable = true;
      configPackages = [hyprlandPkg];
      extraPortals = [
        (inputs'.xdg-portal-hyprland.packages.xdg-desktop-portal-hyprland.override {
          hyprland = hyprlandPkg;
        })
      ];
    };
    security.pam.services.swaylock = {};
    security.pam.services.swaylock.fprintAuth = false;
  };
}
