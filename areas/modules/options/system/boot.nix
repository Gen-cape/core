{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.modules.system.boot;
in {
  options.modules.system.boot = {
    silent = mkEnableOption "Make boot silent";

    saneDefaults = mkEnableOption "Make it comfy!";

    kernel = mkOption {
      type = with types; nullOr raw;
      default = pkgs.linuxPackages_latest;
      description = "Kernel to use";
    };

    enableKernelTweaks = mkEnableOption "make your kernel comfy!";

    opinionatedGrub = mkEnableOption "Grub with my settings";

    grubDevice = mkOption {
      type = with types; nullOr str;
      default = "nodev";
      description = "The device to install the bootloader to.";
    };

    extraKernelParams = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Extra kernel parameters to be added to the kernel command line.";
    };
  };
}
