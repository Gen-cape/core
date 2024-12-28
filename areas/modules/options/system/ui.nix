{
  inputs',
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool enum package;
  cfg = config.modules.ui;
  sys = config.modules.system;
in {
  options.modules.ui = {
    desktop = mkOption {
      type = enum ["none" "hyprland"];
      default = "none";
      description = "desktop env to use";
    };
    desktops = {
      hyprland = {
        enable = mkOption {
          type = bool;
          default = cfg.desktop == "hyprland";
          description = "auto set to true when enum desktop set to hyprland";
        };
        package = mkOption {
          type = package;
          default = inputs'.hyprland.packages.hyprland;
          #default = pkgs.hyprland;
          description = "the hyprland package to use";
        };
      };
    };
    waylandBased = mkOption {
      type = bool;
      default = cfg.desktops.hyprland.enable;
      description = "wayland exclusive packages";
    };
    useHomeManager = mkOption {
      type = bool;
      default = true;
      description = "enable home manager module, needs main user option to be set";
    };

    programs = {
      screenlock = {
        swaylock.enable = mkEnableOption "";

        package = mkOption {
          type = package;
          readOnly = true;
          default = pkgs.swaylock-effects;
        };
      };
      ags.enable = mkEnableOption {
        default = false;
        description = "Enable AGS";
      };
    };
  };
}
