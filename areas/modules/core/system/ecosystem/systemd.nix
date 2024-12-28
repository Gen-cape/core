{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;
in {
  config = {
    systemd = {
      oomd = {
        enableRootSlice = true;
        enableSystemSlice = true;
        enableUserSlices = true;
        extraConfig = {
          "DefaultMemoryPressureDurationSec" = "20s";
        };
      };
    };
    # IMPORTANT to tinker
    #services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
  };
}
