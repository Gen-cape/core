{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  inherit (lib.types) package;
in {
  options.modules.system.programs = {
    gui.enable = mkEnableOption "" // {default = true;};
    default = {
      terminal = mkOption {
        type = types.enum ["foot" "kitty" "alacritty"];
        default = "alacritty";
      };
      fileManager = mkOption {
        type = types.enum ["thunar" "dolphin"];
        default = "dolphin";
      };
      screenlock = {
        swaylock.enable = mkEnableOption "";

        package = mkOption {
          type = package;
          readOnly = true;
          default = pkgs.swaylock-effects;
        };
      };
    };
  };
}
