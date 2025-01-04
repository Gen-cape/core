{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.core.swapFile;
in {
  options.core.swapFile = {
    enable = mkEnableOption "Whether to enable swap file";
    size = mkOption {
      type = lib.types.int;
      default = 16;
      description = "Size of swap file in GiB";
    };
  };
  config = mkIf cfg.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = cfg.size * 1024;
      }
    ];
  };
}
