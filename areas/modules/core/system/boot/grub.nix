{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;

  cfg = config.modules.system.boot;
in {
  config = mkIf (cfg.opinionatedGrub) {
    boot.loader = {
      grub = {
        enable = mkDefault true;
        useOSProber = true;
        efiSupport = true;
        device = cfg.grubDevice;
        theme = "${
          pkgs.fetchFromGitHub {
            owner = "olivethepuffin";
            repo = "yorha-grub-theme";
            rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
            hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
          }
          #}/yorha-3840x2160/";
          #}/yorha-1920x1080/";
        }/yorha-2560x1440/";

        splashImage = "${
          pkgs.fetchFromGitHub {
            owner = "olivethepuffin";
            repo = "yorha-grub-theme";
            rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
            hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
          }
        }/yorha-2560x1440/background.png";
        configurationLimit = 2;
      };
    };
  };
}
