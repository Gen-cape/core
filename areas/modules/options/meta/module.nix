{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr bool str strMatching;

  env = config.modules.ui;
in {
  options.meta = {
    hostname = mkOption {
      type = str;
      default = config.networking.hostname;
    };

    system = mkOption {
      type = str;
      default = pkgs.stdenv.system;
      readOnly = true;
    };

    waylandBased = mkOption {
      type = bool;
      default = with env.desktops; (hyprland.enable);
    };
  };
}
